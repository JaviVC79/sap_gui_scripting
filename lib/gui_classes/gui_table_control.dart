import 'package:sap_gui_scripting/gui_classes/gui_scroll_bar.dart';
import 'package:sap_gui_scripting/gui_classes/gui_table_column.dart';
import 'package:sap_gui_scripting/gui_classes/gui_table_row.dart';
import 'package:sap_gui_scripting/gui_classes/gui_v_component.dart';
import 'package:sap_gui_scripting/gui_classes/gui_v_container.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class GuiTableControl extends GuiVContainer {
  GuiTableControl(super.obj);

  void configureLayout() {
    obj.configureLayout();
  }

  void deselectAllColumns() {
    obj.deselectAllColumns();
  }

  GuiTableRow? getAbsoluteRow(int index) {
    final object = obj.getAbsoluteRow(index);
    return object != null ? GuiTableRow(object) : null;
  }

  GuiVComponent? getCell(int row, int column) {
    final object = obj.getCell(row, column);
    return object != null ? GuiVComponent(object) : null;
  }

  void reorderTable(String permutation) {
    obj.reorderTable(permutation);
  }

  void selectAllColumns() {
    obj.selectAllColumns();
  }

  int get charHeight => obj.charHeight;

  int get charLeft => obj.charLeft;

  int get charTop => obj.charTop;

  int get charWidth => obj.charWidth;

  int get colSelectMode => obj.colSelectMode;

  GuiTableColumn? get columns => obj.columns;

  int get currentCol => obj.currentCol;

  int get currentRow => obj.currentRow;

  ISapObject? get horizontalScrollbar => obj.horizontalScrollbar;

  int get rowCount => obj.rowCount;

  GuiTableRow? get rows {
    final rowsObj = obj.rows;
    return rowsObj != null ? GuiTableRow(rowsObj) : null;
  }

  int get rowSelectMode => obj.rowSelectMode;

  String get tableFieldName => obj.tableFieldName;

  GuiScrollbar? get verticalScrollbar {
    return obj.verticalScrollbar != null
        ? GuiScrollbar(obj.verticalScrollbar!)
        : null;
  }

  int get visibleRowCount => obj.visibleRowCount;
}
