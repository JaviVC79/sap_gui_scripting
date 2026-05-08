import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_table_row.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;
  late GuiTableRow row;

  setUp(() {
    mockObj = MockSapObject();
    row = GuiTableRow(mockObj);
  });

  group('GuiTableRow', () {
    test('Propiedades de estado de la fila', () {
      when(() => mockObj.selectable).thenReturn(true);
      when(() => mockObj.selected).thenReturn(false);

      expect(row.selectable, isTrue);
      expect(row.selected, isFalse);

      row.selected = true;
      verify(() => mockObj.selected = true).called(1);
    });

    test('Conteo de celdas en la fila', () {
      when(() => mockObj.count).thenReturn(8);

      expect(row.count, 8);
      expect(row.length, 8);
    });
  });
}
