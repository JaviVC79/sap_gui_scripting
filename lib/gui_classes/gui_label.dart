import 'package:sap_gui_scripting/gui_classes/gui_v_component.dart';

class GuiLabel extends GuiVComponent {
  GuiLabel(super.obj);

  String getListProperty(String property) => obj.getListProperty(property);

  String getListPropertyNonRec(String property) =>
      obj.getListPropertyNonRec(property);

  int get caretPosition => obj.caretPosition;
  set caretPosition(int value) => obj.caretPosition = value;
  String get displayedText => obj.displayedText;
  int get maxLength => obj.maxLength;
  bool get numerical => obj.numerical;
  String get rowText => obj.rowText;
  int get charHeight => obj.charHeight;
  int get charLeft => obj.charLeft;
  int get charTop => obj.charTop;
  int get charWidth => obj.charWidth;
  int get colorIndex => obj.colorIndex;
  bool get colorIntensified => obj.colorIntensified;
  bool get colorInverse => obj.colorInverse;
  bool get highlighted => obj.highlighted;
  bool get isHotspot => obj.isHotspot;
  bool get isLeftLabel => obj.isLeftLabel;
  bool get isRightLabel => obj.isRightLabel;
  bool get isListElement => obj.isListElement;
}
