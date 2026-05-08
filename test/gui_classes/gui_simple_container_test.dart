import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_simple_container.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;

  setUp(() {
    mockObj = MockSapObject();
  });

  group('GuiSimpleContainer - Propiedades de Listas y Loops', () {
    test('Debe delegar métodos de propiedades de lista', () {
      final container = GuiSimpleContainer(mockObj);
      when(() => mockObj.getListProperty('prop1')).thenReturn('val1');
      when(() => mockObj.getListPropertyNonRec('prop2')).thenReturn('val2');

      expect(container.getListProperty('prop1'), 'val1');
      expect(container.getListPropertyNonRec('prop2'), 'val2');
    });

    test('Debe retornar estados booleanos de StepLoop', () {
      final container = GuiSimpleContainer(mockObj);
      when(() => mockObj.isListElement).thenReturn(true);
      when(() => mockObj.isStepLoop).thenReturn(false);
      when(() => mockObj.isStepLoopInTableStructure).thenReturn(true);

      expect(container.isListElement, isTrue);
      expect(container.isStepLoop, isFalse);
      expect(container.isStepLoopInTableStructure, isTrue);
    });

    test('Debe retornar contadores e índices de loops', () {
      final container = GuiSimpleContainer(mockObj);
      when(() => mockObj.loopColCount).thenReturn(5);
      when(() => mockObj.loopCurrentCol).thenReturn(2);
      when(() => mockObj.loopCurrentColCount).thenReturn(3);
      when(() => mockObj.loopCurrentRow).thenReturn(10);
      when(() => mockObj.loopRowCount).thenReturn(20);

      expect(container.loopColCount, 5);
      expect(container.loopCurrentCol, 2);
      expect(container.loopCurrentColCount, 3);
      expect(container.loopCurrentRow, 10);
      expect(container.loopRowCount, 20);
    });
  });
}
