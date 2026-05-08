import 'package:sap_gui_scripting/gui_classes/gui_shell.dart';

class GuiColorSelector extends GuiShell {
  GuiColorSelector(super.obj);

  void changeSelection(int indexPosition) => obj.changeSelection(indexPosition);
}
