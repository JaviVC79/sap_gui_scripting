#include <mutex>
#include <unordered_map>
#include "v4.h"

// ==========================================
// 1. GLOBAL REGISTRY MANAGEMENT
// ==========================================
static std::unordered_map<uint64_t, SapObject> g_objects;
static std::mutex g_mutex;
static uint64_t g_nextId = 1;

static SapObject *getObj(uint64_t h)
{
    std::lock_guard<std::mutex> lock(g_mutex);
    auto it = g_objects.find(h);
    return (it == g_objects.end()) ? nullptr : &it->second;
}

static uint64_t registerNewObj(SapObject &&obj)
{
    if (!obj.isValid())
        return 0;

    std::lock_guard<std::mutex> lock(g_mutex);
    uint64_t id = g_nextId++;
    g_objects[id] = std::move(obj);
    return id;
}

static wchar_t *stringToWchar(const std::wstring &s)
{
    wchar_t *res = (wchar_t *)malloc((s.length() + 1) * sizeof(wchar_t));
    if (res)
        wcscpy_s(res, s.length() + 1, s.c_str());
    return res;
}

// ==========================================
// 2. SAPOBJECT IMPLEMENTATION
// ==========================================
SapObject::SapObject(std::shared_ptr<ComStaDispatcher> d, DispHandle h) : dispatcher(d), handle(h) {}

SapObject::~SapObject()
{
    if (handle != 0 && dispatcher)
    {
        dispatcher->enqueue([d = dispatcher, h = handle]()
                            { d->releaseDisp(h); });
    }
}

SapObject::SapObject(SapObject &&other) noexcept
    : dispatcher(std::move(other.dispatcher)), handle(other.handle)
{
    other.handle = 0;
}

SapObject &SapObject::operator=(SapObject &&other) noexcept
{
    if (this != &other)
    {
        if (handle != 0 && dispatcher)
        {
            dispatcher->enqueue([d = dispatcher, h = handle]()
                                { d->releaseDisp(h); });
        }
        dispatcher = std::move(other.dispatcher);
        handle = other.handle;
        other.handle = 0;
    }
    return *this;
}

SapObject SapObject::connect()
{
    // Shared dispatcher — created once, reused by ALL callers
    // (main isolate, spawned isolates, etc.). This avoids
    // CoInitializeEx failures on threads created by Dart isolates.
    static std::shared_ptr<ComStaDispatcher> s_disp = []() {
        auto d = std::make_shared<ComStaDispatcher>();
        if (!d->start()) return std::shared_ptr<ComStaDispatcher>(nullptr);
        return d;
    }();

    if (!s_disp) return SapObject();

    auto disp = s_disp;

    DispHandle hApp = disp->enqueueResult([disp]() -> DispHandle
                                          {
        CLSID clsid;
        if (FAILED(CLSIDFromProgID(L"SapROTWr.SapROTWrapper", &clsid))) return 0;
        
        IDispatch* pWrapper = nullptr;
        if (FAILED(CoCreateInstance(clsid, NULL, CLSCTX_ALL, IID_IDispatch, (void**)&pWrapper))) return 0;

        DISPID dispid;
        LPOLESTR methodRot = (LPOLESTR)L"GetROTEntry";
        VARIANT vRes; VariantInit(&vRes);
        _variant_t arg(L"SAPGUI");
        DISPPARAMS dp = { &arg, NULL, 1, 0 };

        if (SUCCEEDED(pWrapper->GetIDsOfNames(IID_NULL, &methodRot, 1, LOCALE_USER_DEFAULT, &dispid))) {
            pWrapper->Invoke(dispid, IID_NULL, LOCALE_USER_DEFAULT, DISPATCH_METHOD, &dp, &vRes, NULL, NULL);
        }
        pWrapper->Release();

        if (vRes.vt != VT_DISPATCH || !vRes.pdispVal) return 0;
        IDispatch* pRot = vRes.pdispVal;

        LPOLESTR methodEng = (LPOLESTR)L"GetScriptingEngine";
        VARIANT vApp; VariantInit(&vApp);
        DISPPARAMS dpEmpty = { NULL, NULL, 0, 0 };
        if (SUCCEEDED(pRot->GetIDsOfNames(IID_NULL, &methodEng, 1, LOCALE_USER_DEFAULT, &dispid))) {
            pRot->Invoke(dispid, IID_NULL, LOCALE_USER_DEFAULT, DISPATCH_METHOD, &dpEmpty, &vApp, NULL, NULL);
        }
        pRot->Release();

        return (vApp.vt == VT_DISPATCH) ? disp->addDisp(vApp.pdispVal) : 0; })
                          .get();

    return SapObject(disp, hApp);
}

// Simple test to verify FFI works from any caller
__declspec(dllexport) int Sap_TestFfi(void) {
    return 42;
}

_variant_t SapObject::internalInvoke(const std::wstring &name, WORD flags, std::vector<_variant_t> args)
{
    if (!isValid())
        return _variant_t();

    return dispatcher->enqueueResult([d = dispatcher, h = handle, name, flags, args]() mutable -> _variant_t
                                     {
        IDispatch* pDisp = d->getDisp(h);
        if (!pDisp) return _variant_t();
        
        DISPID dispid;
        LPOLESTR szName = const_cast<LPOLESTR>(name.c_str());
        if (FAILED(pDisp->GetIDsOfNames(IID_NULL, &szName, 1, LOCALE_USER_DEFAULT, &dispid))) return _variant_t();
        
        std::vector<VARIANT> vArgs(args.size());
        for (size_t i = 0; i < args.size(); ++i) vArgs[i] = args[args.size() - 1 - i];
        
        DISPPARAMS dp = { vArgs.data(), nullptr, (UINT)vArgs.size(), 0 };
        DISPID dispidPut = DISPID_PROPERTYPUT;
        if (flags & DISPATCH_PROPERTYPUT) { dp.rgdispidNamedArgs = &dispidPut; dp.cNamedArgs = 1; }

        _variant_t result;
        HRESULT hr;
        int attempts = 0;
        do {
            hr = pDisp->Invoke(dispid, IID_NULL, LOCALE_USER_DEFAULT, flags, &dp, &result, nullptr, nullptr);
            if (hr == RPC_E_CALL_REJECTED) Sleep(150);
        } while (hr == RPC_E_CALL_REJECTED && ++attempts < 20);
        
        return result; })
        .get();
}

// --- Conversion helpers ---
std::wstring SapObject::getPropStr(const std::wstring &n) { return (std::wstring)(_bstr_t)internalInvoke(n, DISPATCH_PROPERTYGET); }
long SapObject::getPropLong(const std::wstring &n) { return (long)internalInvoke(n, DISPATCH_PROPERTYGET); }
bool SapObject::getPropBool(const std::wstring &n) { return (bool)internalInvoke(n, DISPATCH_PROPERTYGET); }

SapObject SapObject::getPropObj(const std::wstring &n)
{
    _variant_t r = internalInvoke(n, DISPATCH_PROPERTYGET);
    return (r.vt == VT_DISPATCH && r.pdispVal) ? SapObject(dispatcher, dispatcher->addDisp(r.pdispVal)) : SapObject();
}
void SapObject::setProp(const std::wstring &n, _variant_t v) { internalInvoke(n, DISPATCH_PROPERTYPUT, {v}); }

void SapObject::execMethodVoid(const std::wstring &n, std::vector<_variant_t> a) { internalInvoke(n, DISPATCH_METHOD, a); }

std::wstring SapObject::execMethodStr(const std::wstring &n, std::vector<_variant_t> a)
{
    _variant_t r = internalInvoke(n, DISPATCH_METHOD, a);
    if (r.vt == VT_EMPTY || r.vt == VT_NULL || r.vt == VT_ERROR)
        return L"";
    return (std::wstring)(_bstr_t)r;
}

SapObject SapObject::execMethodObj(const std::wstring &n, std::vector<_variant_t> a)
{
    _variant_t r = internalInvoke(n, DISPATCH_METHOD, a);
    return (r.vt == VT_DISPATCH && r.pdispVal) ? SapObject(dispatcher, dispatcher->addDisp(r.pdispVal)) : SapObject();
}

int32_t SapObject::execMethodInt(const std::wstring &methodName, const std::vector<_variant_t> &args)
{
    _variant_t result = internalInvoke(methodName, DISPATCH_METHOD, args);
    if (result.vt == VT_EMPTY || result.vt == VT_NULL)
        return 0;
    try
    {
        result.ChangeType(VT_I4);
        return result.lVal;
    }
    catch (...)
    {
        return 0;
    }
}

IDispatch *SapObject::getRawDispatch() const
{
    if (!isValid())
        return nullptr;
    return dispatcher->getDisp(handle);
}

_variant_t SapObject::execMethodVariant(const std::wstring &n, std::vector<_variant_t> a)
{
    return internalInvoke(n, DISPATCH_METHOD, a);
}

// ============================================================
// 3. BRIDGE API (EXPORTS FOR DART FFI)
// ============================================================

extern "C"
{
    // --- CONNECTION AND MEMORY MANAGEMENT ---
    __declspec(dllexport) uint64_t Sap_Connect()
    {
        SapObject obj = SapObject::connect();
        if (!obj.isValid())
            return 0;
        return registerNewObj(std::move(obj));
    }

    __declspec(dllexport) void Sap_Release(uint64_t h)
    {
        std::lock_guard<std::mutex> lock(g_mutex);
        g_objects.erase(h);
    }

    __declspec(dllexport) void Sap_FreeString(wchar_t *p)
    {
        if (p)
            free(p);
    }

    // --- PROPERTY MANAGEMENT (GET/SET) ---
    __declspec(dllexport) void Sap_SetPropertyObject(uint64_t h, const wchar_t *prop, uint64_t valHandle)
    {
        auto targetObj = getObj(h);
        auto valObj = getObj(valHandle);

        if (targetObj && valObj)
        {
            IDispatch *pValDisp = valObj->getRawDispatch();
            if (pValDisp)
                targetObj->setProp(prop, _variant_t(pValDisp, true));
        }
    }

    __declspec(dllexport) wchar_t *Sap_GetPropertyString(uint64_t h, const wchar_t *prop)
    {
        auto o = getObj(h);
        return o ? stringToWchar(o->getPropStr(prop)) : nullptr;
    }

    __declspec(dllexport) void Sap_SetPropertyString(uint64_t h, const wchar_t *prop, const wchar_t *val)
    {
        if (auto o = getObj(h))
            o->setProp(prop, _variant_t(val));
    }

    __declspec(dllexport) int32_t Sap_GetPropertyInt(uint64_t h, const wchar_t *prop)
    {
        auto o = getObj(h);
        return o ? (int32_t)o->getPropLong(prop) : 0;
    }

    __declspec(dllexport) void Sap_SetPropertyInt(uint64_t h, const wchar_t *prop, int32_t val)
    {
        if (auto o = getObj(h))
            o->setProp(prop, _variant_t((long)val));
    }

    __declspec(dllexport) uint64_t Sap_GetPropertyObject(uint64_t h, const wchar_t *prop)
    {
        auto o = getObj(h);
        return o ? registerNewObj(o->getPropObj(prop)) : 0;
    }

    // --- ACCESS TO COLLECTIONS ---
    __declspec(dllexport) int32_t Sap_GetCount(uint64_t h)
    {
        auto o = getObj(h);
        return o ? (int32_t)o->getPropLong(L"Count") : 0;
    }

    __declspec(dllexport) uint64_t Sap_GetChild(uint64_t h, int32_t index)
    {
        auto o = getObj(h);
        if (!o)
            return 0;
        SapObject children = o->getPropObj(L"Children");
        if (!children.isValid())
            return 0;
        return registerNewObj(children.execMethodObj(L"ElementAt", {_variant_t((long)index)}));
    }

    // --- VOID METHODS (ACTIONS) ---
    __declspec(dllexport) void Sap_InvokeMethodVoid(uint64_t h, const wchar_t *method)
    {
        if (auto o = getObj(h))
            o->execMethodVoid(method);
    }
    __declspec(dllexport) void Sap_InvokeMethodVoid_Int(uint64_t h, const wchar_t *method, int32_t a1)
    {
        if (auto o = getObj(h))
            o->execMethodVoid(method, {_variant_t((long)a1)});
    }
    __declspec(dllexport) void Sap_InvokeMethodVoid_Str(uint64_t h, const wchar_t *method, const wchar_t *a1)
    {
        if (auto o = getObj(h))
            o->execMethodVoid(method, {_variant_t(a1)});
    }
    __declspec(dllexport) void Sap_InvokeMethodVoid_IntStr(uint64_t h, const wchar_t *method, int32_t a1, const wchar_t *a2)
    {
        if (auto o = getObj(h))
            o->execMethodVoid(method, {_variant_t((long)a1), _variant_t(a2)});
    }
    __declspec(dllexport) void Sap_InvokeMethodVoid_StrInt(uint64_t h, const wchar_t *method, const wchar_t *a1, int32_t a2)
    {
        if (auto o = getObj(h))
            o->execMethodVoid(method, {_variant_t(a1), _variant_t((long)a2)});
    }
    __declspec(dllexport) void Sap_InvokeMethodVoid_StrStr(uint64_t h, const wchar_t *method, const wchar_t *a1, const wchar_t *a2)
    {
        if (auto o = getObj(h))
            o->execMethodVoid(method, {_variant_t(a1), _variant_t(a2)});
    }
    __declspec(dllexport) void Sap_InvokeMethodVoid_StrStrStr(uint64_t h, const wchar_t *method, const wchar_t *a1, const wchar_t *a2, const wchar_t *a3)
    {
        if (auto o = getObj(h))
            o->execMethodVoid(method, {_variant_t(a1), _variant_t(a2), _variant_t(a3)});
    }
    __declspec(dllexport) void Sap_InvokeMethodVoid_IntInt(uint64_t h, const wchar_t *method, int32_t a1, int32_t a2)
    {
        if (auto o = getObj(h))
            o->execMethodVoid(method, {_variant_t((long)a1), _variant_t((long)a2)});
    }
    __declspec(dllexport) void Sap_InvokeMethodVoid_IntStrStr(uint64_t h, const wchar_t *method, int32_t a1, const wchar_t *a2, const wchar_t *a3)
    {
        if (auto o = getObj(h))
            o->execMethodVoid(method, {_variant_t((long)a1), _variant_t(a2), _variant_t(a3)});
    }
    __declspec(dllexport) void Sap_InvokeMethodVoid_IntStrInt(uint64_t h, const wchar_t *method, int32_t a1, const wchar_t *a2, int32_t a3)
    {
        if (auto o = getObj(h))
            o->execMethodVoid(method, {_variant_t((long)a1), _variant_t(a2), _variant_t((long)a3)});
    }
    __declspec(dllexport) void Sap_InvokeMethodVoid_StrStrInt(uint64_t h, const wchar_t *method, const wchar_t *a1, const wchar_t *a2, int32_t a3)
    {
        if (auto o = getObj(h))
            o->execMethodVoid(method, {_variant_t(a1), _variant_t(a2), _variant_t((long)a3)});
    }
    __declspec(dllexport) void Sap_InvokeMethodVoid_IntIntInt(uint64_t h, const wchar_t *method, int32_t a1, int32_t a2, int32_t a3)
    {
        if (auto o = getObj(h))
            o->execMethodVoid(method, {_variant_t((long)a1), _variant_t((long)a2), _variant_t((long)a3)});
    }
    __declspec(dllexport) void Sap_InvokeMethodVoid_IntIntIntStrStr(uint64_t h, const wchar_t *method, int32_t a1, int32_t a2, int32_t a3, const wchar_t *a4, const wchar_t *a5)
    {
        if (auto o = getObj(h))
            o->execMethodVoid(method, {_variant_t((long)a1), _variant_t((long)a2), _variant_t((long)a3), _variant_t(a4), _variant_t(a5)});
    }

    // --- METHODS RETURNING STRING ---
    __declspec(dllexport) wchar_t *Sap_InvokeMethodStr_NoArgs(uint64_t h, const wchar_t *method)
    {
        auto o = getObj(h);
        return o ? stringToWchar(o->execMethodStr(method, {})) : nullptr;
    }
    __declspec(dllexport) wchar_t *Sap_InvokeMethodStr_Str(uint64_t h, const wchar_t *method, const wchar_t *a1)
    {
        auto o = getObj(h);
        return o ? stringToWchar(o->execMethodStr(method, {_variant_t(a1)})) : nullptr;
    }
    __declspec(dllexport) wchar_t *Sap_InvokeMethodStr_Int(uint64_t h, const wchar_t *method, int32_t a1)
    {
        auto o = getObj(h);
        return o ? stringToWchar(o->execMethodStr(method, {_variant_t((long)a1)})) : nullptr;
    }
    __declspec(dllexport) wchar_t *Sap_InvokeMethodStr_IntStr(uint64_t h, const wchar_t *method, int32_t a1, const wchar_t *a2)
    {
        auto o = getObj(h);
        return o ? stringToWchar(o->execMethodStr(method, {_variant_t((long)a1), _variant_t(a2)})) : nullptr;
    }
    __declspec(dllexport) wchar_t *Sap_InvokeMethodStr_StrStr(uint64_t h, const wchar_t *method, const wchar_t *a1, const wchar_t *a2)
    {
        auto o = getObj(h);
        return o ? stringToWchar(o->execMethodStr(method, {_variant_t(a1), _variant_t(a2)})) : nullptr;
    }
    __declspec(dllexport) wchar_t *Sap_InvokeMethodStr_IntInt(uint64_t h, const wchar_t *method, int32_t a1, int32_t a2)
    {
        auto o = getObj(h);
        return o ? stringToWchar(o->execMethodStr(method, {_variant_t((long)a1), _variant_t((long)a2)})) : nullptr;
    }
    __declspec(dllexport) wchar_t *Sap_InvokeMethodStr_IntIntInt(uint64_t h, const wchar_t *method, int32_t a1, int32_t a2, int32_t a3)
    {
        auto o = getObj(h);
        return o ? stringToWchar(o->execMethodStr(method, {_variant_t((long)a1), _variant_t((long)a2), _variant_t((long)a3)})) : nullptr;
    }

    // --- METHODS RETURNING INTEGERS/BOOL ---
    __declspec(dllexport) int32_t Sap_InvokeMethodInt_NoArgs(uint64_t h, const wchar_t *method)
    {
        auto o = getObj(h);
        return o ? o->execMethodInt(method, {}) : 0;
    }
    __declspec(dllexport) int32_t Sap_InvokeMethodInt_Str(uint64_t h, const wchar_t *method, const wchar_t *a1)
    {
        auto o = getObj(h);
        return o ? o->execMethodInt(method, {_variant_t(a1)}) : 0;
    }
    __declspec(dllexport) int32_t Sap_InvokeMethodInt_Int(uint64_t h, const wchar_t *method, int32_t a1)
    {
        auto o = getObj(h);
        return o ? o->execMethodInt(method, {_variant_t((long)a1)}) : 0;
    }
    __declspec(dllexport) int32_t Sap_InvokeMethodInt_IntStr(uint64_t h, const wchar_t *method, int32_t a1, const wchar_t *a2)
    {
        auto o = getObj(h);
        return o ? o->execMethodInt(method, {_variant_t((long)a1), _variant_t(a2)}) : 0;
    }
    __declspec(dllexport) int32_t Sap_InvokeMethodInt_StrStr(uint64_t h, const wchar_t *method, const wchar_t *a1, const wchar_t *a2)
    {
        auto o = getObj(h);
        return o ? o->execMethodInt(method, {_variant_t(a1), _variant_t(a2)}) : 0;
    }
    __declspec(dllexport) int32_t Sap_InvokeMethodInt_StrStrIntInt(uint64_t h, const wchar_t *method, const wchar_t *a1, const wchar_t *a2, int32_t a3, int32_t a4)
    {
        auto o = getObj(h);
        return o ? o->execMethodInt(method, {_variant_t(a1), _variant_t(a2), _variant_t((long)a3), _variant_t((long)a4)}) : 0;
    }

    // --- METHODS RETURNING OBJECTS ---
    __declspec(dllexport) uint64_t Sap_InvokeMethodObj_NoArgs(uint64_t h, const wchar_t *method)
    {
        auto o = getObj(h);
        return o ? registerNewObj(o->execMethodObj(method, {})) : 0;
    }
    __declspec(dllexport) uint64_t Sap_InvokeMethodObj_Str(uint64_t h, const wchar_t *method, const wchar_t *a1)
    {
        auto o = getObj(h);
        return o ? registerNewObj(o->execMethodObj(method, {_variant_t(a1)})) : 0;
    }
    __declspec(dllexport) uint64_t Sap_InvokeMethodObj_Int(uint64_t h, const wchar_t *method, int32_t a1)
    {
        auto o = getObj(h);
        return o ? registerNewObj(o->execMethodObj(method, {_variant_t((long)a1)})) : 0;
    }
    __declspec(dllexport) uint64_t Sap_InvokeMethodObj_StrStr(uint64_t h, const wchar_t *method, const wchar_t *a1, const wchar_t *a2)
    {
        auto o = getObj(h);
        return o ? registerNewObj(o->execMethodObj(method, {_variant_t(a1), _variant_t(a2)})) : 0;
    }
    __declspec(dllexport) uint64_t Sap_InvokeMethodObj_StrInt(uint64_t h, const wchar_t *method, const wchar_t *a1, int32_t a2)
    {
        auto o = getObj(h);
        return o ? registerNewObj(o->execMethodObj(method, {_variant_t(a1), _variant_t((long)a2)})) : 0;
    }
    __declspec(dllexport) uint64_t Sap_InvokeMethodObj_IntStr(uint64_t h, const wchar_t *method, int32_t a1, const wchar_t *a2)
    {
        auto o = getObj(h);
        return o ? registerNewObj(o->execMethodObj(method, {_variant_t((long)a1), _variant_t(a2)})) : 0;
    }
    __declspec(dllexport) uint64_t Sap_InvokeMethodObj_IntInt(uint64_t h, const wchar_t *method, int32_t a1, int32_t a2)
    {
        auto o = getObj(h);
        return o ? registerNewObj(o->execMethodObj(method, {_variant_t((long)a1), _variant_t((long)a2)})) : 0;
    }
    __declspec(dllexport) uint64_t Sap_InvokeMethodObj_StrIntInt(uint64_t h, const wchar_t *method, const wchar_t *s1, int32_t b1, int32_t b2)
    {
        auto o = getObj(h);
        return o ? registerNewObj(o->execMethodObj(method, {_variant_t(s1), _variant_t(b1 != 0), _variant_t(b2 != 0)})) : 0;
    }

    // --- METHODS RETURNING BYTE ARRAYS (SAFEARRAY) ---
    __declspec(dllexport) uint8_t *Sap_InvokeMethodBytes_NoArgs(uint64_t h, const wchar_t *method, int32_t *out_length)
    {
        if (out_length)
            *out_length = 0;
        auto o = getObj(h);
        if (!o)
            return nullptr;

        _variant_t result = o->execMethodVariant(method, {});
        if ((result.vt & VT_ARRAY) == 0)
            return nullptr;

        SAFEARRAY *psa = (result.vt & VT_BYREF) ? *result.pparray : result.parray;
        if (!psa)
            return nullptr;

        long lBound, uBound;
        if (FAILED(SafeArrayGetLBound(psa, 1, &lBound)) || FAILED(SafeArrayGetUBound(psa, 1, &uBound)))
            return nullptr;

        long length = uBound - lBound + 1;
        if (length <= 0)
            return nullptr;

        uint8_t *buffer = (uint8_t *)malloc(length);
        if (!buffer)
            return nullptr;

        void *pData = nullptr;
        if (SUCCEEDED(SafeArrayAccessData(psa, &pData)))
        {
            memcpy(buffer, pData, length);
            SafeArrayUnaccessData(psa);
            if (out_length)
                *out_length = (int32_t)length;
            return buffer;
        }
        else
        {
            free(buffer);
            return nullptr;
        }
    }

    __declspec(dllexport) void Sap_FreeBytes(uint8_t *p)
    {
        if (p)
            free(p);
    }

    __declspec(dllexport) wchar_t *Sap_GetObjectTree(uint64_t handle, const wchar_t *id, const wchar_t **props, int propsCount)
    {
        auto obj = getObj(handle);
        if (!obj)
            return nullptr;

        try
        {
            std::vector<_variant_t> args;
            args.push_back(_variant_t(id));

            if (propsCount > 0 && props != nullptr)
            {
                SAFEARRAY *psa = SafeArrayCreateVector(VT_VARIANT, 0, propsCount);
                for (LONG i = 0; i < propsCount; i++)
                {
                    _variant_t val(props[i]);
                    SafeArrayPutElement(psa, &i, &val);
                }
                _variant_t varProps;
                varProps.vt = VT_ARRAY | VT_VARIANT;
                varProps.parray = psa;
                args.push_back(varProps);
            }

            _variant_t result = obj->execMethodVariant(L"GetObjectTree", args);

            if (result.vt == VT_BSTR && result.bstrVal != nullptr)
            {
                size_t len = wcslen(result.bstrVal) + 1;
                wchar_t *ret = (wchar_t *)malloc(len * sizeof(wchar_t));
                wcscpy_s(ret, len, result.bstrVal);
                return ret;
            }
            return nullptr;
        }
        catch (...)
        {
            return nullptr;
        }
    }

    // --- SOPORTE ESPECÍFICO PARA ValueChange ---
    __declspec(dllexport) void Sap_InvokeMethodVoid_ValueChange(
        uint64_t h, int32_t series, int32_t point, const wchar_t *xValue, const wchar_t *yValue,
        uint8_t dataChange, const wchar_t *id, const wchar_t *zValue, int32_t changeFlag)
    {
        if (auto o = getObj(h))
        {
            o->execMethodVoid(L"ValueChange", {_variant_t((long)series), _variant_t((long)point),
                                               _variant_t(xValue), _variant_t(yValue), _variant_t((BYTE)dataChange),
                                               _variant_t(id), _variant_t(zValue), _variant_t((long)changeFlag)});
        }
    }

    // --- SOPORTE ESPECÍFICO PARA CustomEvent ---
    __declspec(dllexport) void Sap_InvokeMethodVoid_CustomEvent(
        uint64_t h, int32_t cookie, const wchar_t *eventName, int32_t paramCount,
        const wchar_t *p1, const wchar_t *p2, const wchar_t *p3, const wchar_t *p4,
        const wchar_t *p5, const wchar_t *p6, const wchar_t *p7, const wchar_t *p8,
        const wchar_t *p9, const wchar_t *p10, const wchar_t *p11, const wchar_t *p12)
    {
        if (auto o = getObj(h))
        {
            std::vector<_variant_t> args;
            args.push_back(_variant_t((long)cookie));
            args.push_back(_variant_t(eventName));
            args.push_back(_variant_t((long)paramCount));
            const wchar_t *optParams[] = {p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12};
            for (int i = 0; i < 12; i++)
            {
                if (optParams[i] != nullptr)
                    args.push_back(_variant_t(optParams[i]));
                else
                    break;
            }
            o->execMethodVoid(L"CustomEvent", args);
        }
    }
}