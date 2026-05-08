import 'package:mocktail/mocktail.dart';
import 'package:sap_gui_scripting/gui_classes/gui_checkbox.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_label.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;
  late GuiCheckBox checkBox;

  setUp(() {
    mockObj = MockSapObject();
    checkBox = GuiCheckBox(mockObj);
  });

  group('GuiCheckBox - Métodos de Accesibilidad', () {
    test('Debe obtener propiedades de lista correctamente', () {
      when(() => mockObj.getListProperty('prop')).thenReturn('val');
      when(() => mockObj.getListPropertyNonRec('prop2')).thenReturn('val2');

      expect(checkBox.getListProperty('prop'), 'val');
      expect(checkBox.getListPropertyNonRec('prop2'), 'val2');
    });
  });

  group('GuiCheckBox - Estado y Selección', () {
    test('Debe manejar el getter y setter de "selected"', () {
      when(() => mockObj.selected).thenReturn(true);

      expect(checkBox.selected, isTrue);

      checkBox.selected = false;
      verify(() => mockObj.selected = false).called(1);
    });

    test('Debe retornar la propiedad flushing', () {
      when(() => mockObj.flushing).thenReturn(true);
      expect(checkBox.flushing, isTrue);
    });
  });

  group('GuiCheckBox - Estilo y Listas ABAP', () {
    test('Debe retornar propiedades de color y texto de fila', () {
      when(() => mockObj.colorIndex).thenReturn(5);
      when(() => mockObj.colorIntensified).thenReturn(true);
      when(() => mockObj.colorInverse).thenReturn(false);
      when(() => mockObj.rowText).thenReturn('Fila de lista');

      expect(checkBox.colorIndex, 5);
      expect(checkBox.colorIntensified, isTrue);
      expect(checkBox.colorInverse, isFalse);
      expect(checkBox.rowText, 'Fila de lista');
    });

    test('Debe retornar flags de contexto (ListElement, Labels)', () {
      when(() => mockObj.isLeftLabel).thenReturn(true);
      when(() => mockObj.isRightLabel).thenReturn(false);
      when(() => mockObj.isListElement).thenReturn(true);

      expect(checkBox.isLeftLabel, isTrue);
      expect(checkBox.isRightLabel, isFalse);
      expect(checkBox.isListElement, isTrue);
    });
  });

  group('GuiCheckBox - Etiquetas (Labels)', () {
    test('leftLabel y rightLabel deben retornar GuiLabel o null', () {
      final mockLabel = MockSapObject();

      // Caso: label existe (Líneas 57 y 64)
      when(() => mockObj.leftLabel).thenReturn(mockLabel);
      when(() => mockObj.rightLabel).thenReturn(mockLabel);
      expect(checkBox.leftLabel, isA<GuiLabel>());
      expect(checkBox.rightLabel, isA<GuiLabel>());

      // Caso: label es null
      when(() => mockObj.leftLabel).thenReturn(null);
      when(() => mockObj.rightLabel).thenReturn(null);
      expect(checkBox.leftLabel, isNull);
      expect(checkBox.rightLabel, isNull);
    });
  });
}
