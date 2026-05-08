import 'package:sap_gui_scripting/gui_classes/gui_v_component.dart';

class GuiButton extends GuiVComponent {
  GuiButton(super.obj);

  void press() {
    obj.press();
  }

  bool get emphasized => obj.emphasized;

  GuiVComponent? get leftLabel {
    final res = obj.leftLabel;
    return res != null ? GuiVComponent(res) : null;
  }

  GuiVComponent? get rightLabel {
    final res = obj.rightLabel;
    return res != null ? GuiVComponent(res) : null;
  }
}
