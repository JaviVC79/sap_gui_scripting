import 'package:sap_gui_scripting/gui_classes/gui_v_container.dart';

class GuiBox extends GuiVContainer {
  GuiBox(super.obj);

  int get charHeight => obj.charHeight;
  int get charLeft => obj.charLeft;
  int get charTop => obj.charTop;
  int get charWidth => obj.charWidth;
}
