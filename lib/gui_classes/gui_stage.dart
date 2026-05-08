import 'package:sap_gui_scripting/gui_classes/gui_shell.dart';

class GuiStage extends GuiShell {
  GuiStage(super.obj);

  void contextMenu(String strId) => obj.contextMenuInStage(strId);
  void doubleClick(String strId) => obj.doubleClickInStage(strId);
  void selectItems(String strItems) => obj.selectItemsInStage(strItems);
}
