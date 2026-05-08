import 'package:sap_gui_scripting/gui_classes/gui_container.dart';
import 'package:sap_gui_scripting/gui_classes/gui_main_window.dart';
import 'package:sap_gui_scripting/gui_classes/gui_session_info.dart';

class GuiSession extends GuiContainer {
  GuiSession(super.obj);

  GuiSessionInfo get info {
    final infoObj = obj.info;
    if (infoObj == null) throw Exception("Session info not found");
    return GuiSessionInfo(infoObj);
  }

  GuiMainWindow? get activeWindow {
    final windowObj = obj.activeWindow;
    return windowObj != null ? GuiMainWindow(windowObj) : null;
  }

  bool get isActive => obj.isActive;
  bool get busy => obj.busy;

  bool get accEnhancedTabChain => obj.accEnhancedTabChain;
  set accEnhancedTabChain(bool v) => obj.accEnhancedTabChain = v;

  bool get accSymbolReplacement => obj.accSymbolReplacement;
  set accSymbolReplacement(bool v) => obj.accSymbolReplacement = v;

  dynamic get errorList => obj.errorList;

  int get progressPercent => obj.progressPercent;
  String get progressText => obj.progressText;

  bool get isListBoxActive => obj.isListBoxActive;
  int get listBoxCurrEntry => obj.listBoxCurrEntry;
  int get listBoxCurrEntryHeight => obj.listBoxCurrEntryHeight;
  int get listBoxCurrEntryLeft => obj.listBoxCurrEntryLeft;
  int get listBoxCurrEntryTop => obj.listBoxCurrEntryTop;
  int get listBoxCurrEntryWidth => obj.listBoxCurrEntryWidth;
  int get listBoxHeight => obj.listBoxHeight;
  int get listBoxLeft => obj.listBoxLeft;
  int get listBoxTop => obj.listBoxTop;
  int get listBoxWidth => obj.listBoxWidth;

  String get passportPreSystemId => obj.passportPreSystemId;
  set passportPreSystemId(String v) => obj.passportPreSystemId = v;

  String get passportSystemId => obj.passportSystemId;
  set passportSystemId(String v) => obj.passportSystemId = v;

  String get passportTransactionId => obj.passportTransactionId;
  set passportTransactionId(String v) => obj.passportTransactionId = v;

  bool get record => obj.record;
  set record(bool v) => obj.record = v;

  String get recordFile => obj.recordFile;
  set recordFile(String v) => obj.recordFile = v;

  bool get saveAsUnicode => obj.saveAsUnicode;
  set saveAsUnicode(bool v) => obj.saveAsUnicode = v;

  bool get showDropdownKeys => obj.showDropdownKeys;
  set showDropdownKeys(bool v) => obj.showDropdownKeys = v;

  bool get suppressBackendPopups => obj.suppressBackendPopups;
  set suppressBackendPopups(bool v) => obj.suppressBackendPopups = v;

  int get testToolMode => obj.testToolMode;
  set testToolMode(int v) => obj.testToolMode = v;

  void sendCommand(String command) => obj.sendCommand(command);

  void sendCommandAsync(String command) => obj.sendCommandAsync(command);

  void startTransaction(String tcode) => obj.startTransaction(tcode);

  void endTransaction() => obj.endTransaction();

  void createSession() => obj.createSession();

  void sendVKey(int vkey) => obj.sendVKey(vkey);

  void clearErrorList() => obj.clearErrorList();

  void enableJawsEvents() => obj.enableJawsEvents();

  void lockSessionUI() => obj.lockSessionUI();

  void unlockSessionUI() => obj.unlockSessionUI();

  String asStdNumberFormat(String number) => obj.asStdNumberFormat(number);

  List<String> findByPosition(int x, int y, {bool raise = true}) {
    final object = obj.findByPosition(x, y, raise: raise);
    if (object == null) return [];
    return object;
  }

  String getIconResourceName(String iconText) =>
      obj.getIconResourceName(iconText);

  String getVKeyDescription(int vkey) => obj.getVKeyDescription(vkey);

  String getObjectTree(String id, {List<String> properties = const []}) =>
      obj.getObjectTree(id, properties: properties);
}
