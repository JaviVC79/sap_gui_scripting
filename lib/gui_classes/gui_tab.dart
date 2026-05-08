import 'package:sap_gui_scripting/gui_classes/gui_v_container.dart';

class GuiTab extends GuiVContainer {
  GuiTab(super.obj);

  void scrollToLeft() => obj.scrollToLeft();

  void select() => obj.select();
}
