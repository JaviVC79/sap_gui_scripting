import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_combo_box.dart';
import 'package:sap_gui_scripting/gui_classes/gui_combo_box_entry.dart';
import 'package:sap_gui_scripting/gui_classes/gui_label.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;
  late GuiComboBox comboBox;

  setUp(() {
    mockObj = MockSapObject();
    comboBox = GuiComboBox(mockObj);
  });

  group('GuiComboBox - Métodos y Métricas', () {
    test('setKeySpace debe delegar al objeto base', () {
      comboBox.setKeySpace();
      verify(() => mockObj.setKeySpace()).called(1);
    });

    test('Debe retornar las métricas de caracteres', () {
      when(() => mockObj.charHeight).thenReturn(15);
      when(() => mockObj.charLeft).thenReturn(10);
      when(() => mockObj.charTop).thenReturn(5);
      when(() => mockObj.charWidth).thenReturn(100);

      expect(comboBox.charHeight, 15);
      expect(comboBox.charLeft, 10);
      expect(comboBox.charTop, 5);
      expect(comboBox.charWidth, 100);
    });
  });

  group('GuiComboBox - Entradas (Entries)', () {
    test('curListBoxEntry debe retornar GuiComboBoxEntry o null', () {
      final mockEntry = MockSapObject();

      // Caso con valor
      when(() => mockObj.curListBoxEntry).thenReturn(mockEntry);
      expect(comboBox.curListBoxEntry, isA<GuiComboBoxEntry>());

      // Caso nulo
      when(() => mockObj.curListBoxEntry).thenReturn(null);
      expect(comboBox.curListBoxEntry, isNull);
    });

    test('entries debe retornar una lista vacía si entriesObj es nulo', () {
      // Línea 21
      when(() => mockObj.entries).thenReturn(null);
      expect(comboBox.entries, isEmpty);
    });

    test(
      'entries debe transformar correctamente la colección de SAP a una List de Dart',
      () {
        // Líneas 22-30
        final mockCollection = MockSapObject();
        final mockEntry1 = MockSapObject();

        when(() => mockObj.entries).thenReturn(mockCollection);
        when(() => mockCollection.count).thenReturn(2);

        // Simulamos que el primer elemento existe y el segundo es un nulo inesperado
        when(() => mockCollection.elementAt(0)).thenReturn(mockEntry1);
        when(() => mockCollection.elementAt(1)).thenReturn(null);

        final result = comboBox.entries;

        expect(result.length, 1); // Solo añadió el que no era null
        expect(result.first, isA<GuiComboBoxEntry>());
        verify(() => mockCollection.elementAt(0)).called(1);
        verify(() => mockCollection.elementAt(1)).called(1);
      },
    );
  });

  group('GuiComboBox - Etiquetas y Estado', () {
    test('leftLabel y rightLabel deben retornar GuiLabel o null', () {
      final mockLabel = MockSapObject();

      when(() => mockObj.leftLabel).thenReturn(mockLabel);
      when(() => mockObj.rightLabel).thenReturn(null);

      expect(comboBox.leftLabel, isA<GuiLabel>());
      expect(comboBox.rightLabel, isNull);

      when(() => mockObj.rightLabel).thenReturn(mockLabel);
      expect(comboBox.rightLabel, isA<GuiLabel>());
    });

    test('Debe manejar propiedades de estado (booleans)', () {
      when(() => mockObj.flushing).thenReturn(true);
      when(() => mockObj.highlighted).thenReturn(false);
      when(() => mockObj.isLeftLabel).thenReturn(true);
      when(() => mockObj.isListBoxActive).thenReturn(false);
      when(() => mockObj.isRightLabel).thenReturn(false);
      when(() => mockObj.required).thenReturn(true);
      when(() => mockObj.showKey).thenReturn(true);

      expect(comboBox.flushing, isTrue);
      expect(comboBox.highlighted, isFalse);
      expect(comboBox.isLeftLabel, isTrue);
      expect(comboBox.isListBoxActive, isFalse);
      expect(comboBox.isRightLabel, isFalse);
      expect(comboBox.required, isTrue);
      expect(comboBox.showKey, isTrue);
    });

    test('Debe manejar getters y setters de key y value', () {
      when(() => mockObj.key).thenReturn('01');
      when(() => mockObj.value).thenReturn('Option 1');

      expect(comboBox.key, '01');
      expect(comboBox.value, 'Option 1');

      comboBox.key = '02';
      comboBox.value = 'Option 2';

      verify(() => mockObj.key = '02').called(1);
      verify(() => mockObj.value = 'Option 2').called(1);
    });
  });
}
