import 'package:sap_gui_scripting/gui_classes/gui_shell.dart';

class GuiSplit extends GuiShell {
  GuiSplit(super.obj);

  int getColSize(int id) => obj.getColSize(id);
  int getRowSize(int id) => obj.getRowSize(id);
  void setColSize(int id, int size) => obj.setColSize(id, size);
  void setRowSize(int id, int size) => obj.setRowSize(id, size);

  int get focusedHorizontalSash => obj.focusedHorizontalSash;
  int get focusedVerticalSash => obj.focusedVerticalSash;
  int get isVertical => obj.isVerticalInt;
}
