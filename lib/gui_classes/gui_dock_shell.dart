import 'package:sap_gui_scripting/gui_classes/gui_v_container.dart';

class GuiDockShell extends GuiVContainer {
  GuiDockShell(super.obj);

  String get accDescription => obj.accDescription;
  bool get dockerIsVertical => obj.dockerIsVertical;
  int get dockerPixelSize => obj.dockerPixelSize;
}