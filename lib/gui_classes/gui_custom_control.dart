import 'package:sap_gui_scripting/gui_classes/gui_v_container.dart';

class GuiCustomControl extends GuiVContainer {
  GuiCustomControl(super.obj);

  int get charHeight => obj.charHeight;
  int get charLeft => obj.charLeft;
  int get charTop => obj.charTop;
  int get charWidth => obj.charWidth;
}
