import 'package:sap_gui_scripting/gui_classes/gui_label.dart';
import 'package:sap_gui_scripting/gui_classes/gui_v_component.dart';

class GuiCheckBox extends GuiVComponent {
  GuiCheckBox(super.obj);

  String getListProperty(String property) => obj.getListProperty(property);

  String getListPropertyNonRec(String property) =>
      obj.getListPropertyNonRec(property);

  bool get selected => obj.selected;
  set selected(bool value) => obj.selected = value;

  int get colorIndex => obj.colorIndex;

  bool get colorIntensified => obj.colorIntensified;

  bool get colorInverse => obj.colorInverse;

  bool get flushing => obj.flushing;

  bool get isLeftLabel => obj.isLeftLabel;

  bool get isListElement => obj.isListElement;

  bool get isRightLabel => obj.isRightLabel;

  GuiLabel? get leftLabel {
    final labelObj = obj.leftLabel;
    return labelObj != null ? GuiLabel(labelObj) : null;
  }

  GuiLabel? get rightLabel {
    final labelObj = obj.rightLabel;
    return labelObj != null ? GuiLabel(labelObj) : null;
  }

  String get rowText => obj.rowText;
}
