import 'package:mocktail/mocktail.dart';
import 'package:sap_gui_scripting/gui_classes/gui_collection.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_grid_view.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

class MockGuiCollection extends Mock implements GuiCollection {}

void main() {
  late MockSapObject mockObj;
  late GuiGridView grid;

  setUp(() {
    mockObj = MockSapObject();
    grid = GuiGridView(mockObj);
  });

  group('GuiGridView - Lectura de Celdas', () {
    test(
      'Debe obtener valores, tooltips, tipos, checkboxes y estados de celda',
      () {
        when(() => mockObj.getCellValue(1, 'COL')).thenReturn('Value');
        when(() => mockObj.getCellTooltip(1, 'COL')).thenReturn('Tooltip');
        when(() => mockObj.getCellType(1, 'COL')).thenReturn('Normal');
        when(() => mockObj.getCellCheckBoxChecked(1, 'COL')).thenReturn(true);
        when(() => mockObj.getCellChangeable(1, 'COL')).thenReturn(false);

        expect(grid.getCellValue(1, 'COL'), 'Value');
        expect(grid.getCellTooltip(1, 'COL'), 'Tooltip');
        expect(grid.getCellType(1, 'COL'), 'Normal');
        expect(grid.getCellCheckBoxChecked(1, 'COL'), isTrue);
        expect(grid.getCellChangeable(1, 'COL'), isFalse);
      },
    );
  });

  group('GuiGridView - Acciones de Celda', () {
    test('Debe ejecutar acciones de click, doble click y modificación', () {
      grid.pressButton(1, 'COL');
      grid.doubleClick(1, 'COL');
      grid.click(1, 'COL');
      grid.modifyCell(1, 'COL', 'NewVal');
      grid.modifyCheckBox(1, 'COL', true);

      verify(() => mockObj.pressButtonInGrid(1, 'COL')).called(1);
      verify(() => mockObj.doubleClick(1, 'COL')).called(1);
      verify(() => mockObj.click(1, 'COL')).called(1);
      verify(() => mockObj.modifyCell(1, 'COL', 'NewVal')).called(1);
      verify(() => mockObj.modifyCheckBox(1, 'COL', true)).called(1);
    });
  });

  group('GuiGridView - Toolbar y Teclado', () {
    test('Debe propagar eventos de toolbar y enter', () {
      grid.pressToolbarButton('BTN1');
      grid.selectToolbarMenuItem('MENU1');
      grid.pressEnter();

      verify(() => mockObj.pressToolbarButton('BTN1')).called(1);
      verify(() => mockObj.selectToolbarMenuItem('MENU1')).called(1);
      verify(() => mockObj.pressEnter()).called(1);
    });
  });

  group('GuiGridView - Estructura y Navegación', () {
    test('Debe manejar propiedades estructurales (get/set)', () {
      when(() => mockObj.rowCount).thenReturn(10);
      when(() => mockObj.columnCount).thenReturn(5);
      when(() => mockObj.title).thenReturn('Grid Title');
      when(() => mockObj.currentCellRow).thenReturn(1);
      when(() => mockObj.currentCellColumn).thenReturn('COL1');

      expect(grid.rowCount, 10);
      expect(grid.columnCount, 5);
      expect(grid.title, 'Grid Title');

      grid.currentCellRow = 5;
      grid.currentCellColumn = 'COL2';

      verify(() => mockObj.currentCellRow = 5).called(1);
      verify(() => mockObj.currentCellColumn = 'COL2').called(1);
    });

    test('Debe ejecutar métodos de selección y navegación', () {
      grid.clearSelection();
      grid.clickCurrentCell();
      grid.currentCellMoved();
      grid.doubleClickCurrentCell();
      grid.deselectColumn('COL');
      grid.selectAll();
      grid.selectColumn('COL');
      grid.selectionChanged();
      grid.setCurrentCell(2, 'COL');

      verify(() => mockObj.clearSelection()).called(1);
      verify(() => mockObj.clickCurrentCell()).called(1);
      verify(() => mockObj.currentCellMoved()).called(1);
      verify(() => mockObj.doubleClickCurrentCell()).called(1);
      verify(() => mockObj.deselectColumn('COL')).called(1);
      verify(() => mockObj.selectAll()).called(1);
      verify(() => mockObj.selectColumn('COL')).called(1);
      verify(() => mockObj.selectionChanged()).called(1);
      verify(() => mockObj.setCurrentCell(2, 'COL')).called(1);
    });
  });

  group('GuiGridView - Operaciones con Filas', () {
    test('Debe manejar manipulación de filas', () {
      grid.deleteRows('1-3');
      grid.duplicateRows('4');
      grid.insertRows('5');
      grid.moveRows(1, 2, 10);
      grid.pressTotalRow(1, 'COL');
      grid.pressTotalRowCurrentCell();

      verify(() => mockObj.deleteRows('1-3')).called(1);
      verify(() => mockObj.duplicateRows('4')).called(1);
      verify(() => mockObj.insertRows('5')).called(1);
      verify(() => mockObj.moveRows(1, 2, 10)).called(1);
      verify(() => mockObj.pressTotalRow(1, 'COL')).called(1);
      verify(() => mockObj.pressTotalRowCurrentCell()).called(1);
    });
  });

  group('GuiGridView - Metadatos de Celdas y Columnas', () {
    test('Debe obtener dimensiones y estados técnicos de celda', () {
      when(() => mockObj.getCellColor(0, 'C')).thenReturn(1);
      when(() => mockObj.getCellHeight(0, 'C')).thenReturn(20);
      when(() => mockObj.getCellHotspotType(0, 'C')).thenReturn('Type');
      when(() => mockObj.getCellIcon(0, 'C')).thenReturn('Icon');
      when(() => mockObj.getCellLeft(0, 'C')).thenReturn(10);
      when(() => mockObj.getCellListBoxCount(0, 'C')).thenReturn(5);
      when(() => mockObj.getCellListBoxCurIndex(0, 'C')).thenReturn('1');
      when(() => mockObj.getCellMaxLength(0, 'C')).thenReturn(10);
      when(() => mockObj.getCellState(0, 'C')).thenReturn('State');
      when(() => mockObj.getCellTop(0, 'C')).thenReturn(5);
      when(() => mockObj.getCellWidth(0, 'C')).thenReturn(100);
      when(() => mockObj.hasCellF4Help(0, 'C')).thenReturn(true);
      when(() => mockObj.isCellHotspot(0, 'C')).thenReturn(false);
      when(() => mockObj.isCellSymbol(0, 'C')).thenReturn(true);
      when(() => mockObj.isCellTotalExpander(0, 'C')).thenReturn(false);

      expect(grid.getCellColor(0, 'C'), 1);
      expect(grid.getCellHeight(0, 'C'), 20);
      expect(grid.getCellHotspotType(0, 'C'), 'Type');
      expect(grid.getCellIcon(0, 'C'), 'Icon');
      expect(grid.getCellLeft(0, 'C'), 10);
      expect(grid.getCellListBoxCount(0, 'C'), 5);
      expect(grid.getCellListBoxCurIndex(0, 'C'), '1');
      expect(grid.getCellMaxLength(0, 'C'), 10);
      expect(grid.getCellState(0, 'C'), 'State');
      expect(grid.getCellTop(0, 'C'), 5);
      expect(grid.getCellWidth(0, 'C'), 100);
      expect(grid.hasCellF4Help(0, 'C'), isTrue);
      expect(grid.isCellHotspot(0, 'C'), isFalse);
      expect(grid.isCellSymbol(0, 'C'), isTrue);
      expect(grid.isCellTotalExpander(0, 'C'), isFalse);
    });

    test('Debe obtener y establecer metadatos de columnas', () {
      when(() => mockObj.getColumnDataType('C')).thenReturn('String');
      when(() => mockObj.getColumnOperationType('C')).thenReturn('None');
      when(() => mockObj.getColumnPosition('C')).thenReturn(2);
      when(() => mockObj.getColumnSortType('C')).thenReturn('Asc');
      when(() => mockObj.getColumnTooltip('C')).thenReturn('Tip');
      when(() => mockObj.getColumnTotalType('C')).thenReturn('Sum');
      when(() => mockObj.getDisplayedColumnTitle('C')).thenReturn('Title');
      when(() => mockObj.isColumnFiltered('C')).thenReturn(true);
      when(() => mockObj.isColumnKey('C')).thenReturn(false);

      expect(grid.getColumnDataType('C'), 'String');
      expect(grid.getColumnOperationType('C'), 'None');
      expect(grid.getColumnPosition('C'), 2);
      expect(grid.getColumnSortType('C'), 'Asc');
      expect(grid.getColumnTooltip('C'), 'Tip');
      expect(grid.getColumnTotalType('C'), 'Sum');
      expect(grid.getDisplayedColumnTitle('C'), 'Title');
      expect(grid.isColumnFiltered('C'), isTrue);
      expect(grid.isColumnKey('C'), isFalse);

      grid.setColumnWidth('C', 50);
      verify(() => mockObj.setColumnWidth('C', 50)).called(1);
    });
  });

  group('GuiGridView - Métodos Misceláneos y Toolbar Detallado', () {
    test('Debe manejar info de colores, símbolos y estados de botones', () {
      when(() => mockObj.getColorInfo(1)).thenReturn('Red');
      when(() => mockObj.getRowTotalLevel(1)).thenReturn(0);
      when(() => mockObj.getSymbolInfo('S')).thenReturn('Sym');
      when(() => mockObj.getToolbarButtonChecked(1)).thenReturn(true);
      when(() => mockObj.getToolbarButtonEnabled(1)).thenReturn(true);
      when(() => mockObj.getToolbarButtonIcon(1)).thenReturn('Icon');
      when(() => mockObj.getToolbarButtonId(1)).thenReturn('ID');
      when(() => mockObj.getToolbarButtonText(1)).thenReturn('Text');
      when(() => mockObj.getToolbarButtonTooltip(1)).thenReturn('Tooltip');
      when(() => mockObj.getToolbarButtonType(1)).thenReturn('Type');
      when(() => mockObj.getToolbarFocusButton()).thenReturn(1);
      when(() => mockObj.isTotalRowExpanded(1)).thenReturn(false);

      expect(grid.getColorInfo(1), 'Red');
      expect(grid.getRowTotalLevel(1), 0);
      expect(grid.getSymbolInfo('S'), 'Sym');
      expect(grid.getToolbarButtonChecked(1), isTrue);
      expect(grid.getToolbarButtonEnabled(1), isTrue);
      expect(grid.getToolbarButtonIcon(1), 'Icon');
      expect(grid.getToolbarButtonId(1), 'ID');
      expect(grid.getToolbarButtonText(1), 'Text');
      expect(grid.getToolbarButtonTooltip(1), 'Tooltip');
      expect(grid.getToolbarButtonType(1), 'Type');
      expect(grid.getToolbarFocusButton(), 1);
      expect(grid.isTotalRowExpanded(1), isFalse);
    });

    test('Debe llamar a métodos de sistema (F1, F4, ContextMenu, etc.)', () {
      grid.contextMenu();
      grid.pressF1();
      grid.pressF4();
      grid.pressButtonCurrentCell();
      grid.pressColumnHeader('COL');
      grid.pressToolbarContextButton('ID');
      grid.triggerModified();

      verify(() => mockObj.contextMenu()).called(1);
      verify(() => mockObj.pressF1()).called(1);
      verify(() => mockObj.pressF4()).called(1);
      verify(() => mockObj.pressButtonCurrentCell()).called(1);
      verify(() => mockObj.pressColumnHeader('COL')).called(1);
      verify(() => mockObj.pressToolbarContextButton('ID')).called(1);
      verify(() => mockObj.triggerModified()).called(1);
    });
  });

  group('GuiGridView - Historial y Colecciones', () {
    test('Debe manejar el historial de inputs', () {
      when(() => mockObj.historyCurEntry(1, 'C')).thenReturn('E');
      when(() => mockObj.historyCurIndex(1, 'C')).thenReturn(0);
      when(() => mockObj.historyIsActive(1, 'C')).thenReturn(true);

      expect(grid.historyCurEntry(1, 'C'), 'E');
      expect(grid.historyCurIndex(1, 'C'), 0);
      expect(grid.historyIsActive(1, 'C'), isTrue);
    });

    test('Debe manejar colecciones y propiedades de visibilidad', () {
      final mockHistoryList = MockSapObject();
      when(() => mockObj.getColumnTitles('C')).thenReturn(['T1']);
      when(() => mockObj.historyList(1, 'C')).thenReturn(mockHistoryList);
      when(() => mockObj.columnOrder).thenReturn(['C1']);
      when(() => mockObj.currentCellColumn).thenReturn('C1');
      when(() => mockObj.currentCellRow).thenReturn(1);
      when(() => mockObj.firstVisibleColumn).thenReturn('C1');
      when(() => mockObj.firstVisibleRow).thenReturn(0);
      when(() => mockObj.frozenColumnCount).thenReturn(2);
      when(() => mockObj.selectedCells).thenReturn(['1,C']);
      when(() => mockObj.selectedColumns).thenReturn(['C']);
      when(() => mockObj.selectedRows).thenReturn('1-2');
      when(() => mockObj.selectionMode).thenReturn('Single');
      when(() => mockObj.toolbarButtonCount).thenReturn(10);
      when(() => mockObj.visibleRowCount).thenReturn(5);

      expect(grid.getColumnTitles('C'), ['T1']);
      expect(grid.historyList(1, 'C'), equals(mockHistoryList));
      expect(grid.columnOrder, ['C1']);
      expect(grid.currentCellColumn, 'C1');
      expect(grid.currentCellRow, 1);
      expect(grid.firstVisibleColumn, 'C1');
      expect(grid.firstVisibleRow, 0);
      expect(grid.frozenColumnCount, 2);
      expect(grid.selectedCells, ['1,C']);
      expect(grid.selectedColumns, ['C']);
      expect(grid.selectedRows, '1-2');
      expect(grid.selectionMode, 'Single');
      expect(grid.toolbarButtonCount, 10);
      expect(grid.visibleRowCount, 5);

      // Setters
      grid.firstVisibleColumn = 'C2';
      grid.firstVisibleRow = 5;
      grid.selectedCells = ['2,C'];
      grid.selectedColumns = ['C2'];
      grid.selectedRows = '5';

      verify(() => mockObj.firstVisibleColumn = 'C2').called(1);
      verify(() => mockObj.firstVisibleRow = 5).called(1);
      verify(() => mockObj.selectedCells = ['2,C']).called(1);
      verify(() => mockObj.selectedColumns = ['C2']).called(1);
      verify(() => mockObj.selectedRows = '5').called(1);
    });
  });
  group('Tests de Setters de Componentes', () {
    test('set columnOrder extrae el handle y lo asigna a obj.columnOrder', () {
      // 1. PREPARACIÓN (Arrange)
      final mockObj = MockSapObject();
      final mockCollection = MockGuiCollection();
      const fakeHandle = 999;

      // Configuramos el mock de la colección para que devuelva un handle simulado
      when(() => mockCollection.handle).thenReturn(fakeHandle);

      // Instanciamos la clase que estás testeando (sustituye 'TuClaseComponente' por el nombre real)
      final component = GuiGridView(mockObj);

      // 2. EJECUCIÓN (Act)
      component.columnOrder = mockCollection;

      // 3. VERIFICACIÓN (Assert)
      // Verificamos que se leyó el handle de la colección
      verify(() => mockCollection.handle).called(1);

      // Verificamos que el setter del objeto subyacente recibió exactamente ese handle
      verify(() => mockObj.columnOrder = fakeHandle).called(1);
    });
  });
}
