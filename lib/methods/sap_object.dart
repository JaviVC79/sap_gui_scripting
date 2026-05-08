import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_api.dart';
import 'package:win32/win32.dart';

class _FinalizerState {
  final int handle;
  final ISapApi api;
  _FinalizerState(this.handle, this.api);
}

class SapObject implements ISapObject {
  @override
  final int handle;
  final ISapApi _api;
  final bool owned;
  bool _disposed = false;

  SapObject(this.handle, this._api, {this.owned = true}) {
    if (owned && handle != 0) {
      _finalizer.attach(this, _FinalizerState(handle, _api), detach: this);
    }
  }

  // ==========================================
  // STATE AND MEMORY MANAGEMENT
  // ==========================================
  @override
  bool get isValid => handle != 0;
  @override
  bool get isInvalid => handle == 0;

  static final Finalizer<_FinalizerState> _finalizer = Finalizer((state) {
    if (state.handle != 0) {
      state.api.release(state.handle);
    }
  });

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    if (owned && handle != 0) {
      _finalizer.detach(this);
      _api.release(handle);
    }
  }

  @override
  void release() {
    if (handle != 0) {
      _api.release(handle);
    }
  }

  static SapObject? connect(ISapApi api) {
    try {
      if (!api.initialized) {
        api.initialize();
      }
      final h = api.connect();
      if (h == 0) {
        return null;
      }
      return SapObject(h, api, owned: true);
    } catch (e) {
      return null;
    }
  }

  // ==========================================
  // EXECUTION ENGINES (FFI HELPERS)
  // ==========================================

  // --- Properties ---
  String _getStrProp(String p) {
    final ptrP = p.toNativeUtf16();
    final res = _api.getPropertyString(handle, ptrP);
    malloc.free(ptrP);
    if (res == nullptr) return "";
    final s = res.toDartString();
    _api.freeString(res);
    return s;
  }

  void _setStrProp(String p, String v) {
    final ptrP = p.toNativeUtf16();
    final ptrV = v.toNativeUtf16();
    _api.setPropertyString(handle, ptrP, ptrV);
    malloc.free(ptrP);
    malloc.free(ptrV);
  }

  int _getIntProp(String p) {
    final ptrP = p.toNativeUtf16();
    final res = _api.getPropertyInt(handle, ptrP);
    malloc.free(ptrP);
    return res;
  }

  bool _getBoolProp(String p) {
    final ptrP = p.toNativeUtf16();
    final res = _api.getPropertyInt(handle, ptrP);
    malloc.free(ptrP);
    return res != 0;
  }

  void _setIntProp(String p, int v) {
    final ptrP = p.toNativeUtf16();
    _api.setPropertyInt(handle, ptrP, v);
    malloc.free(ptrP);
  }

  SapObject? _getObjProp(String p) {
    final ptrP = p.toNativeUtf16();
    final h = _api.getPropertyObject(handle, ptrP);
    malloc.free(ptrP);
    return h == 0 ? null : SapObject(h, _api, owned: false);
  }

  void _setObjProp(String p, int valHandle) {
    final ptrP = p.toNativeUtf16();
    _api.setPropertyObject(handle, ptrP, valHandle);
    malloc.free(ptrP);
  }

  // --- Method Invokers ---
  void _invokeVoid(String m) {
    final ptrM = m.toNativeUtf16();
    _api.invokeVoid(handle, ptrM);
    malloc.free(ptrM);
  }

  void _invokeVoidInt(String m, int a) {
    final ptrM = m.toNativeUtf16();
    _api.invokeVoidInt(handle, ptrM, a);
    malloc.free(ptrM);
  }

  void _invokeVoidStr(String m, String a) {
    final ptrM = m.toNativeUtf16();
    final ptrA = a.toNativeUtf16();
    _api.invokeVoidStr(handle, ptrM, ptrA);
    malloc.free(ptrM);
    malloc.free(ptrA);
  }

  void _invokeVoidIntStr(String m, int a1, String a2) {
    final ptrM = m.toNativeUtf16();
    final ptrA2 = a2.toNativeUtf16();
    _api.invokeVoidIntStr(handle, ptrM, a1, ptrA2);
    malloc.free(ptrM);
    malloc.free(ptrA2);
  }

  void _invokeVoidStrInt(String m, String a1, int a2) {
    final ptrM = m.toNativeUtf16();
    final ptrA1 = a1.toNativeUtf16();
    _api.invokeVoidStrInt(handle, ptrM, ptrA1, a2);
    malloc.free(ptrM);
    malloc.free(ptrA1);
  }

  void _invokeVoidStrStr(String m, String a1, String a2) {
    final ptrM = m.toNativeUtf16();
    final ptrA1 = a1.toNativeUtf16();
    final ptrA2 = a2.toNativeUtf16();
    _api.invokeVoidStrStr(handle, ptrM, ptrA1, ptrA2);
    malloc.free(ptrM);
    malloc.free(ptrA1);
    malloc.free(ptrA2);
  }

  void _invokeVoidStrStrStr(String m, String a1, String a2, String a3) {
    final ptrM = m.toNativeUtf16();
    final ptrA1 = a1.toNativeUtf16();
    final ptrA2 = a2.toNativeUtf16();
    final ptrA3 = a3.toNativeUtf16();
    _api.invokeVoidStrStrStr(handle, ptrM, ptrA1, ptrA2, ptrA3);
    malloc.free(ptrM);
    malloc.free(ptrA1);
    malloc.free(ptrA2);
    malloc.free(ptrA3);
  }

  void _invokeVoidIntInt(String m, int a1, int a2) {
    final ptrM = m.toNativeUtf16();
    _api.invokeVoidIntInt(handle, ptrM, a1, a2);
    malloc.free(ptrM);
  }

  void _invokeVoidIntIntInt(String m, int a1, int a2, int a3) {
    final ptrM = m.toNativeUtf16();
    _api.invokeVoidIntIntInt(handle, ptrM, a1, a2, a3);
    malloc.free(ptrM);
  }

  void _invokeVoidIntStrStr(String m, int a1, String a2, String a3) {
    final ptrM = m.toNativeUtf16();
    final ptrA2 = a2.toNativeUtf16();
    final ptrA3 = a3.toNativeUtf16();
    _api.invokeVoidIntStrStr(handle, ptrM, a1, ptrA2, ptrA3);
    malloc.free(ptrM);
    malloc.free(ptrA2);
    malloc.free(ptrA3);
  }

  void _invokeVoidIntStrInt(String m, int a1, String a2, int a3) {
    final ptrM = m.toNativeUtf16();
    final ptrA2 = a2.toNativeUtf16();
    _api.invokeVoidIntStrInt(handle, ptrM, a1, ptrA2, a3);
    malloc.free(ptrM);
    malloc.free(ptrA2);
  }

  void _invokeVoidStrStrInt(String m, String a1, String a2, int a3) {
    final ptrM = m.toNativeUtf16();
    final ptrA1 = a1.toNativeUtf16();
    final ptrA2 = a2.toNativeUtf16();
    _api.invokeVoidStrStrInt(handle, ptrM, ptrA1, ptrA2, a3);
    malloc.free(ptrM);
    malloc.free(ptrA1);
    malloc.free(ptrA2);
  }

  int _invokeIntNoArgs(String m) {
    final ptrM = m.toNativeUtf16();
    final res = _api.invokeIntNoArgs(handle, ptrM);
    malloc.free(ptrM);
    return res;
  }

  int _invokeIntStr(String m, String a) {
    final ptrM = m.toNativeUtf16();
    final ptrA = a.toNativeUtf16();
    final res = _api.invokeIntStr(handle, ptrM, ptrA);
    malloc.free(ptrM);
    malloc.free(ptrA);
    return res;
  }

  int _invokeIntInt(String m, int a) {
    final ptrM = m.toNativeUtf16();
    final res = _api.invokeIntInt(handle, ptrM, a);
    malloc.free(ptrM);
    return res;
  }

  int _invokeIntIntStr(String m, int a1, String a2) {
    final ptrM = m.toNativeUtf16();
    final ptrA2 = a2.toNativeUtf16();
    final res = _api.invokeIntIntStr(handle, ptrM, a1, ptrA2);
    malloc.free(ptrM);
    malloc.free(ptrA2);
    return res;
  }

  int _invokeIntStrStrIntInt(String m, String a1, String a2, int a3, int a4) {
    final ptrM = m.toNativeUtf16();
    final ptrA1 = a1.toNativeUtf16();
    final ptrA2 = a2.toNativeUtf16();
    final res = _api.invokeIntStrStrIntInt(handle, ptrM, ptrA1, ptrA2, a3, a4);
    malloc.free(ptrM);
    malloc.free(ptrA1);
    malloc.free(ptrA2);
    return res;
  }

  int _invokeIntStrStr(String m, String a1, String a2) {
    final ptrM = m.toNativeUtf16();
    final ptrA1 = a1.toNativeUtf16();
    final ptrA2 = a2.toNativeUtf16();
    final res = _api.invokeIntStrStr(handle, ptrM, ptrA1, ptrA2);
    malloc.free(ptrM);
    malloc.free(ptrA1);
    malloc.free(ptrA2);
    return res;
  }

  String _invokeStrInt(String m, int a) {
    final ptrM = m.toNativeUtf16();
    final res = _api.invokeStrInt(handle, ptrM, a);
    malloc.free(ptrM);
    if (res == nullptr) return "";
    final s = res.toDartString();
    _api.freeString(res);
    return s;
  }

  String _invokeStrIntInt(String m, int a1, int a2) {
    final ptrM = m.toNativeUtf16();
    final res = _api.invokeStrIntInt(handle, ptrM, a1, a2);
    malloc.free(ptrM);
    if (res == nullptr) return "";
    final s = res.toDartString();
    _api.freeString(res);
    return s;
  }

  String _invokeStrIntIntInt(String m, int a1, int a2, int a3) {
    final ptrM = m.toNativeUtf16();
    final res = _api.invokeStrIntIntInt(handle, ptrM, a1, a2, a3);
    malloc.free(ptrM);
    if (res == nullptr) return "";
    final s = res.toDartString();
    _api.freeString(res);
    return s;
  }

  String _invokeStrStr(String m, String a) {
    final ptrM = m.toNativeUtf16();
    final ptrA = a.toNativeUtf16();
    final res = _api.invokeStrStr(handle, ptrM, ptrA);
    malloc.free(ptrM);
    malloc.free(ptrA);
    if (res == nullptr) return "";
    final s = res.toDartString();
    _api.freeString(res);
    return s;
  }

  String _invokeStrIntStr(String m, int a1, String a2) {
    final ptrM = m.toNativeUtf16();
    final ptrA2 = a2.toNativeUtf16();
    final res = _api.invokeStrIntStr(handle, ptrM, a1, ptrA2);
    malloc.free(ptrM);
    malloc.free(ptrA2);
    if (res == nullptr) return "";
    final s = res.toDartString();
    _api.freeString(res);
    return s;
  }

  String _invokeStrStrStr(String m, String a1, String a2) {
    final ptrM = m.toNativeUtf16();
    final ptrA1 = a1.toNativeUtf16();
    final ptrA2 = a2.toNativeUtf16();
    final res = _api.invokeStrStrStr(handle, ptrM, ptrA1, ptrA2);
    malloc.free(ptrM);
    malloc.free(ptrA1);
    malloc.free(ptrA2);
    if (res == nullptr) return "";
    final s = res.toDartString();
    _api.freeString(res);
    return s;
  }

  SapObject? _invokeObjNoArgs(String m) {
    final ptrM = m.toNativeUtf16();
    final res = _api.invokeObjNoArgs(handle, ptrM);
    malloc.free(ptrM);
    return res == 0 ? null : SapObject(res, _api, owned: false);
  }

  SapObject? _invokeObjInt(String m, int a) {
    final ptrM = m.toNativeUtf16();
    final res = _api.invokeObjInt(handle, ptrM, a);
    malloc.free(ptrM);
    return res == 0 ? null : SapObject(res, _api, owned: false);
  }

  SapObject? _invokeObjStr(String m, String a) {
    final ptrM = m.toNativeUtf16();
    final ptrA = a.toNativeUtf16();
    final res = _api.invokeObjStr(handle, ptrM, ptrA);
    malloc.free(ptrM);
    malloc.free(ptrA);
    return res == 0 ? null : SapObject(res, _api, owned: false);
  }

  SapObject? _invokeObjStrStr(String m, String a1, String a2) {
    final ptrM = m.toNativeUtf16();
    final ptrA1 = a1.toNativeUtf16();
    final ptrA2 = a2.toNativeUtf16();
    final res = _api.invokeObjStrStr(handle, ptrM, ptrA1, ptrA2);
    malloc.free(ptrM);
    malloc.free(ptrA1);
    malloc.free(ptrA2);
    return res == 0 ? null : SapObject(res, _api, owned: false);
  }

  SapObject? _invokeObjStrInt(String m, String a1, int a2) {
    final ptrM = m.toNativeUtf16();
    final ptrA1 = a1.toNativeUtf16();
    final res = _api.invokeObjStrInt(handle, ptrM, ptrA1, a2);
    malloc.free(ptrM);
    malloc.free(ptrA1);
    return res == 0 ? null : SapObject(res, _api, owned: false);
  }

  SapObject? _invokeObjIntStr(String m, int a1, String a2) {
    final ptrM = m.toNativeUtf16();
    final ptrA1 = a2.toNativeUtf16();
    final res = _api.invokeObjIntStr(handle, ptrM, a1, ptrA1);
    malloc.free(ptrM);
    malloc.free(ptrA1);
    return res == 0 ? null : SapObject(res, _api, owned: false);
  }

  SapObject? _invokeObjIntInt(String m, int a1, int a2) {
    final ptrM = m.toNativeUtf16();
    final res = _api.invokeObjIntInt(handle, ptrM, a1, a2);
    malloc.free(ptrM);
    return res == 0 ? null : SapObject(res, _api, owned: false);
  }

  SapObject? _invokeObjStrIntInt(String m, String a1, int a2, int a3) {
    final ptrM = m.toNativeUtf16();
    final ptrA1 = a1.toNativeUtf16();
    final res = _api.invokeObjStrIntInt(handle, ptrM, ptrA1, a2, a3);
    malloc.free(ptrM);
    malloc.free(ptrA1);
    return res == 0 ? null : SapObject(res, _api, owned: false);
  }

  List<String>? _extractStringList(SapObject? coll, String operationName) {
    if (coll == null) return <String>[];
    final List<String> result = [];
    try {
      final int count = coll._getIntProp("Count");
      for (int i = 0; i < count; i++) {
        result.add(coll._invokeStrInt("Item", i));
      }
    } catch (e) {
      return null;
    } finally {
      coll.release();
    }

    return result;
  }

  // --- Specific helper for ValueChange ---
  void invokeValueChange(
    int series,
    int point,
    String xValue,
    String yValue,
    bool dataChange,
    String id,
    String zValue,
    int changeFlag,
  ) {
    final dataChangeToInt = dataChange ? 1 : 0;
    final ptrXValue = xValue.toNativeUtf16();
    final ptrYValue = yValue.toNativeUtf16();
    final ptrId = id.toNativeUtf16();
    final ptrZValue = zValue.toNativeUtf16();
    try {
      _api.invokeMethodVoidValueChange(
        handle,
        series,
        point,
        ptrXValue,
        ptrYValue,
        dataChangeToInt,
        ptrId,
        ptrZValue,
        changeFlag,
      );
    } finally {
      malloc.free(ptrXValue);
      malloc.free(ptrYValue);
      malloc.free(ptrId);
      malloc.free(ptrZValue);
    }
  }

  // ==========================================
  // SPECIAL AND CONNECTION METHODS
  // ==========================================
  @override
  ISapObject? openConnection(
    String desc, {
    bool sync = true,
    bool raise = true,
  }) {
    return _invokeObjStrIntInt(
      "OpenConnection",
      desc,
      sync ? 1 : 0,
      raise ? 1 : 0,
    );
  }

  @override
  ISapObject? openConnectionByConnectionString(
    String conn, {
    bool sync = true,
    bool raise = true,
  }) {
    return _invokeObjStrIntInt(
      "OpenConnectionByConnectionString",
      conn,
      sync ? 1 : 0,
      raise ? 1 : 0,
    );
  }

  // ==========================================
  @override
  String getCellListBoxCurIndex(int row, String column) =>
      _invokeStrIntStr("GetCellListBoxCurIndex", row, column);
  @override
  String getColumnOperationType(String column) =>
      _invokeStrStr('GetColumnOperationType', column);
  @override
  String get id => _getStrProp("Id");
  @override
  String get name => _getStrProp("Name");
  @override
  String get type => _getStrProp("Type");
  @override
  int get typeAsNumber => _getIntProp("TypeAsNumber");
  @override
  bool get containerType => _getIntProp("ContainerType") != 0;
  @override
  String get text => _getStrProp("Text");
  @override
  set text(String v) => _setStrProp("Text", v);
  @override
  String get tooltip => _getStrProp("Tooltip");
  @override
  String get iconName => _getStrProp("IconName");
  @override
  bool get changeable => _getIntProp("Changeable") != 0;
  @override
  bool get modified => _getIntProp("Modified") != 0;
  @override
  set modified(bool value) => _setIntProp("Modified", value ? 1 : 0);
  @override
  int get width => _getIntProp("Width");
  @override
  int get height => _getIntProp("Height");
  @override
  int get left => _getIntProp("Left");
  @override
  int get top => _getIntProp("Top");
  @override
  set top(int value) => _setIntProp("Top", value);
  @override
  ISapObject? get parent => _getObjProp("Parent");
  @override
  ISapObject? get children => _getObjProp("Children");
  @override
  int get count => _getIntProp("Count");
  @override
  ISapObject? item(int index) => _invokeObjInt("Item", index);
  @override
  ISapObject? elementAt(int index) => _invokeObjInt("ElementAt", index);
  @override
  ISapObject? get activeSession => _getObjProp("ActiveSession");
  @override
  ISapObject? get activeWindow => _getObjProp("ActiveWindow");
  @override
  ISapObject? get info => _getObjProp("Info");
  @override
  bool get busy => _getIntProp("Busy") != 0;
  @override
  String get systemName => _getStrProp("SystemName");
  @override
  String get client => _getStrProp("Client");
  @override
  String get user => _getStrProp("User");
  @override
  String get language => _getStrProp("Language");
  @override
  String get transaction => _getStrProp("Transaction");
  @override
  String get program => _getStrProp("Program");
  @override
  int get screenNumber => _getIntProp("ScreenNumber");
  @override
  int get responseTime => _getIntProp("ResponseTime");
  @override
  ISapObject? get accLabelCollection => _getObjProp("AccLabelCollection");
  @override
  String get accText => _getStrProp("AccText");
  @override
  String get accTextOnRequest => _getStrProp("AccTextOnRequest");
  @override
  String get accTooltip => _getStrProp("AccTooltip");
  @override
  String get defaultTooltip => _getStrProp("DefaultTooltip");
  @override
  int get screenLeft => _getIntProp("ScreenLeft");
  @override
  int get screenTop => _getIntProp("ScreenTop");
  @override
  bool get isSymbolFont => _getIntProp("IsSymbolFont") != 0;
  @override
  bool get historyIsActiveProp => _getIntProp("HistoryIsActive") != 0;
  @override
  bool get isOField => _getIntProp("IsOField") != 0;
  @override
  bool get required => _getIntProp("Required") != 0;
  @override
  bool get flushing => _getIntProp("Flushing") != 0;
  @override
  int get groupCount => _getIntProp("GroupCount");
  @override
  int get groupPos => _getIntProp("GroupPos");
  @override
  List<String>? get historyListProp =>
      _extractStringList(_getObjProp("HistoryList"), "HistoryList");
  @override
  ISapObject? get parentFrame => _getObjProp("ParentFrame");
  @override
  ISapObject? get groupMembers => _getObjProp("GroupMembers");
  @override
  ISapObject? get connections => _getObjProp("Connections");
  @override
  String get connectionErrorText => _getStrProp("ConnectionErrorText");
  @override
  ISapObject? get utils => _getObjProp("Utils");
  @override
  bool get allowSystemMessages => _getIntProp("AllowSystemMessages") != 0;
  @override
  set allowSystemMessages(bool v) =>
      _setIntProp("AllowSystemMessages", v ? 1 : 0);
  @override
  bool get buttonbarVisible => _getIntProp("ButtonbarVisible") != 0;
  @override
  set buttonbarVisible(bool v) => _setIntProp("ButtonbarVisible", v ? 1 : 0);
  @override
  bool get statusbarVisible => _getIntProp("StatusbarVisible") != 0;
  @override
  set statusbarVisible(bool v) => _setIntProp("StatusbarVisible", v ? 1 : 0);
  @override
  bool get titlebarVisible => _getIntProp("TitlebarVisible") != 0;
  @override
  set titlebarVisible(bool v) => _setIntProp("TitlebarVisible", v ? 1 : 0);
  @override
  bool get toolbarVisible => _getIntProp("ToolbarVisible") != 0;
  @override
  set toolbarVisible(bool v) => _setIntProp("ToolbarVisible", v ? 1 : 0);
  @override
  bool get historyEnabled => _getIntProp("HistoryEnabled") != 0;
  @override
  set historyEnabled(bool v) => _setIntProp("HistoryEnabled", v ? 1 : 0);
  @override
  set selected(bool v) => _setIntProp("Selected", v ? 1 : 0);
  @override
  bool get fixed => _getIntProp("Fixed") != 0;
  @override
  int get majorVersion => _getIntProp("MajorVersion");
  @override
  int get minorVersion => _getIntProp("MinorVersion");
  @override
  int get patchlevel => _getIntProp("Patchlevel");
  @override
  int get revision => _getIntProp("Revision");
  @override
  bool get newVisualDesign => _getIntProp("NewVisualDesign") != 0;
  @override
  String get connectionString => _getStrProp("ConnectionString");
  @override
  String get description => _getStrProp("Description");
  @override
  bool get disabledByServer => _getIntProp("DisabledByServer") != 0;
  @override
  ISapObject? get sessions => _getObjProp("Sessions");
  @override
  ISapObject? get errorList => _getObjProp("ErrorList");
  @override
  bool get isListAdapter => _getIntProp("IsListAdapter") != 0;
  @override
  String get passport => _getStrProp("Passport");
  @override
  set passport(String v) => _setStrProp("Passport", v);
  @override
  String get recordFile => _getStrProp("RecordFile");
  @override
  set recordFile(String v) => _setStrProp("RecordFile", v);
  @override
  bool get recording => _getIntProp("Recording") != 0;
  @override
  set recording(bool v) => _setIntProp("Recording", v ? 1 : 0);
  @override
  int get testToolMode => _getIntProp("TestToolMode");
  @override
  set testToolMode(int v) => _setIntProp("TestToolMode", v);
  @override
  String get applicationServer => _getStrProp("ApplicationServer");
  @override
  int get flushes => _getIntProp("Flushes");
  @override
  String get group => _getStrProp("Group");
  @override
  int get guiCodepage => _getIntProp("GuiCodepage");
  @override
  bool get isLowSpeedConnection => _getIntProp("IsLowSpeedConnection") != 0;
  @override
  String get messageServer => _getStrProp("MessageServer");
  @override
  int get roundTrips => _getIntProp("RoundTrips");
  @override
  bool get scriptingModeReadOnly => _getIntProp("ScriptingModeReadOnly") != 0;
  @override
  int get sessionNumber => _getIntProp("SessionNumber");
  @override
  int get systemNumber => _getIntProp("SystemNumber");
  @override
  String get systemSessionId => _getStrProp("SystemSessionId");
  @override
  String get uiGuideline => _getStrProp("UI_GUIDELINE");
  @override
  String get accDescription => _getStrProp("AccDescription");
  @override
  bool get dragDropSupported => _getIntProp("DragDropSupported") != 0;
  @override
  int get shellHandle => _getIntProp("Handle");
  @override
  ISapObject? get ocxEvents => _getObjProp("OcxEvents");
  @override
  String get subType => _getStrProp("SubType");
  @override
  bool get elementVisualizationMode =>
      _getIntProp("ElementVisualizationMode") != 0;
  @override
  set elementVisualizationMode(bool v) =>
      _setIntProp("ElementVisualizationMode", v ? 1 : 0);
  @override
  ISapObject? get guiFocus => _getObjProp("Focus");
  @override
  bool get iconic => _getIntProp("Iconic") != 0;
  @override
  ISapObject? get systemFocus => _getObjProp("SystemFocus");
  @override
  int get workingPaneHeight => _getIntProp("WorkingPaneHeight");
  @override
  int get workingPaneWidth => _getIntProp("WorkingPaneWidth");
  @override
  ISapObject? get rows => _getObjProp("Rows");
  @override
  ISapObject? get verticalScrollbar => _getObjProp("VerticalScrollbar");
  @override
  int get rowCount => _getIntProp("RowCount");
  @override
  int get visibleRowCount => _getIntProp("VisibleRowCount");
  @override
  int get currentCol => _getIntProp("CurrentCol");
  @override
  int get currentRow => _getIntProp("CurrentRow");
  @override
  int get gridColumnCount => _getIntProp("ColumnCount");
  @override
  int get gridRowCount => _getIntProp("RowCount");
  @override
  int get caretPosition => _getIntProp("CaretPosition");
  @override
  set caretPosition(int v) => _setIntProp("CaretPosition", v);
  @override
  String get displayedText => _getStrProp("DisplayedText");
  @override
  int get maxLength => _getIntProp("MaxLength");
  @override
  bool get numerical => _getIntProp("Numerical") != 0;
  @override
  int get focusedHorizontalSash => _getIntProp("FocusedHorizontalSash");
  @override
  int get focusedVerticalSash => _getIntProp("FocusedVerticalSash");
  @override
  bool get isVertical => _getIntProp("IsVertical") != 0;
  @override
  String get rowText => _getStrProp("RowText");
  @override
  int get charHeight => _getIntProp("CharHeight");
  @override
  int get charLeft => _getIntProp("CharLeft");
  @override
  int get charTop => _getIntProp("CharTop");
  @override
  int get charWidth => _getIntProp("CharWidth");
  @override
  int get colorIndex => _getIntProp("ColorIndex");
  @override
  bool get colorIntensified => _getIntProp("ColorIntensified") != 0;
  @override
  bool get colorInverse => _getIntProp("ColorInverse") != 0;
  @override
  bool get highlighted => _getIntProp("Highlighted") != 0;
  @override
  bool get isHotspot => _getIntProp("IsHotspot") != 0;
  @override
  bool get isLeftLabel => _getIntProp("IsLeftLabel") != 0;
  @override
  bool get isRightLabel => _getIntProp("IsRightLabel") != 0;
  @override
  bool get isListElement => _getIntProp("IsListElement") != 0;
  @override
  bool get selected => _getIntProp("Selected") != 0;
  @override
  String getListProperty(String p) => _invokeStrStr("GetListProperty", p);
  @override
  String getListPropertyNonRec(String p) =>
      _invokeStrStr("GetListPropertyNonRec", p);
  @override
  ISapObject? findById(String id) => _invokeObjStr("FindById", id);
  @override
  void press() => _invokeVoid("Press");
  @override
  void select() => _invokeVoid("Select");
  @override
  void sendVKey(int vkey) => _invokeVoidInt("sendVKey", vkey);
  @override
  ISapObject? getCell(int r, int c) => _invokeObjIntInt("GetCell", r, c);
  @override
  void resizeWorkingPane(int w, int h, bool f) => f
      ? _invokeVoidIntIntInt("ResizeWorkingPane", w, h, 1)
      : _invokeVoidIntIntInt("ResizeWorkingPane", w, h, 0);
  @override
  void resizeWorkingPaneEx(int w, int h, bool f) => f
      ? _invokeVoidIntIntInt("ResizeWorkingPaneEx", w, h, 1)
      : _invokeVoidIntIntInt("ResizeWorkingPaneEx", w, h, 0);
  @override
  void clearSelection() => _invokeVoid("ClearSelection");
  @override
  void clickCurrentCell() => _invokeVoid("ClickCurrentCell");
  @override
  void closeConnection() => _invokeVoid("CloseConnection");
  @override
  void closeSession(String id) => _invokeVoidStr("CloseSession", id);
  @override
  void add(String item) => _invokeVoidStr("Add", item);
  @override
  void createSession() => _invokeVoid("CreateSession");
  @override
  void doubleClickCurrentCell() => _invokeVoid("DoubleClickCurrentCell");
  @override
  void endTransaction() => _invokeVoid("EndTransaction");
  @override
  void startTransaction(String t) => _invokeVoidStr("StartTransaction", t);
  @override
  void contextMenu() => _invokeVoid("ContextMenu");
  @override
  void currentCellMoved() => _invokeVoid("CurrentCellMoved");
  @override
  void pressEnter() => _invokeVoid("PressEnter");
  @override
  void pressF1() => _invokeVoid("PressF1");
  @override
  void pressF4() => _invokeVoid("PressF4");
  @override
  void pressButtonCurrentCell() => _invokeVoid("PressButtonCurrentCell");
  @override
  void pressTotalRowCurrentCell() => _invokeVoid("PressTotalRowCurrentCell");
  @override
  void selectAll() => _invokeVoid("SelectAll");
  @override
  void selectionChanged() => _invokeVoid("SelectionChanged");
  @override
  void triggerModified() => _invokeVoid("TriggerModified");
  @override
  void setFocus() => _invokeVoid("SetFocus");
  @override
  int visualize(bool on, String obj) =>
      _invokeIntIntStr("Visualize", on ? 1 : 0, obj);
  @override
  ISapObject? dumpState(String obj) => _invokeObjStr("DumpState", obj);
  @override
  ISapObject? findByName(String n, String t) =>
      _invokeObjStrStr("FindByName", n, t);
  @override
  ISapObject? findAllByName(String n, String t) =>
      _invokeObjStrStr("FindAllByName", n, t);
  @override
  ISapObject? findByNameEx(String n, int t) =>
      _invokeObjStrInt("FindByNameEx", n, t);
  @override
  ISapObject? findAllByNameEx(String n, int t) =>
      _invokeObjStrInt("FindAllByNameEx", n, t);
  @override
  void deleteRows(String r) => _invokeVoidStr("DeleteRows", r);
  @override
  void duplicateRows(String r) => _invokeVoidStr("DuplicateRows", r);
  @override
  void insertRows(String r) => _invokeVoidStr("InsertRows", r);
  @override
  void deselectColumn(String c) => _invokeVoidStr("DeselectColumn", c);
  @override
  void selectColumn(String c) => _invokeVoidStr("SelectColumn", c);
  @override
  void pressColumnHeader(String c) => _invokeVoidStr("PressColumnHeader", c);
  @override
  void pressToolbarButton(String id) =>
      _invokeVoidStr("PressToolbarButton", id);
  @override
  void pressToolbarContextButton(String id) =>
      _invokeVoidStr("PressToolbarContextButton", id);
  @override
  void selectToolbarMenuItem(String id) =>
      _invokeVoidStr("SelectToolbarMenuItem", id);
  @override
  void click(int r, String c) => _invokeVoidIntStr("Click", r, c);
  @override
  void doubleClick(int r, String c) => _invokeVoidIntStr("DoubleClick", r, c);
  @override
  void pressTotalRow(int r, String c) =>
      _invokeVoidIntStr("PressTotalRow", r, c);
  @override
  void setCurrentCell(int r, String c) =>
      _invokeVoidIntStr("SetCurrentCell", r, c);
  @override
  void setColumnWidth(String c, int w) =>
      _invokeVoidStrInt("SetColumnWidth", c, w);
  @override
  void modifyCell(int r, String c, String v) =>
      _invokeVoidIntStrStr("ModifyCell", r, c, v);
  @override
  void modifyCheckBox(int r, String c, bool v) =>
      _invokeVoidIntStrInt("ModifyCheckBox", r, c, v ? 1 : 0);
  @override
  void moveRows(int f, int t, int d) =>
      _invokeVoidIntIntInt("MoveRows", f, t, d);
  @override
  String getCellValue(int r, String c) =>
      _invokeStrIntStr("GetCellValue", r, c);
  @override
  String getCellIcon(int r, String c) => _invokeStrIntStr("GetCellIcon", r, c);
  @override
  String getCellState(int r, String c) =>
      _invokeStrIntStr("GetCellState", r, c);
  @override
  String getCellTooltip(int r, String c) =>
      _invokeStrIntStr("GetCellTooltip", r, c);
  @override
  String getCellType(int r, String c) => _invokeStrIntStr("GetCellType", r, c);
  @override
  String getCellHotspotType(int r, String c) =>
      _invokeStrIntStr("GetCellHotspotType", r, c);
  @override
  int getCellColor(int r, String c) => _invokeIntIntStr("GetCellColor", r, c);
  @override
  int getCellHeight(int r, String c) => _invokeIntIntStr("GetCellHeight", r, c);
  @override
  int getCellWidth(int r, String c) => _invokeIntIntStr("GetCellWidth", r, c);
  @override
  int getCellLeft(int r, String c) => _invokeIntIntStr("GetCellLeft", r, c);
  @override
  int getCellTop(int r, String c) => _invokeIntIntStr("GetCellTop", r, c);
  @override
  int getCellMaxLength(int r, String c) =>
      _invokeIntIntStr("GetCellMaxLength", r, c);
  @override
  int getCellListBoxCount(int r, String c) =>
      _invokeIntIntStr("GetCellListBoxCount", r, c);
  @override
  bool getCellChangeable(int r, String c) =>
      _invokeIntIntStr("GetCellChangeable", r, c) != 0;
  @override
  bool getCellCheckBoxChecked(int r, String c) =>
      _invokeIntIntStr("GetCellCheckBoxChecked", r, c) != 0;
  @override
  bool hasCellF4Help(int r, String c) =>
      _invokeIntIntStr("HasCellF4Help", r, c) != 0;
  @override
  bool isCellHotspot(int r, String c) =>
      _invokeIntIntStr("IsCellHotspot", r, c) != 0;
  @override
  bool isCellSymbol(int r, String c) =>
      _invokeIntIntStr("IsCellSymbol", r, c) != 0;
  @override
  bool isCellTotalExpander(int r, String c) =>
      _invokeIntIntStr("IsCellTotalExpander", r, c) != 0;
  @override
  String getColumnDataType(String c) => _invokeStrStr("GetColumnDataType", c);
  @override
  String getColumnTooltip(String c) => _invokeStrStr("GetColumnTooltip", c);
  @override
  String getDisplayedColumnTitle(String c) =>
      _invokeStrStr("GetDisplayedColumnTitle", c);
  @override
  int getColumnPosition(String c) => _invokeIntStr("GetColumnPosition", c);
  @override
  bool isColumnFiltered(String c) => _invokeIntStr("IsColumnFiltered", c) != 0;
  @override
  bool isColumnKey(String c) => _invokeIntStr("IsColumnKey", c) != 0;
  @override
  String getToolbarButtonId(int p) => _invokeStrInt("GetToolbarButtonId", p);
  @override
  String getToolbarButtonText(int p) =>
      _invokeStrInt("GetToolbarButtonText", p);
  @override
  bool getToolbarButtonEnabled(int p) =>
      _invokeIntInt("GetToolbarButtonEnabled", p) != 0;
  @override
  bool isVKeyAllowed(int vKey) => _invokeIntInt("IsVKeyAllowed", vKey) != 0;
  @override
  bool addHistoryEntry(String f, String v) =>
      _invokeIntStrStr("AddHistoryEntry", f, v) != 0;
  @override
  bool dropHistory() => _invokeIntNoArgs("DropHistory") != 0;
  @override
  ISapObject? createGuiCollection() => _invokeObjNoArgs("CreateGuiCollection");
  @override
  bool registerROT() => _invokeIntNoArgs("RegisterROT") != 0;
  @override
  void revokeROT() => _invokeVoid("RevokeROT");
  @override
  void close() => _invokeVoid("Close");
  @override
  void maximize() => _invokeVoid("Maximize");
  @override
  void iconify() => _invokeVoid("Iconify");
  @override
  void restore() => _invokeVoid("Restore");
  @override
  void jumpBackward() => _invokeVoid('JumpBackward'); // Ctrl+Shift+Tab
  @override
  void jumpForward() => _invokeVoid('JumpForward'); // Ctrl+Tab
  @override
  void tabBackward() => _invokeVoid('TabBackward'); // Shift+Tab
  @override
  void tabForward() => _invokeVoid('TabForward'); // Tab
  @override
  void ignore(int h) => _invokeVoidInt("Ignore", h);
  @override
  bool get emphasized => _getIntProp("Emphasized") != 0;
  @override
  ISapObject? get leftLabel => _getObjProp("LeftLabel");
  @override
  ISapObject? get rightLabel => _getObjProp("RightLabel");
  @override
  void selectContextMenuItem(String f) =>
      _invokeVoidStr("SelectContextMenuItem", f);
  @override
  void selectContextMenuItemByPosition(String p) =>
      _invokeVoidStr("SelectContextMenuItemByPosition", p);
  @override
  void selectContextMenuItemByText(String t) =>
      _invokeVoidStr("SelectContextMenuItemByText", t);
  @override
  int compBitmap(String filename1, String filename2) =>
      _invokeIntStrStr("CompBitmap", filename1, filename2);
  @override
  String hardCopy(String filename) => _invokeStrStr("HardCopy", filename);
  @override
  void collapseNode(String k) => _invokeVoidStr("CollapseNode", k);
  @override
  void expandNode(String k) => _invokeVoidStr("ExpandNode", k);
  @override
  void doubleClickNode(String k) => _invokeVoidStr("DoubleClickNode", k);
  @override
  void selectNode(String k) => _invokeVoidStr("SelectNode", k);
  @override
  void unselectNode(String k) => _invokeVoidStr("UnselectNode", k);
  @override
  void nodeContextMenu(String k) => _invokeVoidStr("NodeContextMenu", k);
  @override
  void headerContextMenu(String n) => _invokeVoidStr("HeaderContextMenu", n);
  @override
  void pressKey(String k) => _invokeVoidStr("PressKey", k);
  @override
  void clickLink(String k, String i) => _invokeVoidStrStr("ClickLink", k, i);
  @override
  void doubleClickItem(String k, String i) =>
      _invokeVoidStrStr("DoubleClickItem", k, i);
  @override
  void pressButton(String k, String i) =>
      _invokeVoidStrStr("PressButton", k, i);
  @override
  void selectItem(String k, String i) => _invokeVoidStrStr("SelectItem", k, i);
  @override
  void ensureVisibleHorizontalItem(String k, String i) =>
      _invokeVoidStrStr("EnsureVisibleHorizontalItem", k, i);
  @override
  void itemContextMenu(String k, String i) =>
      _invokeVoidStrStr("ItemContextMenu", k, i);
  @override
  void changeCheckbox(String k, String i, bool c) =>
      _invokeVoidStrStrInt("ChangeCheckbox", k, i, c ? 1 : 0);
  @override
  void defaultContextMenu() => _invokeVoid("DefaultContextMenu");
  @override
  void unselectAll() => _invokeVoid("UnselectAll");
  @override
  String getItemText(String k, String n) =>
      _invokeStrStrStr("GetItemText", k, n);
  @override
  String getNodeTextByKey(String k) => _invokeStrStr("GetNodeTextByKey", k);
  @override
  String getNodeTextByPath(String p) => _invokeStrStr("GetNodeTextByPath", p);
  @override
  bool getCheckBoxState(String k, String i) =>
      _invokeIntStrStr("GetCheckBoxState", k, i) != 0;
  @override
  bool isFolder(String k) => _invokeIntStr("IsFolder", k) != 0;
  @override
  bool isFolderExpandable(String k) =>
      _invokeIntStr("IsFolderExpandable", k) != 0;
  @override
  bool isFolderExpanded(String k) => _invokeIntStr("IsFolderExpanded", k) != 0;
  @override
  int getTreeType() => _invokeIntNoArgs("GetTreeType");
  @override
  void pressButtonInGrid(int r, String c) =>
      _invokeVoidIntStr("PressButtonInGrid", r, c);
  @override
  set columnOrder(int collectionHandle) {
    _setObjProp("ColumnOrder", collectionHandle);
  }

  @override
  int get hierarchyHeaderWidth => _getIntProp("HierarchyHeaderWidth");
  @override
  set hierarchyHeaderWidth(int v) => _setIntProp("HierarchyHeaderWidth", v);
  @override
  String get selectedNode => _getStrProp("SelectedNode");
  @override
  set selectedNode(String v) => _setStrProp("SelectedNode", v);
  @override
  String get topNode => _getStrProp("TopNode");
  @override
  set topNode(String v) => _setStrProp("TopNode", v);
  @override
  int get columnCount => _getIntProp("ColumnCount");
  @override
  String get title => _getStrProp("Title");
  @override
  int get currentCellRow => _getIntProp("CurrentCellRow");
  @override
  set currentCellRow(int v) => _setIntProp("CurrentCellRow", v);
  @override
  String get currentCellColumn => _getStrProp("CurrentCellColumn");
  @override
  set currentCellColumn(String v) => _setStrProp("CurrentCellColumn", v);
  @override
  String get selectedRows => _getStrProp("SelectedRows");
  @override
  set selectedRows(String v) => _setStrProp("SelectedRows", v);
  @override
  String get firstVisibleColumn => _getStrProp('FirstVisibleColumn');
  @override
  set firstVisibleColumn(String v) => _setStrProp('FirstVisibleColumn', v);
  @override
  int get firstVisibleRow => _getIntProp('FirstVisibleRow');
  @override
  set firstVisibleRow(int v) => _setIntProp('FirstVisibleRow', v);
  @override
  set selectedCells(List<String> cells) {
    final String cellString = cells.join(" ");
    _setStrProp("SelectedCells", cellString);
  }

  @override
  set selectedColumns(List<String> columns) {
    final String columnString = columns.join(" ");
    _setStrProp("SelectedColumns", columnString);
  }

  @override
  int get frozenColumnCount => _getIntProp('FrozenColumnCount');
  @override
  String getColorInfo(int color) => _invokeStrInt('GetColorInfo', color);
  @override
  String getColumnSortType(String column) =>
      _invokeStrStr('GetColumnSortType', column);
  @override
  String getColumnTotalType(String column) =>
      _invokeStrStr('GetColumnTotalType', column);
  @override
  int getRowTotalLevel(int row) => _invokeIntInt('GetRowTotalLevel', row);
  @override
  String getSymbolInfo(String symbol) => _invokeStrStr('GetSymbolInfo', symbol);
  @override
  bool getToolbarButtonChecked(int buttonPos) =>
      _invokeIntInt('GetToolbarButtonChecked', buttonPos) != 0;
  @override
  bool getButtonChecked(int buttonPos) =>
      _invokeIntInt('GetButtonChecked', buttonPos) != 0;
  @override
  bool getButtonEnabled(int buttonPos) =>
      _invokeIntInt('GetButtonEnabled', buttonPos) != 0;
  @override
  String getButtonIcon(int buttonPos) =>
      _invokeStrInt('GetButtonIcon', buttonPos);
  @override
  String getButtonId(int buttonPos) => _invokeStrInt('GetButtonId', buttonPos);
  @override
  String getButtonText(int buttonPos) =>
      _invokeStrInt('GetButtonText', buttonPos);
  @override
  String getButtonTooltip(int buttonPos) =>
      _invokeStrInt('GetButtonTooltip', buttonPos);
  @override
  String getButtonType(int buttonPos) =>
      _invokeStrInt('GetButtonType', buttonPos);
  @override
  String getMenuItemIdFromPosition(int pos) =>
      _invokeStrInt('GetMenuItemIdFromPosition', pos);
  @override
  void pressButtonToolBarControl(String id) =>
      _invokeVoidStr('PressButtonToolBarControl', id);
  @override
  void pressContextButton(String id) =>
      _invokeVoidStr('PressContextButton', id);
  @override
  void selectMenuItem(String id) => _invokeVoidStr('SelectMenuItem', id);
  @override
  void selectMenuItemByText(String text) =>
      _invokeVoidStr('SelectMenuItemByText', text);
  @override
  String getToolbarButtonIcon(int buttonPos) =>
      _invokeStrInt('GetToolbarButtonIcon', buttonPos);
  @override
  String getToolbarButtonTooltip(int buttonPos) =>
      _invokeStrInt('GetToolbarButtonTooltip', buttonPos);
  @override
  String getToolbarButtonType(int buttonPos) =>
      _invokeStrInt('GetToolbarButtonType', buttonPos);
  @override
  int getToolbarFocusButton() => _invokeIntNoArgs('GetToolbarFocusButton');
  @override
  String historyCurEntry(int row, String column) =>
      _invokeStrIntStr('HistoryCurEntry', row, column);
  @override
  int historyCurIndex(int row, String column) =>
      _invokeIntIntStr('HistoryCurIndex', row, column);
  @override
  bool historyIsActive(int row, String column) =>
      _invokeIntIntStr('HistoryIsActive', row, column) != 0;
  @override
  ISapObject? historyList(int row, String column) =>
      _invokeObjIntStr('HistoryList', row, column);
  @override
  bool isTotalRowExpanded(int row) =>
      _invokeIntInt('IsTotalRowExpanded', row) != 0;
  @override
  String get selectionMode => _getStrProp('SelectionMode');
  @override
  int get toolbarButtonCount => _getIntProp('ToolbarButtonCount');
  @override
  int get buttonCount => _getIntProp('ButtonCount');
  @override
  int get focusedButton => _getIntProp('FocusedButton');
  @override
  void configureLayout() {
    _invokeVoid('ConfigureLayout');
  }

  @override
  void deselectAllColumns() {
    _invokeVoid('DeselectAllColumns');
  }

  @override
  ISapObject? getAbsoluteRow(int index) =>
      _invokeObjInt("GetAbsoluteRow", index);
  @override
  void reorderTable(String permutation) {
    _invokeVoidStr('ReorderTable', permutation);
  }

  @override
  void selectAllColumns() {
    _invokeVoid('SelectAllColumns');
  }

  @override
  int barCount(int chartId) => _invokeIntInt('BarCount', chartId);
  @override
  String getBarContent(int chartId, int barId, int textId) =>
      _invokeStrIntIntInt('GetBarContent', chartId, barId, textId);
  @override
  String getGridLineContent(int chartId, int gridlineId, int lineId) =>
      _invokeStrIntIntInt('GetGridLineContent', chartId, gridlineId, lineId);
  @override
  int gridCount(int chartId) => _invokeIntInt('GridCount', chartId);
  @override
  int linkCount(int chartId) => _invokeIntInt('LinkCount', chartId);
  @override
  void sendData(String data) => _invokeVoidStr('SendData', data);
  @override
  int get colSelectMode => _getIntProp('ColSelectMode');
  @override
  int get chartCount => _getIntProp('ChartCount');
  @override
  dynamic get columns => _getObjProp('Columns');
  @override
  SapObject? get horizontalScrollbar => _getObjProp('HorizontalScrollbar');
  @override
  int get rowSelectMode => _getIntProp('RowSelectMode');
  @override
  String get tableFieldName => _getStrProp('TableFieldName');
  @override
  String get historyCurEntryProp => _getStrProp('HistoryCurEntry');
  @override
  int get historyCurIndexProp => _getIntProp('HistoryCurIndex');
  @override
  int get maximum => _getIntProp('Maximum');
  @override
  int get minimum => _getIntProp('Minimum');
  @override
  int get pageSize => _getIntProp('PageSize');
  @override
  int get range => _getIntProp('Range');
  @override
  int get position => _getIntProp('Position');
  @override
  set position(int value) {
    _setIntProp('Position', value);
  }

  @override
  List<String>? get selectedColumns =>
      _extractStringList(_getObjProp("SelectedColumns"), "SelectedColumns");
  @override
  List<String>? get columnOrder =>
      _extractStringList(_getObjProp("ColumnOrder"), "ColumnOrder");
  @override
  List<String>? getColumnTitles(String column) => _extractStringList(
    _invokeObjStr("GetColumnTitles", column),
    "GetColumnTitles",
  );
  @override
  List<String>? get selectedCells =>
      _extractStringList(_getObjProp("SelectedCells"), "SelectedCells");
  @override
  List<String>? getAllNodeKeys() =>
      _extractStringList(_invokeObjNoArgs("GetAllNodeKeys"), "GetAllNodeKeys");
  @override
  List<String>? getSelectedNodes() => _extractStringList(
    _invokeObjNoArgs("GetSelectedNodes"),
    "GetSelectedNodes",
  );
  @override
  List<String>? getColumnNames() =>
      _extractStringList(_invokeObjNoArgs("GetColumnNames"), "GetColumnNames");
  @override
  List<String>? getColumnHeaders() => _extractStringList(
    _invokeObjNoArgs("GetColumnHeaders"),
    "GetColumnHeaders",
  );

  Uint8List _getBytesMethod(String methodName) {
    final ptrMethod = methodName.toNativeUtf16();
    final ptrLength = calloc<Int32>();
    try {
      final Pointer<Uint8> resPtr = _api.invokeMethodBytesNoArgs(
        handle,
        ptrMethod,
        ptrLength,
      );
      if (resPtr == nullptr) {
        return Uint8List(0);
      }
      final int length = ptrLength.value;
      final Uint8List view = resPtr.asTypedList(length);
      final Uint8List result = Uint8List.fromList(view);
      _api.freeBytes(resPtr);
      return result;
    } finally {
      malloc.free(ptrMethod);
      calloc.free(ptrLength);
    }
  }

  @override
  Uint8List hardCopyToMemory() {
    return _getBytesMethod('HardCopyToMemory');
  }

  @override
  int showMessageBox(String title, String text, int msgIcon, int msgType) =>
      _invokeIntStrStrIntInt('ShowMessageBox', title, text, msgIcon, msgType);

  /// Returns the SAP object tree in JSON format.
  /// [id] can be "wnd[0]" for a specific window, or empty "" for the entire session.
  /// [properties] is a list of properties you want to extract (e.g., ["Id", "Text", "Type"]).
  @override
  String getObjectTree(String id, {List<String> properties = const []}) {
    if (isInvalid) return "{}";
    final ptrId = id.toNativeUtf16();
    Pointer<Pointer<Utf16>> ptrProps = nullptr;
    try {
      if (properties.isNotEmpty) {
        ptrProps = calloc<Pointer<Utf16>>(properties.length);
        for (int i = 0; i < properties.length; i++) {
          ptrProps[i] = properties[i].toNativeUtf16();
        }
      }
      final resPtr = _api.getObjectTree(
        handle,
        ptrId,
        ptrProps,
        properties.length,
      );
      if (resPtr == nullptr) return "{}";
      final jsonStr = resPtr.toDartString();
      _api.freeString(resPtr);
      return jsonStr;
    } finally {
      malloc.free(ptrId);
      if (ptrProps != nullptr) {
        for (int i = 0; i < properties.length; i++) {
          malloc.free(ptrProps[i]);
        }
        calloc.free(ptrProps);
      }
    }
  }

  @override
  int get length => _getIntProp("Length");
  @override
  bool get isActive => _getBoolProp("Active");
  @override
  bool get accEnhancedTabChain => _getBoolProp("AccEnhancedTabChain");
  @override
  set accEnhancedTabChain(bool v) =>
      _setIntProp("AccEnhancedTabChain", v ? 1 : 0);
  @override
  bool get accSymbolReplacement => _getBoolProp("AccSymbolReplacement");
  @override
  set accSymbolReplacement(bool v) =>
      _setIntProp("AccSymbolReplacement", v ? 1 : 0);
  @override
  int get progressPercent => _getIntProp("ProgressPercent");
  @override
  String get progressText => _getStrProp("ProgressText");
  @override
  bool get isListBoxActive => _getBoolProp("IsListBoxActive");
  @override
  int get listBoxCurrEntry => _getIntProp("ListBoxCurrEntry");
  @override
  int get listBoxCurrEntryHeight => _getIntProp("ListBoxCurrEntryHeight");
  @override
  int get listBoxCurrEntryLeft => _getIntProp("ListBoxCurrEntryLeft");
  @override
  int get listBoxCurrEntryTop => _getIntProp("ListBoxCurrEntryTop");
  @override
  int get listBoxCurrEntryWidth => _getIntProp("ListBoxCurrEntryWidth");
  @override
  int get listBoxHeight => _getIntProp("ListBoxHeight");
  @override
  int get listBoxLeft => _getIntProp("ListBoxLeft");
  @override
  int get listBoxTop => _getIntProp("ListBoxTop");
  @override
  int get listBoxWidth => _getIntProp("ListBoxWidth");
  @override
  String get passportPreSystemId => _getStrProp("PassportPreSystemId");
  @override
  set passportPreSystemId(String v) => _setStrProp("PassportPreSystemId", v);
  @override
  String get passportSystemId => _getStrProp("PassportSystemId");
  @override
  set passportSystemId(String v) => _setStrProp("PassportSystemId", v);
  @override
  String get passportTransactionId => _getStrProp("PassportTransactionId");
  @override
  set passportTransactionId(String v) =>
      _setStrProp("PassportTransactionId", v);
  @override
  bool get record => _getBoolProp("Record");
  @override
  set record(bool v) => _setIntProp("Record", v ? 1 : 0);
  @override
  bool get saveAsUnicode => _getBoolProp("SaveAsUnicode");
  @override
  set saveAsUnicode(bool v) => _setIntProp("SaveAsUnicode", v ? 1 : 0);
  @override
  bool get showDropdownKeys => _getBoolProp("ShowDropdownKeys");
  @override
  set showDropdownKeys(bool v) => _setIntProp("ShowDropdownKeys", v ? 1 : 0);
  @override
  bool get suppressBackendPopups => _getBoolProp("SuppressBackendPopups");
  @override
  set suppressBackendPopups(bool v) =>
      _setIntProp("SuppressBackendPopups", v ? 1 : 0);
  @override
  void sendCommand(String command) => _invokeVoidStr('SendCommand', command);
  @override
  void sendCommandAsync(String command) =>
      _invokeVoidStr('SendCommandAsync', command);
  @override
  void clearErrorList() => _invokeVoid('ClearErrorList');
  @override
  void enableJawsEvents() => _invokeVoid('EnableJawsEvents');
  @override
  void lockSessionUI() => _invokeVoid('LockSessionUI');
  @override
  void unlockSessionUI() => _invokeVoid('UnlockSessionUI');
  @override
  String asStdNumberFormat(String number) =>
      _invokeStrStr('AsStdNumberFormat', number);
  @override
  String getIconResourceName(String iconText) =>
      _invokeStrStr('GetIconResourceName', iconText);
  @override
  String getVKeyDescription(int vkey) =>
      _invokeStrInt('GetVKeyDescription', vkey);
  @override
  List<String>? findByPosition(int x, int y, {bool raise = true}) =>
      _extractStringList(
        _invokeObjIntInt('FindByPosition', x, y),
        'FindByPosition',
      );
  @override
  bool get opened => _getBoolProp("Opened");
  @override
  bool get isPopupDialog => _getIntProp("IsPopupDialog") != 0;
  @override
  set isPopupDialog(bool value) => _setIntProp("IsPopupDialog", value ? 1 : 0);
  @override
  String get popupDialog => _getStrProp("PopupDialog");
  @override
  set popupDialog(String value) => _setStrProp("PopupDialog", value);
  @override
  String get helpButtonHelpText => _getStrProp("HelpButtonHelpText");
  @override
  String get helpButtonText => _getStrProp("HelpButtonText");
  @override
  String get messageText => _getStrProp("MessageText");
  @override
  int get messageType => _getIntProp("MessageType");
  @override
  String get okButtonText => _getStrProp("OKButtonText");
  @override
  bool get visible => _getBoolProp("Visible");
  @override
  set screenLeft(int value) => _setIntProp("ScreenLeft", value);
  @override
  set screenTop(int value) => _setIntProp("ScreenTop", value);
  @override
  ISapObject? findByLabel(String text, String type) =>
      _invokeObjStrStr("FindByLabel", text, type);
  @override
  void listNavigate(String navType) => _invokeVoidStr("ListNavigate", navType);
  @override
  bool get isOTFPreview => _getBoolProp("IsOTFPreview");
  @override
  bool get selectable => _getBoolProp("Selectable");
  @override
  void scrollToLeft() => _invokeVoid('ScrollToLeft');
  @override
  ISapObject? get leftTab => _getObjProp("LeftTab");
  @override
  ISapObject? get selectedTab => _getObjProp("SelectedTab");
  @override
  void createSupportMessageClick() => _invokeVoid('CreateSupportMessageClick');
  @override
  void doubleClickNoArgs() => _invokeVoid('DoubleClick');
  @override
  void serviceRequestClick() => _invokeVoid('ServiceRequestClick');
  @override
  bool get messageAsPopup => _getIntProp("MessageAsPopup") != 0;
  @override
  int get messageHasLongText => _getIntProp("MessageHasLongText");
  @override
  String get messageId => _getStrProp("MessageId");
  @override
  String get messageNumber => _getStrProp("MessageNumber");
  @override
  String get messageParameter => _getStrProp("MessageParameter");
  @override
  String get messageTypeRetunString => _getStrProp("MessageType");
  void _invokeVoidIntIntIntStrStr(
    String m,
    int a1,
    int a2,
    int a3,
    String a4,
    String a5,
  ) {
    final ptrM = m.toNativeUtf16();
    final ptrA4 = a4.toNativeUtf16();
    final ptrA5 = a5.toNativeUtf16();
    _api.invokeVoidIntIntIntStrStr(handle, ptrM, a1, a2, a3, ptrA4, ptrA5);
    malloc.free(ptrM);
    malloc.free(ptrA4);
    malloc.free(ptrA5);
  }

  @override
  void contextMenuCalendar(
    int ctxMenuId,
    int ctxMenuCellRow,
    int ctxMenuCellCol,
    String dateBegin,
    String dateEnd,
  ) => _invokeVoidIntIntIntStrStr(
    "ContextMenu",
    ctxMenuId,
    ctxMenuCellRow,
    ctxMenuCellCol,
    dateBegin,
    dateEnd,
  );

  @override
  void setKeySpace() => _invokeVoid('SetKeySpace');

  @override
  ISapObject? get curListBoxEntry => _getObjProp("CurListBoxEntry");

  @override
  String get key => _getStrProp("Key");
  @override
  int get pos => _getIntProp("Pos");
  @override
  String get value => _getStrProp("Value");

  @override
  ISapObject? get listBoxEntries => _getObjProp("ListBoxEntries");

  @override
  set key(String value) => _setStrProp("Key", value);

  @override
  bool get showKey => _getBoolProp("ShowKey");

  @override
  set value(String newValue) => _setStrProp("Value", newValue);

  @override
  void fireSelected() => _invokeVoid('FireSelected');

  @override
  ISapObject? get entries => _getObjProp("Entries");

  @override
  String get labelText => _getStrProp("LabelText");

  @override
  String get selectedInComboBox => _getStrProp("Selected");

  @override
  set selectedInComboBox(String value) => _setStrProp("Selected", value);

  @override
  void valueChange(
    int series,
    int point,
    String xValue,
    String yValue,
    bool dataChange,
    String id,
    String zValue,
    int changeFlag,
  ) => invokeValueChange(
    series,
    point,
    xValue,
    yValue,
    dataChange,
    id,
    zValue,
    changeFlag,
  );

  @override
  void changeSelection(int indexPosition) =>
      _invokeVoidInt('ChangeSelection', indexPosition);
  @override
  bool get dockerIsVertical => _getIntProp("DockerIsVertical") != 0;
  @override
  int get dockerPixelSize => _getIntProp("DockerPixelSize");

  @override
  void annotationTextRequest(String strText) =>
      _invokeVoidStr('AnnotationTextRequest', strText);

  @override
  bool get annotationEnabled => _getIntProp("AnnotationEnabled") != 0;
  @override
  set annotationEnabled(bool value) =>
      _setIntProp("AnnotationEnabled", value ? 1 : 0);
  @override
  int get annotationMode => _getIntProp("AnnotationMode");
  @override
  set annotationMode(int value) => _setIntProp("AnnotationMode", value);
  @override
  String get redliningStream => _getStrProp("RedliningStream");
  @override
  set redliningStream(String value) => _setStrProp("RedliningStream", value);

  @override
  int getBrowerControlType() => _invokeIntNoArgs("GetBrowserControlType");

  @override
  void sapEvent(String frameName, String postData, String url) =>
      _invokeVoidStrStrStr('SapEvent', frameName, postData, url);

  @override
  Pointer<COMObject>? get browserHandle {
    final ptrM = "GetBrowserHandle".toNativeUtf16();
    final res = _api.invokeObjNoArgs(handle, ptrM);
    malloc.free(ptrM);
    return res == 0 ? null : Pointer<COMObject>.fromAddress(res);
  }

  @override
  int get documentComplete => _getIntProp("DocumentComplete");

  @override
  void submit() => _invokeVoid('Submit');

  @override
  String get buttonTooltip => _getStrProp("ButtonTooltip");
  @override
  bool get findButtonActivated => _getBoolProp("FindButtonActivated");
  @override
  String get historyCurEntryFromInputFieldControl =>
      _getStrProp("HistoryCurEntry");
  @override
  int get historyCurIndexFromInputFieldControl =>
      _getIntProp("HistoryCurIndex");
  @override
  bool get historyIsActiveFromInputFieldControl =>
      _getIntProp("HistoryIsActive") != 0;
  @override
  String get promptText => _getStrProp("PromptText");
  @override
  String getLinkContent(int linkId, int textId) =>
      _invokeStrIntInt('GetLinkContent', linkId, textId);
  @override
  String getNodeContent(int nodeId, int textId) =>
      _invokeStrIntInt('GetNodeContent', nodeId, textId);
  @override
  int get linkCountProperty => _getIntProp("LinkCount");
  @override
  int get nodeCount => _getIntProp("NodeCount");
  @override
  void appendRow(String name, String row) =>
      _invokeVoidStrStr('AppendRow', name, row);
  @override
  void closeDocument(int cookie, bool everChanged, bool changedAfterSave) =>
      _invokeVoidIntIntInt(
        'CloseDocument',
        cookie,
        everChanged ? 1 : 0,
        changedAfterSave ? 1 : 0,
      );

  @override
  void customEvent(
    int cookie,
    String eventName,
    int paramCount, [
    String? p1,
    String? p2,
    String? p3,
    String? p4,
    String? p5,
    String? p6,
    String? p7,
    String? p8,
    String? p9,
    String? p10,
    String? p11,
    String? p12,
  ]) {
    final ptrEventName = eventName.toNativeUtf16();
    final ptrP1 = p1 != null ? p1.toNativeUtf16() : nullptr;
    final ptrP2 = p2 != null ? p2.toNativeUtf16() : nullptr;
    final ptrP3 = p3 != null ? p3.toNativeUtf16() : nullptr;
    final ptrP4 = p4 != null ? p4.toNativeUtf16() : nullptr;
    final ptrP5 = p5 != null ? p5.toNativeUtf16() : nullptr;
    final ptrP6 = p6 != null ? p6.toNativeUtf16() : nullptr;
    final ptrP7 = p7 != null ? p7.toNativeUtf16() : nullptr;
    final ptrP8 = p8 != null ? p8.toNativeUtf16() : nullptr;
    final ptrP9 = p9 != null ? p9.toNativeUtf16() : nullptr;
    final ptrP10 = p10 != null ? p10.toNativeUtf16() : nullptr;
    final ptrP11 = p11 != null ? p11.toNativeUtf16() : nullptr;
    final ptrP12 = p12 != null ? p12.toNativeUtf16() : nullptr;

    _api.invokeMethodVoidCustomEvent(
      handle,
      cookie,
      ptrEventName,
      paramCount,
      ptrP1,
      ptrP2,
      ptrP3,
      ptrP4,
      ptrP5,
      ptrP6,
      ptrP7,
      ptrP8,
      ptrP9,
      ptrP10,
      ptrP11,
      ptrP12,
    );

    malloc.free(ptrEventName);

    if (ptrP1 != nullptr) malloc.free(ptrP1);
    if (ptrP2 != nullptr) malloc.free(ptrP2);
    if (ptrP3 != nullptr) malloc.free(ptrP3);
    if (ptrP4 != nullptr) malloc.free(ptrP4);
    if (ptrP5 != nullptr) malloc.free(ptrP5);
    if (ptrP6 != nullptr) malloc.free(ptrP6);
    if (ptrP7 != nullptr) malloc.free(ptrP7);
    if (ptrP8 != nullptr) malloc.free(ptrP8);
    if (ptrP9 != nullptr) malloc.free(ptrP9);
    if (ptrP10 != nullptr) malloc.free(ptrP10);
    if (ptrP11 != nullptr) malloc.free(ptrP11);
    if (ptrP12 != nullptr) malloc.free(ptrP12);
  }

  @override
  void removeContent(String name) => _invokeVoidStr('RemoveContent', name);
  @override
  void saveDocument(int cookie, bool changed) =>
      _invokeVoidIntInt('SaveDocument', cookie, changed ? 1 : 0);
  @override
  void setDocument(int index, String document) =>
      _invokeVoidIntStr('SetDocument', index, document);
  @override
  Pointer<COMObject>? get document {
    final ptrM = "Document".toNativeUtf16();
    final res = _api.invokeObjNoArgs(handle, ptrM);
    malloc.free(ptrM);
    return res == 0 ? null : Pointer<COMObject>.fromAddress(res);
  }

  @override
  int get hostedApplication => _getIntProp("HostedApplication");
  @override
  void clickInPicture() => _invokeVoid('Click');
  @override
  void clickControlArea(int x, int y) =>
      _invokeVoidIntInt('ClickControlArea', x, y);
  @override
  void clickPictureArea(int x, int y) =>
      _invokeVoidIntInt('ClickPictureArea', x, y);
  @override
  void contextMenuInPicture(int x, int y) =>
      _invokeVoidIntInt('ContextMenu', x, y);
  @override
  void doubleClickInPicture() => _invokeVoid('DoubleClick');
  @override
  void doubleClickControlArea(int x, int y) =>
      _invokeVoidIntInt('DoubleClickControlArea', x, y);
  @override
  void doubleClickPictureArea(int x, int y) =>
      _invokeVoidIntInt('DoubleClickPictureArea', x, y);
  @override
  String get altText => _getStrProp("AltText");
  @override
  String get displayMode => _getStrProp("DisplayMode");
  @override
  String get icon => _getStrProp("Icon");
  @override
  String get url => _getStrProp("Url");
  @override
  bool get isStepLoop => _getIntProp("IsStepLoop") != 0;
  @override
  bool get isStepLoopInTableStructure =>
      _getIntProp("IsStepLoopInTableStructure") != 0;
  @override
  int get loopColCount => _getIntProp("LoopColCount");
  @override
  int get loopCurrentCol => _getIntProp("LoopCurrentCol");
  @override
  int get loopCurrentColCount => _getIntProp("LoopCurrentColCount");
  @override
  int get loopCurrentRow => _getIntProp("LoopCurrentRow");
  @override
  int get loopRowCount => _getIntProp("LoopRowCount");
  @override
  int getColSize(int id) => _invokeIntInt('GetColSize', id);
  @override
  int getRowSize(int id) => _invokeIntInt('GetRowSize', id);
  @override
  void setColSize(int id, int size) =>
      _invokeVoidIntInt('SetColSize', id, size);
  @override
  void setRowSize(int id, int size) =>
      _invokeVoidIntInt('SetRowSize', id, size);
  @override
  int get isVerticalInt => _getIntProp("IsVertical");
  @override
  int get sashPosition => _getIntProp("SashPosition");
  @override
  set sashPosition(int value) => _setIntProp("SashPosition", value);
  @override
  void contextMenuInStage(String strId) => _invokeVoidStr('ContextMenu', strId);
  @override
  void doubleClickInStage(String strId) => _invokeVoidStr('DoubleClick', strId);
  @override
  void selectItemsInStage(String strItems) =>
      _invokeVoidStr('SelectItems', strItems);
  @override
  String getLineText(int nLine) => _invokeStrInt('GetLineText', nLine);
  @override
  String getUnprotectedTextPart(int part) =>
      _invokeStrInt('GetUnprotectedTextPart', part);
  @override
  bool isBreakpointLine(int nLine) =>
      _invokeIntInt('IsBreakpointLine', nLine) != 0;
  @override
  bool isCommentLine(int nLine) => _invokeIntInt('IsCommentLine', nLine) != 0;
  @override
  bool isHighlightedLine(int nLine) =>
      _invokeIntInt('IsHighlightedLine', nLine) != 0;
  @override
  bool isProtectedLine(int nLine) =>
      _invokeIntInt('IsProtectedLine', nLine) != 0;
  @override
  bool isSelectedLine(int nLine) => _invokeIntInt('IsSelectedLine', nLine) != 0;
  @override
  void modifiedStatusChanged(bool status) =>
      _invokeVoidInt('ModifiedStatusChanged', status ? 1 : 0);
  @override
  void multipleFilesDropped() => _invokeVoid('MultipleFilesDropped');
  @override
  void setSelectionIndexes(int start, int end) =>
      _invokeVoidIntInt('SetSelectionIndexes', start, end);
  @override
  bool setUnprotectedTextPart(int part, String text) =>
      _invokeIntIntStr('SetUnprotectedTextPart', part, text) != 0;
  @override
  void singleFileDropped(String filename) =>
      _invokeVoidStr('SingleFileDropped', filename);

  @override
  int get currentColumn => _getIntProp("CurrentColumn");
  @override
  int get currentLine => _getIntProp("CurrentLine");
  @override
  int get firstVisibleLine => _getIntProp("FirstVisibleLine");
  @override
  set firstVisibleLine(int value) => _setIntProp("FirstVisibleLine", value);
  @override
  int get lastVisibleLine => _getIntProp("LastVisibleLine");
  @override
  int get lineCount => _getIntProp("LineCount");
  @override
  int get numberOfUnprotectedTextParts =>
      _getIntProp("NumberOfUnprotectedTextParts");
  @override
  String get selectedText => _getStrProp("SelectedText");
  @override
  int get selectionEndColumn => _getIntProp("SelectionEndColumn");
  @override
  int get selectionEndLine => _getIntProp("SelectionEndLine");
  @override
  int get selectionIndexEnd => _getIntProp("SelectionIndexEnd");
  @override
  int get selectionIndexStart => _getIntProp("SelectionIndexStart");
  @override
  int get selectionStartColumn => _getIntProp("SelectionStartColumn");
  @override
  int get selectionStartLine => _getIntProp("SelectionStartLine");
  @override
  void closeFile(int file) => _invokeVoidInt('CloseFile', file);
  @override
  int openFile(String filename) => _invokeIntStr('OpenFile', filename);
  @override
  void write(int file, String text) => _invokeVoidIntStr('Write', file, text);
  @override
  void writeLine(int file, String text) =>
      _invokeVoidIntStr('WriteLine', file, text);
  @override
  int get messageOptionOk => _getIntProp("MESSAGE_OPTION_OK");
  @override
  int get messageOptionOkCancel => _getIntProp("MESSAGE_OPTION_OKCANCEL");
}
