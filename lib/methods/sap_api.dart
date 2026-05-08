import 'dart:ffi';
import 'package:sap_gui_scripting/interfaces/i_sap_api.dart'; // Ajusta este import
import 'package:sap_gui_scripting/methods/dart_and_c_typedefs.dart';
import 'package:sap_gui_scripting/methods/load_dll_helper.dart';

class SapApi implements ISapApi {
  late final DynamicLibrary lib;
  bool _initialized = false;

  @override
  bool get initialized => _initialized;

  // --- CONNECTION AND MEMORY MANAGEMENT ---
  @override
  late final ConnectDart connect;
  @override
  late final ReleaseDart release;
  @override
  late final FreeStringDart freeString;

  // --- PROPERTIES ---
  @override
  late final GetPropStrDart getPropertyString;
  @override
  late final SetPropStrDart setPropertyString;
  @override
  late final GetPropIntDart getPropertyInt;
  @override
  late final SetPropIntDart setPropertyInt;
  @override
  late final GetPropObjDart getPropertyObject;
  @override
  late final SetPropObjDart setPropertyObject;

  // --- COLLECTIONS ---
  @override
  late final GetCountDart getCount;
  @override
  late final GetChildDart getChild;

  // --- VOID METHODS (ACTIONS) ---
  @override
  late final InvokeVoidDart invokeVoid;
  @override
  late final InvokeVoidIntDart invokeVoidInt;
  @override
  late final InvokeVoidStrDart invokeVoidStr;
  @override
  late final InvokeVoidIntStrDart invokeVoidIntStr;
  @override
  late final InvokeVoidStrIntDart invokeVoidStrInt;
  @override
  late final InvokeVoidStrStrDart invokeVoidStrStr;
  @override
  late final InvokeVoidStrStrStrDart invokeVoidStrStrStr;
  @override
  late final InvokeVoidIntIntDart invokeVoidIntInt;
  @override
  late final InvokeVoidIntStrStrDart invokeVoidIntStrStr;
  @override
  late final InvokeVoidIntStrIntDart invokeVoidIntStrInt;
  @override
  late final InvokeVoidStrStrIntDart invokeVoidStrStrInt;
  @override
  late final InvokeVoidIntIntIntDart invokeVoidIntIntInt;
  @override
  late final InvokeVoidIntIntIntStrStrDart invokeVoidIntIntIntStrStr;

  // --- METHODS RETURNING STRINGS ---
  @override
  late final InvokeStrNoArgsDart invokeStr;
  @override
  late final InvokeStrStrDart invokeStrStr;
  @override
  late final InvokeStrIntDart invokeStrInt;
  @override
  late final InvokeStrIntStrDart invokeStrIntStr;
  @override
  late final InvokeStrStrStrDart invokeStrStrStr;
  @override
  late final InvokeStrIntIntDart invokeStrIntInt;
  @override
  late final InvokeStrIntIntIntDart invokeStrIntIntInt;

  // --- METHODS RETURNING INTEGER/BOOL ---
  @override
  late final InvokeIntNoArgsDart invokeInt;
  @override
  late final InvokeIntNoArgsDart invokeIntNoArgs;
  @override
  late final InvokeIntStrDart invokeIntStr;
  @override
  late final InvokeIntIntDart invokeIntInt;
  @override
  late final InvokeIntIntStrDart invokeIntIntStr;
  @override
  late final InvokeIntStrStrDart invokeIntStrStr;
  @override
  late final InvokeIntStrStrIntIntDart invokeIntStrStrIntInt;

  // --- METHODS RETURNING OBJECTS ---
  @override
  late final InvokeObjNoArgsDart invokeObj;
  @override
  late final InvokeObjNoArgsDart invokeObjNoArgs;
  @override
  late final InvokeObjStrDart invokeObjStr;
  @override
  late final InvokeObjIntDart invokeObjInt;
  @override
  late final InvokeObjStrStrDart invokeObjStrStr;
  @override
  late final InvokeObjStrIntDart invokeObjStrInt;
  @override
  late final InvokeObjIntStrDart invokeObjIntStr;
  @override
  late final InvokeObjIntIntDart invokeObjIntInt;
  @override
  late final InvokeObjStrIntIntDart invokeObjStrIntInt;

  // --- OTHERS ---
  @override
  late final InvokeMethodBytesNoArgsDart invokeMethodBytesNoArgs;
  @override
  late final SapFreeBytesDart freeBytes;
  @override
  late final GetObjTreeDart getObjectTree;
  @override
  late final SapInvokeMethodVoidValueChangeDart invokeMethodVoidValueChange;
  @override
  late final SapInvokeMethodVoidCustomEventDart invokeMethodVoidCustomEvent;

  @override
  void initialize() {
    if (_initialized) return;

    lib = loadSapBridgeDll();

    // --- CONNECTION AND MEMORY ---
    connect = lib.lookupFunction<ConnectC, ConnectDart>('Sap_Connect');
    release = lib.lookupFunction<ReleaseC, ReleaseDart>('Sap_Release');
    freeString = lib.lookupFunction<FreeStringC, FreeStringDart>(
      'Sap_FreeString',
    );
    freeBytes = lib.lookupFunction<SapFreeBytesC, SapFreeBytesDart>(
      'Sap_FreeBytes',
    );
    getObjectTree = lib.lookupFunction<GetObjTreeC, GetObjTreeDart>(
      'Sap_GetObjectTree',
    );

    // --- PROPERTIES ---
    getPropertyString = lib.lookupFunction<GetPropStrC, GetPropStrDart>(
      'Sap_GetPropertyString',
    );
    setPropertyString = lib.lookupFunction<SetPropStrC, SetPropStrDart>(
      'Sap_SetPropertyString',
    );
    getPropertyInt = lib.lookupFunction<GetPropIntC, GetPropIntDart>(
      'Sap_GetPropertyInt',
    );
    setPropertyInt = lib.lookupFunction<SetPropIntC, SetPropIntDart>(
      'Sap_SetPropertyInt',
    );
    getPropertyObject = lib.lookupFunction<GetPropObjC, GetPropObjDart>(
      'Sap_GetPropertyObject',
    );
    setPropertyObject = lib.lookupFunction<SetPropObjC, SetPropObjDart>(
      'Sap_SetPropertyObject',
    );

    // --- COLLECTIONS ---
    getCount = lib.lookupFunction<GetCountC, GetCountDart>('Sap_GetCount');
    getChild = lib.lookupFunction<GetChildC, GetChildDart>('Sap_GetChild');

    // --- VOID ---
    invokeVoid = lib.lookupFunction<InvokeVoidC, InvokeVoidDart>(
      'Sap_InvokeMethodVoid',
    );
    invokeVoidInt = lib.lookupFunction<InvokeVoidIntC, InvokeVoidIntDart>(
      'Sap_InvokeMethodVoid_Int',
    );
    invokeVoidStr = lib.lookupFunction<InvokeVoidStrC, InvokeVoidStrDart>(
      'Sap_InvokeMethodVoid_Str',
    );
    invokeVoidIntStr = lib
        .lookupFunction<InvokeVoidIntStrC, InvokeVoidIntStrDart>(
          'Sap_InvokeMethodVoid_IntStr',
        );
    invokeVoidStrInt = lib
        .lookupFunction<InvokeVoidStrIntC, InvokeVoidStrIntDart>(
          'Sap_InvokeMethodVoid_StrInt',
        );
    invokeVoidStrStr = lib
        .lookupFunction<InvokeVoidStrStrC, InvokeVoidStrStrDart>(
          'Sap_InvokeMethodVoid_StrStr',
        );
    invokeVoidStrStrStr = lib
        .lookupFunction<InvokeVoidStrStrStrC, InvokeVoidStrStrStrDart>(
          'Sap_InvokeMethodVoid_StrStrStr',
        );
    invokeVoidIntInt = lib
        .lookupFunction<InvokeVoidIntIntC, InvokeVoidIntIntDart>(
          'Sap_InvokeMethodVoid_IntInt',
        );
    invokeVoidIntStrStr = lib
        .lookupFunction<InvokeVoidIntStrStrC, InvokeVoidIntStrStrDart>(
          'Sap_InvokeMethodVoid_IntStrStr',
        );
    invokeVoidIntStrInt = lib
        .lookupFunction<InvokeVoidIntStrIntC, InvokeVoidIntStrIntDart>(
          'Sap_InvokeMethodVoid_IntStrInt',
        );
    invokeVoidStrStrInt = lib
        .lookupFunction<InvokeVoidStrStrIntC, InvokeVoidStrStrIntDart>(
          'Sap_InvokeMethodVoid_StrStrInt',
        );
    invokeVoidIntIntInt = lib
        .lookupFunction<InvokeVoidIntIntIntC, InvokeVoidIntIntIntDart>(
          'Sap_InvokeMethodVoid_IntIntInt',
        );
    invokeVoidIntIntIntStrStr = lib
        .lookupFunction<
          InvokeVoidIntIntIntStrStrC,
          InvokeVoidIntIntIntStrStrDart
        >('Sap_InvokeMethodVoid_IntIntIntStrStr');

    invokeMethodVoidCustomEvent = lib
        .lookupFunction<
          SapInvokeMethodVoidCustomEventC,
          SapInvokeMethodVoidCustomEventDart
        >('Sap_InvokeMethodVoid_CustomEvent');
    invokeMethodVoidValueChange = lib
        .lookupFunction<
          SapInvokeMethodVoidValueChangeC,
          SapInvokeMethodVoidValueChangeDart
        >('Sap_InvokeMethodVoid_ValueChange');

    // --- STR ---
    invokeStr = lib.lookupFunction<InvokeStrNoArgsC, InvokeStrNoArgsDart>(
      'Sap_InvokeMethodStr_NoArgs',
    );
    invokeStrStr = lib.lookupFunction<InvokeStrStrC, InvokeStrStrDart>(
      'Sap_InvokeMethodStr_Str',
    );
    invokeStrInt = lib.lookupFunction<InvokeStrIntC, InvokeStrIntDart>(
      'Sap_InvokeMethodStr_Int',
    );
    invokeStrIntStr = lib.lookupFunction<InvokeStrIntStrC, InvokeStrIntStrDart>(
      'Sap_InvokeMethodStr_IntStr',
    );
    invokeStrStrStr = lib.lookupFunction<InvokeStrStrStrC, InvokeStrStrStrDart>(
      'Sap_InvokeMethodStr_StrStr',
    );
    invokeStrIntInt = lib.lookupFunction<InvokeStrIntIntC, InvokeStrIntIntDart>(
      'Sap_InvokeMethodStr_IntInt',
    );
    invokeStrIntIntInt = lib
        .lookupFunction<InvokeStrIntIntIntC, InvokeStrIntIntIntDart>(
          'Sap_InvokeMethodStr_IntIntInt',
        );

    // --- INT ---
    invokeIntNoArgs = lib.lookupFunction<InvokeIntNoArgsC, InvokeIntNoArgsDart>(
      'Sap_InvokeMethodInt_NoArgs',
    );
    invokeInt = lib.lookupFunction<InvokeIntNoArgsC, InvokeIntNoArgsDart>(
      'Sap_InvokeMethodInt_NoArgs',
    );
    invokeIntStr = lib.lookupFunction<InvokeIntStrC, InvokeIntStrDart>(
      'Sap_InvokeMethodInt_Str',
    );
    invokeIntInt = lib.lookupFunction<InvokeIntIntC, InvokeIntIntDart>(
      'Sap_InvokeMethodInt_Int',
    );
    invokeIntIntStr = lib.lookupFunction<InvokeIntIntStrC, InvokeIntIntStrDart>(
      'Sap_InvokeMethodInt_IntStr',
    );
    invokeIntStrStr = lib.lookupFunction<InvokeIntStrStrC, InvokeIntStrStrDart>(
      'Sap_InvokeMethodInt_StrStr',
    );
    invokeIntStrStrIntInt = lib
        .lookupFunction<InvokeIntStrStrIntIntC, InvokeIntStrStrIntIntDart>(
          'Sap_InvokeMethodInt_StrStrIntInt',
        );

    // --- OBJ ---
    invokeObjNoArgs = lib.lookupFunction<InvokeObjNoArgsC, InvokeObjNoArgsDart>(
      'Sap_InvokeMethodObj_NoArgs',
    );
    invokeObj = lib.lookupFunction<InvokeObjNoArgsC, InvokeObjNoArgsDart>(
      'Sap_InvokeMethodObj_NoArgs',
    );
    invokeObjStr = lib.lookupFunction<InvokeObjStrC, InvokeObjStrDart>(
      'Sap_InvokeMethodObj_Str',
    );
    invokeObjInt = lib.lookupFunction<InvokeObjIntC, InvokeObjIntDart>(
      'Sap_InvokeMethodObj_Int',
    );
    invokeObjStrStr = lib.lookupFunction<InvokeObjStrStrC, InvokeObjStrStrDart>(
      'Sap_InvokeMethodObj_StrStr',
    );
    invokeObjStrInt = lib.lookupFunction<InvokeObjStrIntC, InvokeObjStrIntDart>(
      'Sap_InvokeMethodObj_StrInt',
    );
    invokeObjIntStr = lib.lookupFunction<InvokeObjIntStrC, InvokeObjIntStrDart>(
      'Sap_InvokeMethodObj_IntStr',
    );
    invokeObjIntInt = lib.lookupFunction<InvokeObjIntIntC, InvokeObjIntIntDart>(
      'Sap_InvokeMethodObj_IntInt',
    );
    invokeObjStrIntInt = lib
        .lookupFunction<InvokeObjStrIntIntC, InvokeObjStrIntIntDart>(
          'Sap_InvokeMethodObj_StrIntInt',
        );

    invokeMethodBytesNoArgs = lib
        .lookupFunction<InvokeMethodBytesNoArgsC, InvokeMethodBytesNoArgsDart>(
          'Sap_InvokeMethodBytes_NoArgs',
        );

    _initialized = true;
  }
}
