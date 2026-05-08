import 'dart:ffi';
import 'package:ffi/ffi.dart';

// ==========================================
// DEFINITION OF NATIVE SIGNATURES (C)
// ==========================================

// --- CONNECTION AND MEMORY MANAGEMENT ---
typedef ConnectC = Uint64 Function();
typedef ReleaseC = Void Function(Uint64);
typedef FreeStringC = Void Function(Pointer<Utf16>);

// --- PROPERTY MANAGEMENT (GET/SET) ---
typedef GetPropStrC = Pointer<Utf16> Function(Uint64, Pointer<Utf16>);
typedef SetPropStrC = Void Function(Uint64, Pointer<Utf16>, Pointer<Utf16>);
typedef GetPropIntC = Int32 Function(Uint64, Pointer<Utf16>);
typedef SetPropIntC = Void Function(Uint64, Pointer<Utf16>, Int32);
typedef GetPropObjC = Uint64 Function(Uint64, Pointer<Utf16>);
typedef SetPropObjC = Void Function(Uint64, Pointer<Utf16>, Uint64);

// --- COLLECTIONS ACCESS ---
typedef GetCountC = Int32 Function(Uint64);
typedef GetChildC = Uint64 Function(Uint64, Int32);

// --- VOID METHODS (ACTIONS) ---
typedef InvokeVoidC = Void Function(Uint64, Pointer<Utf16>);
typedef InvokeVoidIntC = Void Function(Uint64, Pointer<Utf16>, Int32);
typedef InvokeVoidStrC = Void Function(Uint64, Pointer<Utf16>, Pointer<Utf16>);
typedef InvokeVoidIntStrC =
    Void Function(Uint64, Pointer<Utf16>, Int32, Pointer<Utf16>);
typedef InvokeVoidStrIntC =
    Void Function(Uint64, Pointer<Utf16>, Pointer<Utf16>, Int32);
typedef InvokeVoidStrStrC =
    Void Function(Uint64, Pointer<Utf16>, Pointer<Utf16>, Pointer<Utf16>);
typedef InvokeVoidStrStrStrC =
    Void Function(
      Uint64,
      Pointer<Utf16>,
      Pointer<Utf16>,
      Pointer<Utf16>,
      Pointer<Utf16>,
    );
typedef InvokeVoidIntIntC = Void Function(Uint64, Pointer<Utf16>, Int32, Int32);
typedef InvokeVoidIntStrStrC =
    Void Function(
      Uint64,
      Pointer<Utf16>,
      Int32,
      Pointer<Utf16>,
      Pointer<Utf16>,
    );
typedef InvokeVoidIntStrIntC =
    Void Function(Uint64, Pointer<Utf16>, Int32, Pointer<Utf16>, Int32);
typedef InvokeVoidStrStrIntC =
    Void Function(
      Uint64,
      Pointer<Utf16>,
      Pointer<Utf16>,
      Pointer<Utf16>,
      Int32,
    );
typedef InvokeVoidIntIntIntC =
    Void Function(Uint64, Pointer<Utf16>, Int32, Int32, Int32);
typedef InvokeVoidIntIntIntStrStrC =
    Void Function(
      Uint64,
      Pointer<Utf16>,
      Int32,
      Int32,
      Int32,
      Pointer<Utf16>,
      Pointer<Utf16>,
    );

// --- METHODS RETURNING STRINGS ---
typedef InvokeStrStrC =
    Pointer<Utf16> Function(Uint64, Pointer<Utf16>, Pointer<Utf16>);
typedef InvokeStrIntC = Pointer<Utf16> Function(Uint64, Pointer<Utf16>, Int32);
typedef InvokeStrIntStrC =
    Pointer<Utf16> Function(Uint64, Pointer<Utf16>, Int32, Pointer<Utf16>);
typedef InvokeStrStrStrC =
    Pointer<Utf16> Function(
      Uint64,
      Pointer<Utf16>,
      Pointer<Utf16>,
      Pointer<Utf16>,
    );
typedef InvokeStrIntIntC =
    Pointer<Utf16> Function(Uint64, Pointer<Utf16>, Int32, Int32);
typedef InvokeStrIntIntIntC =
    Pointer<Utf16> Function(Uint64, Pointer<Utf16>, Int32, Int32, Int32);
// Signatures for GetObjectTree
typedef GetObjTreeC =
    Pointer<Utf16> Function(
      Uint64 handle,
      Pointer<Utf16> id,
      Pointer<Pointer<Utf16>> props,
      Int32 propsCount,
    );

// --- METHODS RETURNING INTEGERS ---
typedef InvokeIntNoArgsC = Int32 Function(Uint64, Pointer<Utf16>);
typedef InvokeIntStrC = Int32 Function(Uint64, Pointer<Utf16>, Pointer<Utf16>);
typedef InvokeIntIntC = Int32 Function(Uint64, Pointer<Utf16>, Int32);
typedef InvokeIntIntStrC =
    Int32 Function(Uint64, Pointer<Utf16>, Int32, Pointer<Utf16>);
typedef InvokeIntStrStrC =
    Int32 Function(Uint64, Pointer<Utf16>, Pointer<Utf16>, Pointer<Utf16>);

// --- METHODS RETURNING OBJECTS ---
typedef InvokeObjNoArgsC = Uint64 Function(Uint64, Pointer<Utf16>);
typedef InvokeObjStrC = Uint64 Function(Uint64, Pointer<Utf16>, Pointer<Utf16>);
typedef InvokeObjIntC = Uint64 Function(Uint64, Pointer<Utf16>, Int32);
typedef InvokeObjStrStrC =
    Uint64 Function(Uint64, Pointer<Utf16>, Pointer<Utf16>, Pointer<Utf16>);
typedef InvokeObjStrIntC =
    Uint64 Function(Uint64, Pointer<Utf16>, Pointer<Utf16>, Int32);
typedef InvokeObjIntStrC =
    Uint64 Function(Uint64, Pointer<Utf16>, Int32, Pointer<Utf16>);
typedef InvokeObjIntIntC =
    Uint64 Function(Uint64, Pointer<Utf16>, Int32, Int32);
typedef InvokeObjStrIntIntC =
    Uint64 Function(Uint64, Pointer<Utf16>, Pointer<Utf16>, Int32, Int32);
typedef InvokeMethodBytesNoArgsC =
    Pointer<Uint8> Function(Uint64, Pointer<Utf16>, Pointer<Int32>);
typedef SapFreeBytesC = Void Function(Pointer<Uint8>);
typedef InvokeIntStrStrIntIntC =
    Int32 Function(
      Uint64,
      Pointer<Utf16>,
      Pointer<Utf16>,
      Pointer<Utf16>,
      Int32,
      Int32,
    );

typedef SapInvokeMethodVoidValueChangeC =
    Void Function(
      Uint64 h,
      Int32 series,
      Int32 point,
      Pointer<Utf16> xValue,
      Pointer<Utf16> yValue,
      Uint8 dataChange,
      Pointer<Utf16> id,
      Pointer<Utf16> zValue,
      Int32 changeFlag,
    );

typedef SapInvokeMethodVoidCustomEventC =
    Void Function(
      Uint64 h,
      Int32 cookie,
      Pointer<Utf16> eventName,
      Int32 paramCount,
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

// ==========================================
// DEFINITION OF DART SIGNATURES 
// ==========================================

// --- CONNECTION AND MEMORY MANAGEMENT ---
typedef ConnectDart = int Function();
typedef ReleaseDart = void Function(int);
typedef FreeStringDart = void Function(Pointer<Utf16>);

// --- PROPERTY MANAGEMENT (GET/SET) ---
typedef GetPropStrDart = Pointer<Utf16> Function(int, Pointer<Utf16>);
typedef SetPropStrDart = void Function(int, Pointer<Utf16>, Pointer<Utf16>);
typedef GetPropIntDart = int Function(int, Pointer<Utf16>);
typedef SetPropIntDart = void Function(int, Pointer<Utf16>, int);
typedef GetPropObjDart = int Function(int, Pointer<Utf16>);
typedef SetPropObjDart = void Function(int, Pointer<Utf16>, int);

// --- COLLECTIONS ACCESS ---
typedef GetCountDart = int Function(int);
typedef GetChildDart = int Function(int, int);

// --- VOID METHODS (ACTIONS) ---
typedef InvokeVoidDart = void Function(int, Pointer<Utf16>);
typedef InvokeVoidIntDart = void Function(int, Pointer<Utf16>, int);
typedef InvokeVoidStrDart = void Function(int, Pointer<Utf16>, Pointer<Utf16>);
typedef InvokeVoidIntStrDart =
    void Function(int, Pointer<Utf16>, int, Pointer<Utf16>);
typedef InvokeVoidStrIntDart =
    void Function(int, Pointer<Utf16>, Pointer<Utf16>, int);
typedef InvokeVoidStrStrDart =
    void Function(int, Pointer<Utf16>, Pointer<Utf16>, Pointer<Utf16>);
typedef InvokeVoidStrStrStrDart =
    void Function(
      int,
      Pointer<Utf16>,
      Pointer<Utf16>,
      Pointer<Utf16>,
      Pointer<Utf16>,
    );
typedef InvokeVoidIntIntDart = void Function(int, Pointer<Utf16>, int, int);
typedef InvokeVoidIntStrStrDart =
    void Function(int, Pointer<Utf16>, int, Pointer<Utf16>, Pointer<Utf16>);
typedef InvokeVoidIntStrIntDart =
    void Function(int, Pointer<Utf16>, int, Pointer<Utf16>, int);
typedef InvokeVoidStrStrIntDart =
    void Function(int, Pointer<Utf16>, Pointer<Utf16>, Pointer<Utf16>, int);
typedef InvokeVoidIntIntIntDart =
    void Function(int, Pointer<Utf16>, int, int, int);
typedef InvokeVoidIntIntIntStrStrDart =
    void Function(
      int,
      Pointer<Utf16>,
      int,
      int,
      int,
      Pointer<Utf16>,
      Pointer<Utf16>,
    );
// --- METHODS RETURNING STRINGS ---
typedef InvokeStrNoArgsDart = Pointer<Utf16> Function(int, Pointer<Utf16>);
typedef InvokeStrNoArgsC = Pointer<Utf16> Function(Uint64, Pointer<Utf16>);
typedef InvokeStrStrDart =
    Pointer<Utf16> Function(int, Pointer<Utf16>, Pointer<Utf16>);
typedef InvokeStrIntDart = Pointer<Utf16> Function(int, Pointer<Utf16>, int);
typedef InvokeStrIntStrDart =
    Pointer<Utf16> Function(int, Pointer<Utf16>, int, Pointer<Utf16>);
typedef InvokeStrStrStrDart =
    Pointer<Utf16> Function(
      int,
      Pointer<Utf16>,
      Pointer<Utf16>,
      Pointer<Utf16>,
    );
typedef InvokeStrIntIntDart =
    Pointer<Utf16> Function(int, Pointer<Utf16>, int, int);
typedef InvokeStrIntIntIntDart =
    Pointer<Utf16> Function(int, Pointer<Utf16>, int, int, int);

// --- METHODS RETURNING INTEGERS ---
typedef InvokeIntNoArgsDart = int Function(int, Pointer<Utf16>);
typedef InvokeIntStrDart = int Function(int, Pointer<Utf16>, Pointer<Utf16>);
typedef InvokeIntIntDart = int Function(int, Pointer<Utf16>, int);
typedef InvokeIntIntStrDart =
    int Function(int, Pointer<Utf16>, int, Pointer<Utf16>);
typedef InvokeIntStrStrDart =
    int Function(int, Pointer<Utf16>, Pointer<Utf16>, Pointer<Utf16>);

// --- METHODS RETURNING OBJECTS ---
typedef InvokeObjNoArgsDart = int Function(int, Pointer<Utf16>);
typedef InvokeObjStrDart = int Function(int, Pointer<Utf16>, Pointer<Utf16>);
typedef InvokeObjIntDart = int Function(int, Pointer<Utf16>, int);
typedef InvokeObjStrStrDart =
    int Function(int, Pointer<Utf16>, Pointer<Utf16>, Pointer<Utf16>);
typedef InvokeObjStrIntDart =
    int Function(int, Pointer<Utf16>, Pointer<Utf16>, int);
typedef InvokeObjIntStrDart =
    int Function(int, Pointer<Utf16>, int, Pointer<Utf16>);
typedef InvokeObjIntIntDart = int Function(int, Pointer<Utf16>, int, int);
typedef InvokeObjStrIntIntDart =
    int Function(int, Pointer<Utf16>, Pointer<Utf16>, int, int);
typedef InvokeMethodBytesNoArgsDart =
    Pointer<Uint8> Function(int, Pointer<Utf16>, Pointer<Int32>);
typedef SapFreeBytesDart = void Function(Pointer<Uint8>);
typedef InvokeIntStrStrIntIntDart =
    int Function(int, Pointer<Utf16>, Pointer<Utf16>, Pointer<Utf16>, int, int);
typedef GetObjTreeDart =
    Pointer<Utf16> Function(
      int handle,
      Pointer<Utf16> id,
      Pointer<Pointer<Utf16>> props,
      int propsCount,
    );

typedef SapInvokeMethodVoidValueChangeDart =
    void Function(
      int h,
      int series,
      int point,
      Pointer<Utf16> xValue,
      Pointer<Utf16> yValue,
      int dataChange,
      Pointer<Utf16> id,
      Pointer<Utf16> zValue,
      int changeFlag,
    );

typedef SapInvokeMethodVoidCustomEventDart =
    void Function(
      int h,
      int cookie,
      Pointer<Utf16> eventName,
      int paramCount,
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
