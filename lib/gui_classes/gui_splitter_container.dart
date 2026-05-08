import 'package:sap_gui_scripting/gui_classes/gui_shell.dart';

class GuiSplitterContainer extends GuiShell {
  GuiSplitterContainer(super.obj);

  bool get isVertical => obj.isVertical;
  int get sashPosition => obj.sashPosition;
  set sashPosition(int value) => obj.sashPosition = value;
}
