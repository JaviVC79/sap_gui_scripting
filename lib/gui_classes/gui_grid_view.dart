import 'package:sap_gui_scripting/gui_classes/gui_collection.dart';
import 'package:sap_gui_scripting/gui_classes/gui_shell.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class GuiGridView extends GuiShell {
  GuiGridView(super.obj);

  String getCellValue(int row, String column) => obj.getCellValue(row, column);
  String getCellTooltip(int row, String column) =>
      obj.getCellTooltip(row, column);
  String getCellType(int row, String column) => obj.getCellType(row, column);

  bool getCellCheckBoxChecked(int row, String column) =>
      obj.getCellCheckBoxChecked(row, column);
  bool getCellChangeable(int row, String column) =>
      obj.getCellChangeable(row, column);

  void pressButton(int row, String column) =>
      obj.pressButtonInGrid(row, column);

  void doubleClick(int row, String column) => obj.doubleClick(row, column);
  void click(int row, String column) => obj.click(row, column);

  void modifyCell(int row, String column, String value) =>
      obj.modifyCell(row, column, value);
  void modifyCheckBox(int row, String column, bool checked) =>
      obj.modifyCheckBox(row, column, checked);

  void pressToolbarButton(String id) => obj.pressToolbarButton(id);
  void selectToolbarMenuItem(String id) => obj.selectToolbarMenuItem(id);
  void pressEnter() => obj.pressEnter();

  int get rowCount => obj.rowCount;
  int get columnCount => obj.columnCount;
  String get title => obj.title;

  int get currentCellRow => obj.currentCellRow;
  set currentCellRow(int value) => obj.currentCellRow = value;

  String get currentCellColumn => obj.currentCellColumn;
  set currentCellColumn(String value) => obj.currentCellColumn = value;

  void clearSelection() => obj.clearSelection();
  void clickCurrentCell() => obj.clickCurrentCell();
  void currentCellMoved() => obj.currentCellMoved();
  void doubleClickCurrentCell() => obj.doubleClickCurrentCell();
  void deselectColumn(String column) => obj.deselectColumn(column);
  void selectAll() => obj.selectAll();
  void selectColumn(String column) => obj.selectColumn(column);
  void selectionChanged() => obj.selectionChanged();
  void setCurrentCell(int row, String column) =>
      obj.setCurrentCell(row, column);

  /// rows format: "3,5-8,14,15"
  void deleteRows(String rows) => obj.deleteRows(rows);
  void duplicateRows(String rows) => obj.duplicateRows(rows);
  void insertRows(String rows) => obj.insertRows(rows);
  void moveRows(int fromRow, int toRow, int destRow) =>
      obj.moveRows(fromRow, toRow, destRow);

  void pressTotalRow(int row, String column) => obj.pressTotalRow(row, column);
  void pressTotalRowCurrentCell() => obj.pressTotalRowCurrentCell();

  void contextMenu() => obj.contextMenu();
  void pressF1() => obj.pressF1();
  void pressF4() => obj.pressF4();
  void pressButtonCurrentCell() => obj.pressButtonCurrentCell();
  void pressColumnHeader(String column) => obj.pressColumnHeader(column);
  void pressToolbarContextButton(String id) =>
      obj.pressToolbarContextButton(id);
  void triggerModified() => obj.triggerModified();

  int getCellColor(int row, String column) => obj.getCellColor(row, column);
  int getCellHeight(int row, String column) => obj.getCellHeight(row, column);
  String getCellHotspotType(int row, String column) =>
      obj.getCellHotspotType(row, column);
  String getCellIcon(int row, String column) => obj.getCellIcon(row, column);
  int getCellLeft(int row, String column) => obj.getCellLeft(row, column);
  int getCellListBoxCount(int row, String column) =>
      obj.getCellListBoxCount(row, column);
  String getCellListBoxCurIndex(int row, String column) =>
      obj.getCellListBoxCurIndex(row, column);
  int getCellMaxLength(int row, String column) =>
      obj.getCellMaxLength(row, column);
  String getCellState(int row, String column) => obj.getCellState(row, column);
  int getCellTop(int row, String column) => obj.getCellTop(row, column);
  int getCellWidth(int row, String column) => obj.getCellWidth(row, column);

  bool hasCellF4Help(int row, String column) => obj.hasCellF4Help(row, column);
  bool isCellHotspot(int row, String column) => obj.isCellHotspot(row, column);
  bool isCellSymbol(int row, String column) => obj.isCellSymbol(row, column);
  bool isCellTotalExpander(int row, String column) =>
      obj.isCellTotalExpander(row, column);

  String getColumnDataType(String column) => obj.getColumnDataType(column);
  String getColumnOperationType(String column) =>
      obj.getColumnOperationType(column);
  int getColumnPosition(String column) => obj.getColumnPosition(column);
  String getColumnSortType(String column) => obj.getColumnSortType(column);
  String getColumnTooltip(String column) => obj.getColumnTooltip(column);
  String getColumnTotalType(String column) => obj.getColumnTotalType(column);
  String getDisplayedColumnTitle(String column) =>
      obj.getDisplayedColumnTitle(column);
  bool isColumnFiltered(String column) => obj.isColumnFiltered(column);
  bool isColumnKey(String column) => obj.isColumnKey(column);
  void setColumnWidth(String column, int width) =>
      obj.setColumnWidth(column, width);

  String getColorInfo(int color) => obj.getColorInfo(color);
  int getRowTotalLevel(int row) => obj.getRowTotalLevel(row);
  String getSymbolInfo(String symbol) => obj.getSymbolInfo(symbol);

  bool getToolbarButtonChecked(int buttonPos) =>
      obj.getToolbarButtonChecked(buttonPos);
  bool getToolbarButtonEnabled(int buttonPos) =>
      obj.getToolbarButtonEnabled(buttonPos);
  String getToolbarButtonIcon(int buttonPos) =>
      obj.getToolbarButtonIcon(buttonPos);
  String getToolbarButtonId(int buttonPos) => obj.getToolbarButtonId(buttonPos);
  String getToolbarButtonText(int buttonPos) =>
      obj.getToolbarButtonText(buttonPos);
  String getToolbarButtonTooltip(int buttonPos) =>
      obj.getToolbarButtonTooltip(buttonPos);
  String getToolbarButtonType(int buttonPos) =>
      obj.getToolbarButtonType(buttonPos);
  int getToolbarFocusButton() => obj.getToolbarFocusButton();
  bool isTotalRowExpanded(int row) => obj.isTotalRowExpanded(row);

  String historyCurEntry(int row, String column) =>
      obj.historyCurEntry(row, column);
  int historyCurIndex(int row, String column) =>
      obj.historyCurIndex(row, column);
  bool historyIsActive(int row, String column) =>
      obj.historyIsActive(row, column);

  List<String>? getColumnTitles(String column) => obj.getColumnTitles(column);

  ISapObject? historyList(int row, String column) =>
      obj.historyList(row, column);

  List<String>? get columnOrder => obj.columnOrder;

  set columnOrder(GuiCollection order) => obj.columnOrder = order.handle;

  String get firstVisibleColumn => obj.firstVisibleColumn;
  set firstVisibleColumn(String value) => obj.firstVisibleColumn = value;

  int get firstVisibleRow => obj.firstVisibleRow;
  set firstVisibleRow(int value) => obj.firstVisibleRow = value;

  int get frozenColumnCount => obj.frozenColumnCount;

  List<String>? get selectedCells => obj.selectedCells;
  set selectedCells(List<String> cells) => obj.selectedCells = cells;

  List<String>? get selectedColumns => obj.selectedColumns;
  set selectedColumns(List<String> columns) => obj.selectedColumns = columns;

  String get selectedRows => obj.selectedRows;
  set selectedRows(String value) => obj.selectedRows = value;

  String get selectionMode => obj.selectionMode;
  int get toolbarButtonCount => obj.toolbarButtonCount;
  int get visibleRowCount => obj.visibleRowCount;
}
