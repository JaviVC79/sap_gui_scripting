import 'package:sap_gui_scripting/gui_classes/gui_shell.dart';

class GuiCalendar extends GuiShell {
  GuiCalendar(super.obj);

  void contextMenu(
    int ctxMenuId,
    int ctxMenuCellRow,
    int ctxMenuCellCol,
    String dateBegin,
    String dateEnd,
  ) => obj.contextMenuCalendar(
    ctxMenuId,
    ctxMenuCellRow,
    ctxMenuCellCol,
    dateBegin,
    dateEnd,
  );
}
