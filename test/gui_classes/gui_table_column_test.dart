import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_table_column.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;
  late GuiTableColumn column;

  setUp(() {
    mockObj = MockSapObject();
    column = GuiTableColumn(mockObj);
  });

  group('GuiTableColumn', () {
    test('Debe retornar metadatos de la columna', () {
      when(() => mockObj.title).thenReturn('Nombre Cliente');
      when(() => mockObj.fixed).thenReturn(true);
      when(() => mockObj.iconName).thenReturn('ICON_CHECK');
      when(() => mockObj.defaultTooltip).thenReturn('Ayuda DDIC');
      when(() => mockObj.tooltip).thenReturn('Tooltip personalizado');

      expect(column.title, 'Nombre Cliente');
      expect(column.fixed, isTrue);
      expect(column.iconName, 'ICON_CHECK');
      expect(column.defaultTooltip, 'Ayuda DDIC');
      expect(column.tooltip, 'Tooltip personalizado');
    });

    test('Manejo de selección (Getter y Setter)', () {
      when(() => mockObj.selected).thenReturn(true);
      expect(column.selected, isTrue);

      column.selected = false;
      verify(() => mockObj.selected = false).called(1);
    });

    test('Contadores de colección', () {
      when(() => mockObj.count).thenReturn(15);

      expect(column.count, 15);
      expect(column.length, 15);
    });
  });
}
