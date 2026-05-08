import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_label.dart';
import 'package:sap_gui_scripting/gui_classes/gui_text_field.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;
  late GuiTextField textField;

  setUp(() {
    mockObj = MockSapObject();
    textField = GuiTextField(mockObj);
  });

  group('GuiTextField - Métodos', () {
    test(
      'Debe obtener las propiedades de lista (recursivas y no recursivas)',
      () {
        when(() => mockObj.getListProperty('prop1')).thenReturn('valor1');
        when(() => mockObj.getListPropertyNonRec('prop2')).thenReturn('valor2');

        expect(textField.getListProperty('prop1'), 'valor1');
        expect(textField.getListPropertyNonRec('prop2'), 'valor2');
      },
    );
  });

  group('GuiTextField - Propiedades Simples y Mapeadas', () {
    test('Debe manejar getters y setters básicos correctamente', () {
      // Mock de propiedades enteras y strings
      when(() => mockObj.caretPosition).thenReturn(5);
      when(() => mockObj.displayedText).thenReturn('  Texto mostrado  ');
      when(() => mockObj.maxLength).thenReturn(40);

      // Mock de booleanos
      when(() => mockObj.highlighted).thenReturn(true);
      when(() => mockObj.isHotspot).thenReturn(false);
      when(() => mockObj.isLeftLabel).thenReturn(true);
      when(() => mockObj.isListElement).thenReturn(false);
      when(() => mockObj.isOField).thenReturn(false);
      when(() => mockObj.isRightLabel).thenReturn(false);
      when(() => mockObj.numerical).thenReturn(true);
      when(() => mockObj.required).thenReturn(true);

      // Verificamos getters
      expect(textField.caretPosition, 5);
      expect(textField.displayedText, '  Texto mostrado  ');
      expect(textField.maxLength, 40);
      expect(textField.highlighted, isTrue);
      expect(textField.isHotspot, isFalse);
      expect(textField.isLeftLabel, isTrue);
      expect(textField.isListElement, isFalse);
      expect(textField.isOField, isFalse);
      expect(textField.isRightLabel, isFalse);
      expect(textField.numerical, isTrue);
      expect(textField.required, isTrue);

      // Verificamos setter
      textField.caretPosition = 10;
      verify(() => mockObj.caretPosition = 10).called(1);
    });

    test('Debe mapear correctamente las propiedades de historial', () {
      // Atención aquí: Mockeamos las propiedades terminadas en "Prop"
      when(() => mockObj.historyCurEntryProp).thenReturn('Entrada anterior');
      when(() => mockObj.historyCurIndexProp).thenReturn(2);
      when(() => mockObj.historyIsActiveProp).thenReturn(true);
      when(
        () => mockObj.historyListProp,
      ).thenReturn(['Entrada 1', 'Entrada anterior']);

      // Verificamos que los getters de GuiTextField devuelven lo esperado
      expect(textField.historyCurEntry, 'Entrada anterior');
      expect(textField.historyCurIndex, 2);
      expect(textField.historyIsActive, isTrue);
      expect(textField.historyList, ['Entrada 1', 'Entrada anterior']);
    });
  });

  group('GuiTextField - Etiquetas (Labels)', () {
    test('leftLabel debe retornar GuiLabel o null', () {
      final mockLabel = MockSapObject();

      // Camino de éxito (Líneas 68-69)
      when(() => mockObj.leftLabel).thenReturn(mockLabel);
      expect(textField.leftLabel, isA<GuiLabel>());

      // Camino nulo
      when(() => mockObj.leftLabel).thenReturn(null);
      expect(textField.leftLabel, isNull);
    });

    test('rightLabel debe retornar GuiLabel o null', () {
      final mockLabel = MockSapObject();

      // Camino de éxito (Líneas 74-75)
      when(() => mockObj.rightLabel).thenReturn(mockLabel);
      expect(textField.rightLabel, isA<GuiLabel>());

      // Camino nulo
      when(() => mockObj.rightLabel).thenReturn(null);
      expect(textField.rightLabel, isNull);
    });
  });
}
