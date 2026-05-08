import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_api.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapApi extends Mock implements ISapApi {}

class MockSapObject extends Mock implements ISapObject {}

class MockConnectFunc extends Mock {
  int call();
}

class MockReleaseFunc extends Mock {
  void call(int handle);
}

class MockFreeStringFunc extends Mock {
  void call(Pointer<Utf16> ptr);
}

class MockFreeBytesFunc extends Mock {
  void call(Pointer<Uint8> ptr);
}

class MockGetPropStrFunc extends Mock {
  Pointer<Utf16> call(int h, Pointer<Utf16> p);
}

class MockSetPropStrFunc extends Mock {
  void call(int h, Pointer<Utf16> p, Pointer<Utf16> v);
}

class MockGetPropIntFunc extends Mock {
  int call(int h, Pointer<Utf16> p);
}

class MockGetPropBoolFunc extends Mock {
  bool call(int h, Pointer<Utf16> p);
}

class MockSetPropIntFunc extends Mock {
  void call(int h, Pointer<Utf16> p, int v);
}

class MockGetChildFunc extends Mock {
  int call(int h, int index);
}

class MockInvokeVoidFunc extends Mock {
  void call(int h, Pointer<Utf16> m);
}

class MockInvokeVoidIntFunc extends Mock {
  void call(int h, Pointer<Utf16> m, int a);
}

class MockInvokeVoidStrFunc extends Mock {
  void call(int h, Pointer<Utf16> m, Pointer<Utf16> a);
}

class MockInvokeVoidIntStrFunc extends Mock {
  void call(int h, Pointer<Utf16> m, int a1, Pointer<Utf16> a2);
}

class MockInvokeVoidStrIntFunc extends Mock {
  void call(int h, Pointer<Utf16> m, Pointer<Utf16> a1, int a2);
}

class MockInvokeVoidStrStrFunc extends Mock {
  void call(int h, Pointer<Utf16> m, Pointer<Utf16> a1, Pointer<Utf16> a2);
}

class MockInvokeVoidStrStrStrFunc extends Mock {
  void call(
    int h,
    Pointer<Utf16> m,
    Pointer<Utf16> a1,
    Pointer<Utf16> a2,
    Pointer<Utf16> a3,
  );
}

class MockInvokeVoidIntIntFunc extends Mock {
  void call(int h, Pointer<Utf16> m, int a1, int a2);
}

class MockInvokeVoidIntStrStrFunc extends Mock {
  void call(
    int h,
    Pointer<Utf16> m,
    int a1,
    Pointer<Utf16> a2,
    Pointer<Utf16> a3,
  );
}

class MockInvokeVoidIntStrIntFunc extends Mock {
  void call(int h, Pointer<Utf16> m, int a1, Pointer<Utf16> a2, int a3);
}

class MockInvokeVoidStrStrIntFunc extends Mock {
  void call(
    int h,
    Pointer<Utf16> m,
    Pointer<Utf16> a1,
    Pointer<Utf16> a2,
    int a3,
  );
}

class MockInvokeVoidIntIntIntFunc extends Mock {
  void call(int h, Pointer<Utf16> m, int a1, int a2, int a3);
}

class MockInvokeVoidIntIntIntStrStrFunc extends Mock {
  void call(
    int h,
    Pointer<Utf16> m,
    int a1,
    int a2,
    int a3,
    Pointer<Utf16> a4,
    Pointer<Utf16> a5,
  );
}

class MockInvokeStrIntFunc extends Mock {
  Pointer<Utf16> call(int h, Pointer<Utf16> m, int a);
}

class MockInvokeStrStrFunc extends Mock {
  Pointer<Utf16> call(int h, Pointer<Utf16> m, Pointer<Utf16> a);
}

class MockInvokeStrIntStrFunc extends Mock {
  Pointer<Utf16> call(int h, Pointer<Utf16> m, int a1, Pointer<Utf16> a2);
}

class MockInvokeStrStrStrFunc extends Mock {
  Pointer<Utf16> call(
    int h,
    Pointer<Utf16> m,
    Pointer<Utf16> a1,
    Pointer<Utf16> a2,
  );
}

class MockInvokeStrIntIntFunc extends Mock {
  Pointer<Utf16> call(int h, Pointer<Utf16> m, int a1, int a2);
}

class MockInvokeStrIntIntIntFunc extends Mock {
  Pointer<Utf16> call(int h, Pointer<Utf16> m, int a1, int a2, int a3);
}

class MockInvokeIntStrFunc extends Mock {
  int call(int h, Pointer<Utf16> m, Pointer<Utf16> a);
}

class MockInvokeIntIntFunc extends Mock {
  int call(int h, Pointer<Utf16> m, int a);
}

class MockInvokeIntIntStrFunc extends Mock {
  int call(int h, Pointer<Utf16> m, int a1, Pointer<Utf16> a2);
}

class MockInvokeIntStrStrFunc extends Mock {
  int call(int h, Pointer<Utf16> m, Pointer<Utf16> a1, Pointer<Utf16> a2);
}

class MockInvokeIntStrStrIntIntFunc extends Mock {
  int call(
    int h,
    Pointer<Utf16> m,
    Pointer<Utf16> a1,
    Pointer<Utf16> a2,
    int a3,
    int a4,
  );
}

class MockInvokeObjNoArgsFunc extends Mock {
  int call(int h, Pointer<Utf16> m);
}

class MockInvokeObjStrIntFunc extends Mock {
  int call(int h, Pointer<Utf16> m, Pointer<Utf16> a1, int a2);
}

class MockInvokeObjStrFunc extends Mock {
  int call(int h, Pointer<Utf16> m, Pointer<Utf16> a1);
}

class MockInvokeObjStrStrFunc extends Mock {
  int call(int h, Pointer<Utf16> m, Pointer<Utf16> a1, Pointer<Utf16> a2);
}

class MockInvokeObjIntStrFunc extends Mock {
  int call(int h, Pointer<Utf16> m, int a1, Pointer<Utf16> a2);
}

class MockInvokeObjIntFunc extends Mock {
  int call(int h, Pointer<Utf16> m, int a1);
}

class MockInvokeObjIntIntFunc extends Mock {
  int call(int h, Pointer<Utf16> m, int a1, int a2);
}

class MockInvokeObjStrIntIntFunc extends Mock {
  int call(int h, Pointer<Utf16> m, Pointer<Utf16> a1, int a2, int a3);
}

class MockInvokeMethodBytesFunc extends Mock {
  Pointer<Uint8> call(int h, Pointer<Utf16> m, Pointer<Int32> size);
}

class MockGetObjTreeFunc extends Mock {
  Pointer<Utf16> call(
    int h,
    Pointer<Utf16> id,
    Pointer<Pointer<Utf16>> props,
    int count,
  );
}

class MockValueChangeFunc extends Mock {
  void call(
    int h,
    int s,
    int p,
    Pointer<Utf16> x,
    Pointer<Utf16> y,
    int dc,
    Pointer<Utf16> id,
    Pointer<Utf16> z,
    int cf,
  );
}

class MockCustomEventFunc extends Mock {
  void call(
    int h,
    int c,
    Pointer<Utf16> e,
    int pc,
    Pointer<Utf16> p1,
    Pointer<Utf16> p2,
    Pointer<Utf16> p3,
    Pointer<Utf16> p4,
    Pointer<Utf16> p5,
    Pointer<Utf16> p6,
    Pointer<Utf16> p7,
    Pointer<Utf16> p8,
    Pointer<Utf16> p9,
    Pointer<Utf16> p10,
    Pointer<Utf16> p11,
    Pointer<Utf16> p12,
  );
}
