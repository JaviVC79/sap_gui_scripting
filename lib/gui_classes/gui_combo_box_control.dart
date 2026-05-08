import 'package:sap_gui_scripting/gui_classes/gui_combo_box_entry.dart';
import 'package:sap_gui_scripting/gui_classes/gui_shell.dart';

class GuiComboBoxControl extends GuiShell {
  GuiComboBoxControl(super.obj);

  void fireSelected() => obj.fireSelected();

  GuiComboBoxEntry? get curListBoxEntry => obj.curListBoxEntry != null
      ? GuiComboBoxEntry(obj.curListBoxEntry!)
      : null;

  List<GuiComboBoxEntry> get entries {
    final entriesObj = obj.entries;
    if (entriesObj == null) return [];
    final count = entriesObj.count;
    List<GuiComboBoxEntry> entries = [];
    for (int i = 0; i < count; i++) {
      final entryObj = entriesObj.elementAt(i);
      if (entryObj != null) {
        entries.add(GuiComboBoxEntry(entryObj));
      }
    }
    return entries;
  }

  bool get isListBoxActive => obj.isListBoxActive;

  String get labelText => obj.labelText;

  String get selected => obj.selectedInComboBox;
  set selected(String value) => obj.selectedInComboBox = value;
}
