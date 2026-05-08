import 'package:sap_gui_scripting/methods/dart_and_c_typedefs.dart';

abstract class ISapApi {
  bool get initialized;
  void initialize();

  // --- CONNECTION AND MEMORY MANAGEMENT ---
  ConnectDart get connect;
  ReleaseDart get release;
  FreeStringDart get freeString;

  // --- PROPERTIES ---
  GetPropStrDart get getPropertyString;
  SetPropStrDart get setPropertyString;
  GetPropIntDart get getPropertyInt;
  SetPropIntDart get setPropertyInt;
  GetPropObjDart get getPropertyObject;
  SetPropObjDart get setPropertyObject;

  // --- COLLECTIONS ---
  GetCountDart get getCount;
  GetChildDart get getChild;

  // --- VOID METHODS (ACTIONS) ---
  InvokeVoidDart get invokeVoid;
  InvokeVoidIntDart get invokeVoidInt;
  InvokeVoidStrDart get invokeVoidStr;
  InvokeVoidIntStrDart get invokeVoidIntStr;
  InvokeVoidStrIntDart get invokeVoidStrInt;
  InvokeVoidStrStrDart get invokeVoidStrStr;
  InvokeVoidStrStrStrDart get invokeVoidStrStrStr;
  InvokeVoidIntIntDart get invokeVoidIntInt;
  InvokeVoidIntStrStrDart get invokeVoidIntStrStr;
  InvokeVoidIntStrIntDart get invokeVoidIntStrInt;
  InvokeVoidStrStrIntDart get invokeVoidStrStrInt;
  InvokeVoidIntIntIntDart get invokeVoidIntIntInt;
  InvokeVoidIntIntIntStrStrDart get invokeVoidIntIntIntStrStr;

  // --- METHODS RETURNING STRINGS ---
  InvokeStrNoArgsDart get invokeStr;
  InvokeStrStrDart get invokeStrStr;
  InvokeStrIntDart get invokeStrInt;
  InvokeStrIntStrDart get invokeStrIntStr;
  InvokeStrStrStrDart get invokeStrStrStr;
  InvokeStrIntIntDart get invokeStrIntInt;
  InvokeStrIntIntIntDart get invokeStrIntIntInt;

  // --- METHODS RETURNING INTEGERS/BOOL ---
  InvokeIntNoArgsDart get invokeInt;
  InvokeIntNoArgsDart get invokeIntNoArgs;
  InvokeIntStrDart get invokeIntStr;
  InvokeIntIntDart get invokeIntInt;
  InvokeIntIntStrDart get invokeIntIntStr;
  InvokeIntStrStrDart get invokeIntStrStr;
  InvokeIntStrStrIntIntDart get invokeIntStrStrIntInt;

  // --- METHODS RETURNING OBJECTS ---
  InvokeObjNoArgsDart get invokeObj;
  InvokeObjNoArgsDart get invokeObjNoArgs;
  InvokeObjStrDart get invokeObjStr;
  InvokeObjIntDart get invokeObjInt;
  InvokeObjStrStrDart get invokeObjStrStr;
  InvokeObjStrIntDart get invokeObjStrInt;
  InvokeObjIntStrDart get invokeObjIntStr;
  InvokeObjIntIntDart get invokeObjIntInt;
  InvokeObjStrIntIntDart get invokeObjStrIntInt;

  // --- OTHER SPECIFIC METHODS ---
  InvokeMethodBytesNoArgsDart get invokeMethodBytesNoArgs;
  SapFreeBytesDart get freeBytes;
  GetObjTreeDart get getObjectTree;
  SapInvokeMethodVoidValueChangeDart get invokeMethodVoidValueChange;
  SapInvokeMethodVoidCustomEventDart get invokeMethodVoidCustomEvent;
}
