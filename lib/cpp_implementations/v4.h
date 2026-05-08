#ifndef SAP_OBJECT_H
#define SAP_OBJECT_H

#include <windows.h>
#include <oleauto.h>
#include <comdef.h>
#include <vector>
#include <string>
#include <memory>

#include "dispatcher.h"

#pragma comment(lib, "comsuppw.lib")

class SapObject
{
private:
    DispHandle handle = 0;
    std::shared_ptr<ComStaDispatcher> dispatcher;

    _variant_t internalInvoke(const std::wstring &name, WORD flags, std::vector<_variant_t> args = {});

public:
    SapObject(std::shared_ptr<ComStaDispatcher> d = nullptr, DispHandle h = 0);
    ~SapObject();
    SapObject(SapObject &&other) noexcept;
    SapObject &operator=(SapObject &&other) noexcept;

    SapObject(const SapObject &) = delete;
    SapObject &operator=(const SapObject &) = delete;

    bool isValid() const { return handle != 0 && dispatcher != nullptr; }
    static SapObject connect();

    std::wstring getPropStr(const std::wstring &n);
    long getPropLong(const std::wstring &n);
    bool getPropBool(const std::wstring &n);
    SapObject getPropObj(const std::wstring &n);
    void setProp(const std::wstring &n, _variant_t v);

    void execMethodVoid(const std::wstring &n, std::vector<_variant_t> a = {});
    std::wstring execMethodStr(const std::wstring &n, std::vector<_variant_t> a = {});
    SapObject execMethodObj(const std::wstring &n, std::vector<_variant_t> a = {});
    int32_t execMethodInt(const std::wstring &methodName, const std::vector<_variant_t> &args = {});

    std::wstring getId() { return getPropStr(L"Id"); }
    std::wstring getType() { return getPropStr(L"Type"); }
    std::wstring getText() { return getPropStr(L"Text"); }
    void setText(const std::wstring &v) { setProp(L"Text", _variant_t(v.c_str())); }
    SapObject findById(const std::wstring &id) { return execMethodObj(L"FindById", {_variant_t(id.c_str())}); }
    _variant_t execMethodVariant(const std::wstring &n, std::vector<_variant_t> a = {});

    // Handle with care: valid only when re-injected into the same STA
    IDispatch *getRawDispatch() const;
};

#endif