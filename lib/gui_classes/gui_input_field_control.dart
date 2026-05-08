import 'package:sap_gui_scripting/gui_classes/gui_shell.dart';

class GuiInputFieldControl extends GuiShell {
  GuiInputFieldControl(super.obj);

  void submit() => obj.submit();

  String get buttonTooltip => obj.buttonTooltip;
  bool get findButtonActivated => obj.findButtonActivated;
  String get historyCurEntry => obj.historyCurEntryFromInputFieldControl;
  int get historyCurIndex => obj.historyCurIndexFromInputFieldControl;
  bool get historyIsActive => obj.historyIsActiveFromInputFieldControl;
  List<String>? get historyList => obj.historyListProp;
  String get labelText => obj.labelText;
  String get promptText => obj.promptText;
}
