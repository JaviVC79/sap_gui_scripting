import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_split.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;

  setUp(() {
    mockObj = MockSapObject();
  });

  group('GuiSplit - Dimensiones y Sash', () {
    test('Debe obtener y establecer tamaños de filas y columnas', () {
      final split = GuiSplit(mockObj);
      when(() => mockObj.getColSize(1)).thenReturn(100);
      when(() => mockObj.getRowSize(2)).thenReturn(200);

      expect(split.getColSize(1), 100);
      expect(split.getRowSize(2), 200);

      split.setColSize(1, 150);
      split.setRowSize(2, 250);

      verify(() => mockObj.setColSize(1, 150)).called(1);
      verify(() => mockObj.setRowSize(2, 250)).called(1);
    });

    test('Debe mapear correctamente isVertical a isVerticalInt', () {
      final split = GuiSplit(mockObj);
      // Caso 1: Vertical (usualmente 1 en SAP)
      when(() => mockObj.isVerticalInt).thenReturn(1);
      expect(split.isVertical, 1);

      // Caso 0: Horizontal
      when(() => mockObj.isVerticalInt).thenReturn(0);
      expect(split.isVertical, 0);
    });

    test('Debe retornar el foco de los sash', () {
      final split = GuiSplit(mockObj);
      when(() => mockObj.focusedHorizontalSash).thenReturn(0);
      when(() => mockObj.focusedVerticalSash).thenReturn(-1);

      expect(split.focusedHorizontalSash, 0);
      expect(split.focusedVerticalSash, -1);
    });
  });
}
