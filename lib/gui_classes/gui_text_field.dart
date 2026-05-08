import 'package:sap_gui_scripting/gui_classes/gui_label.dart';
import 'package:sap_gui_scripting/gui_classes/gui_v_component.dart';

class GuiTextField extends GuiVComponent {
  GuiTextField(super.obj);

  String getListProperty(String property) => obj.getListProperty(property);

  String getListPropertyNonRec(String property) =>
      obj.getListPropertyNonRec(property);

  int get caretPosition => obj.caretPosition;
  set caretPosition(int value) => obj.caretPosition = value;

  String get displayedText => obj.displayedText;

  bool get highlighted => obj.highlighted;

  String get historyCurEntry => obj.historyCurEntryProp;

  int get historyCurIndex => obj.historyCurIndexProp;

  bool get historyIsActive => obj.historyIsActiveProp;

  List<String>? get historyList => obj.historyListProp;

  bool get isHotspot => obj.isHotspot;

  bool get isLeftLabel => obj.isLeftLabel;

  bool get isListElement => obj.isListElement;

  bool get isOField => obj.isOField;

  bool get isRightLabel => obj.isRightLabel;

  GuiLabel? get leftLabel {
    final labelObj = obj.leftLabel;
    return labelObj != null ? GuiLabel(labelObj) : null;
  }

  GuiLabel? get rightLabel {
    final labelObj = obj.rightLabel;
    return labelObj != null ? GuiLabel(labelObj) : null;
  }

  int get maxLength => obj.maxLength;

  bool get numerical => obj.numerical;

  bool get required => obj.required;
}
