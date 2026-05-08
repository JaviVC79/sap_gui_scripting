import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_combo_box_control.dart';
import 'package:sap_gui_scripting/gui_classes/gui_combo_box_entry.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;
  late GuiComboBoxControl comboBox;

  setUp(() {
    mockObj = MockSapObject();
    comboBox = GuiComboBoxControl(mockObj);
  });

  group('GuiComboBoxControl - Métodos y Selección', () {
    test('fireSelected debe delegar al objeto base', () {
      comboBox.fireSelected();
      verify(() => mockObj.fireSelected()).called(1);
    });

    test('selected debe mapear a selectedInComboBox (get/set)', () {
      when(() => mockObj.selectedInComboBox).thenReturn('Key1');

      expect(comboBox.selected, 'Key1');

      comboBox.selected = 'Key2';
      verify(() => mockObj.selectedInComboBox = 'Key2').called(1);
    });
  });

  group('GuiComboBoxControl - Listado de Entradas', () {
    test('curListBoxEntry debe manejar nulos correctamente', () {
      final mockEntry = MockSapObject();
      when(() => mockObj.curListBoxEntry).thenReturn(mockEntry);
      expect(comboBox.curListBoxEntry, isA<GuiComboBoxEntry>());

      when(() => mockObj.curListBoxEntry).thenReturn(null);
      expect(comboBox.curListBoxEntry, isNull);

      when(() => mockObj.isListBoxActive).thenReturn(true);
      expect(comboBox.isListBoxActive, true);

      when(() => mockObj.labelText).thenReturn('text');
      expect(comboBox.labelText, 'text');
    });

    test('entries debe procesar la colección manejando nulos internos', () {
      final mockColl = MockSapObject();
      final mockItem = MockSapObject();

      when(() => mockObj.entries).thenReturn(mockColl);
      when(() => mockColl.count).thenReturn(2);
      // Simulamos un elemento válido y uno nulo para cubrir la línea 20
      when(() => mockColl.elementAt(0)).thenReturn(mockItem);
      when(() => mockColl.elementAt(1)).thenReturn(null);

      final result = comboBox.entries;
      expect(result.length, 1);
      expect(result.first, isA<GuiComboBoxEntry>());
    });

    test('entries debe retornar lista vacía si la colección es nula', () {
      when(() => mockObj.entries).thenReturn(null);
      expect(comboBox.entries, isEmpty);
    });
  });
}
