import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_scroll_bar.dart';
import 'package:sap_gui_scripting/gui_classes/gui_table_column.dart';
import 'package:sap_gui_scripting/gui_classes/gui_table_control.dart';
import 'package:sap_gui_scripting/gui_classes/gui_table_row.dart';
import 'package:sap_gui_scripting/gui_classes/gui_v_component.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

class MockGuiTableColumn extends Mock implements GuiTableColumn {}

void main() {
  late MockSapObject mockObj;
  late GuiTableControl table;

  setUp(() {
    mockObj = MockSapObject();
    table = GuiTableControl(mockObj);
  });

  group('GuiTableControl - Métodos Específicos (Acciones)', () {
    test(
      'Debe llamar a los métodos de configuración, selección y reordenamiento',
      () {
        table.configureLayout();
        table.deselectAllColumns();
        table.selectAllColumns();
        table.reorderTable('0 2 1');

        verify(() => mockObj.configureLayout()).called(1);
        verify(() => mockObj.deselectAllColumns()).called(1);
        verify(() => mockObj.selectAllColumns()).called(1);
        verify(() => mockObj.reorderTable('0 2 1')).called(1);
      },
    );
  });

  group('GuiTableControl - Métodos de Obtención (Filas y Celdas)', () {
    test('getAbsoluteRow debe devolver un GuiTableRow o null', () {
      final mockRowObj = MockSapObject();

      // Camino 1: Retorna un objeto
      when(() => mockObj.getAbsoluteRow(5)).thenReturn(mockRowObj);
      expect(table.getAbsoluteRow(5), isA<GuiTableRow>());

      // Camino 2: Retorna null
      when(() => mockObj.getAbsoluteRow(10)).thenReturn(null);
      expect(table.getAbsoluteRow(10), isNull);
    });

    test('getCell debe devolver un GuiVComponent o null', () {
      final mockCellObj = MockSapObject();

      // Camino 1: Retorna un objeto
      when(() => mockObj.getCell(1, 2)).thenReturn(mockCellObj);
      expect(table.getCell(1, 2), isA<GuiVComponent>());

      // Camino 2: Retorna null
      when(() => mockObj.getCell(9, 9)).thenReturn(null);
      expect(table.getCell(9, 9), isNull);
    });
  });

  group('GuiTableControl - Propiedades Primitivas (Getters)', () {
    test(
      'Debe devolver las métricas, modos de selección y estado correctamente',
      () {
        when(() => mockObj.charHeight).thenReturn(10);
        when(() => mockObj.charLeft).thenReturn(5);
        when(() => mockObj.charTop).thenReturn(2);
        when(() => mockObj.charWidth).thenReturn(50);
        when(() => mockObj.colSelectMode).thenReturn(1);
        when(() => mockObj.currentCol).thenReturn(3);
        when(() => mockObj.currentRow).thenReturn(4);
        when(() => mockObj.rowCount).thenReturn(100);
        when(() => mockObj.rowSelectMode).thenReturn(2);
        when(() => mockObj.tableFieldName).thenReturn('ITAB_DATA');
        when(() => mockObj.visibleRowCount).thenReturn(15);

        expect(table.charHeight, 10);
        expect(table.charLeft, 5);
        expect(table.charTop, 2);
        expect(table.charWidth, 50);
        expect(table.colSelectMode, 1);
        expect(table.currentCol, 3);
        expect(table.currentRow, 4);
        expect(table.rowCount, 100);
        expect(table.rowSelectMode, 2);
        expect(table.tableFieldName, 'ITAB_DATA');
        expect(table.visibleRowCount, 15);
      },
    );
  });

  group('GuiTableControl - Objetos y Colecciones (Getters)', () {
    test('columns debe devolver la instancia directamente desde el mock', () {
      final mockCol = MockGuiTableColumn();

      when(() => mockObj.columns).thenReturn(mockCol);
      expect(table.columns, equals(mockCol));

      when(() => mockObj.columns).thenReturn(null);
      expect(table.columns, isNull);
    });

    test('horizontalScrollbar debe devolver el objeto sin envolver', () {
      final mockScroll = MockSapObject();

      when(() => mockObj.horizontalScrollbar).thenReturn(mockScroll);
      expect(table.horizontalScrollbar, equals(mockScroll));

      when(() => mockObj.horizontalScrollbar).thenReturn(null);
      expect(table.horizontalScrollbar, isNull);
    });

    test('rows debe devolver un GuiTableRow o null', () {
      final mockRowsObj = MockSapObject();

      // Camino 1: Retorna un objeto
      when(() => mockObj.rows).thenReturn(mockRowsObj);
      expect(table.rows, isA<GuiTableRow>());

      // Camino 2: Retorna null
      when(() => mockObj.rows).thenReturn(null);
      expect(table.rows, isNull);
    });

    test('verticalScrollbar debe devolver un GuiScrollbar o null', () {
      final mockScrollObj = MockSapObject();

      // Camino 1: Retorna un objeto
      when(() => mockObj.verticalScrollbar).thenReturn(mockScrollObj);
      expect(table.verticalScrollbar, isA<GuiScrollbar>());

      // Camino 2: Retorna null
      when(() => mockObj.verticalScrollbar).thenReturn(null);
      expect(table.verticalScrollbar, isNull);
    });
  });
}
