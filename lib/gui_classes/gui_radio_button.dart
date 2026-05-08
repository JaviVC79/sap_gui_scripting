import 'package:sap_gui_scripting/gui_classes/gui_v_component.dart';
import 'package:sap_gui_scripting/gui_classes/gui_component_collection.dart';

class GuiRadioButton extends GuiVComponent {
  GuiRadioButton(super.obj);

  void select() => obj.select();

  bool get selected => obj.selected;

  int get charHeight => obj.charHeight;

  int get charLeft => obj.charLeft;

  int get charTop => obj.charTop;

  int get charWidth => obj.charWidth;

  bool get flushing => obj.flushing;

  int get groupCount => obj.groupCount;

  int get groupPos => obj.groupPos;

  bool get isLeftLabel => obj.isLeftLabel;

  bool get isRightLabel => obj.isRightLabel;

  GuiVComponent? get leftLabel {
    final labelObj = obj.leftLabel;
    return labelObj != null ? GuiVComponent(labelObj) : null;
  }

  GuiVComponent? get rightLabel {
    final labelObj = obj.rightLabel;
    return labelObj != null ? GuiVComponent(labelObj) : null;
  }

  GuiComponentCollection<GuiRadioButton> get groupMembers {
    final collObj = obj.groupMembers;
    if (collObj == null) throw Exception("RadioButton not found");
    return GuiComponentCollection<GuiRadioButton>(collObj);
  }
}
