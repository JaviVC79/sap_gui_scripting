import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_label.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;
  late GuiLabel label;

  setUp(() {
    mockObj = MockSapObject();
    label = GuiLabel(mockObj);
  });

  group('GuiLabel - Métodos de Listas ABAP', () {
    test('Debe obtener propiedades de lista recursivas y no recursivas', () {
      when(() => mockObj.getListProperty('prop')).thenReturn('value');
      when(
        () => mockObj.getListPropertyNonRec('propNon'),
      ).thenReturn('valueNon');

      expect(label.getListProperty('prop'), 'value');
      expect(label.getListPropertyNonRec('propNon'), 'valueNon');

      verify(() => mockObj.getListProperty('prop')).called(1);
      verify(() => mockObj.getListPropertyNonRec('propNon')).called(1);
    });
  });

  group('GuiLabel - Propiedades de Texto y Cursor', () {
    test('Debe manejar caretPosition (get/set) y textos de pantalla', () {
      when(() => mockObj.caretPosition).thenReturn(2);
      when(() => mockObj.displayedText).thenReturn('  Label Text  ');
      when(() => mockObj.maxLength).thenReturn(20);
      when(() => mockObj.numerical).thenReturn(false);
      when(() => mockObj.rowText).thenReturn('Full row text in ABAP list');

      expect(label.caretPosition, 2);
      expect(label.displayedText, '  Label Text  ');
      expect(label.maxLength, 20);
      expect(label.numerical, isFalse);
      expect(label.rowText, 'Full row text in ABAP list');

      label.caretPosition = 5;
      verify(() => mockObj.caretPosition = 5).called(1);
    });
  });

  group('GuiLabel - Métricas de Caracteres', () {
    test('Debe retornar las métricas basadas en celdas de texto', () {
      when(() => mockObj.charHeight).thenReturn(1);
      when(() => mockObj.charLeft).thenReturn(10);
      when(() => mockObj.charTop).thenReturn(5);
      when(() => mockObj.charWidth).thenReturn(15);

      expect(label.charHeight, 1);
      expect(label.charLeft, 10);
      expect(label.charTop, 5);
      expect(label.charWidth, 15);
    });
  });

  group('GuiLabel - Estilo, Color y Contexto', () {
    test('Debe retornar propiedades de color y resaltado', () {
      when(() => mockObj.colorIndex).thenReturn(3);
      when(() => mockObj.colorIntensified).thenReturn(true);
      when(() => mockObj.colorInverse).thenReturn(false);
      when(() => mockObj.highlighted).thenReturn(true);
      when(() => mockObj.isHotspot).thenReturn(false);

      expect(label.colorIndex, 3);
      expect(label.colorIntensified, isTrue);
      expect(label.colorInverse, isFalse);
      expect(label.highlighted, isTrue);
      expect(label.isHotspot, isFalse);
    });

    test(
      'Debe indicar correctamente el contexto y relación de la etiqueta',
      () {
        when(() => mockObj.isLeftLabel).thenReturn(true);
        when(() => mockObj.isRightLabel).thenReturn(false);
        when(() => mockObj.isListElement).thenReturn(true);

        expect(label.isLeftLabel, isTrue);
        expect(label.isRightLabel, isFalse);
        expect(label.isListElement, isTrue);
      },
    );
  });
}
