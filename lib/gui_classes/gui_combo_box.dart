import 'package:sap_gui_scripting/gui_classes/gui_combo_box_entry.dart';
import 'package:sap_gui_scripting/gui_classes/gui_label.dart';
import 'package:sap_gui_scripting/gui_classes/gui_v_component.dart';

class GuiComboBox extends GuiVComponent {
  GuiComboBox(super.obj);

  void setKeySpace() => obj.setKeySpace();

  int get charHeight => obj.charHeight;
  int get charLeft => obj.charLeft;
  int get charTop => obj.charTop;
  int get charWidth => obj.charWidth;

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

  bool get flushing => obj.flushing;

  bool get highlighted => obj.highlighted;

  bool get isLeftLabel => obj.isLeftLabel;

  bool get isListBoxActive => obj.isListBoxActive;

  bool get isRightLabel => obj.isRightLabel;

  String get key => obj.key;
  set key(String value) => obj.key = value;

  GuiLabel? get leftLabel {
    final labelObj = obj.leftLabel;
    return labelObj != null ? GuiLabel(labelObj) : null;
  }

  bool get required => obj.required;

  GuiLabel? get rightLabel {
    final labelObj = obj.rightLabel;
    return labelObj != null ? GuiLabel(labelObj) : null;
  }

  bool get showKey => obj.showKey;

  String get value => obj.value;
  set value(String newValue) => obj.value = newValue;
}
