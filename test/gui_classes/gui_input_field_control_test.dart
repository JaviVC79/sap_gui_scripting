import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_input_field_control.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;

  setUp(() {
    mockObj = MockSapObject();
  });

  // ==========================================
  // GuiInputFieldControl
  // ==========================================
  group('GuiInputFieldControl', () {
    test(
      'Debe delegar submit y mapear las propiedades del historial correctamente',
      () {
        final inputField = GuiInputFieldControl(mockObj);

        // Submit
        inputField.submit();
        verify(() => mockObj.submit()).called(1);

        // Propiedades mapeadas
        when(() => mockObj.buttonTooltip).thenReturn('Buscar');
        when(() => mockObj.findButtonActivated).thenReturn(true);
        when(
          () => mockObj.historyCurEntryFromInputFieldControl,
        ).thenReturn('Entrada anterior');
        when(() => mockObj.historyCurIndexFromInputFieldControl).thenReturn(2);
        when(
          () => mockObj.historyIsActiveFromInputFieldControl,
        ).thenReturn(true);
        when(() => mockObj.historyListProp).thenReturn(['Uno', 'Dos']);
        when(() => mockObj.labelText).thenReturn('Usuario:');
        when(() => mockObj.promptText).thenReturn('Ingrese usuario');

        expect(inputField.buttonTooltip, 'Buscar');
        expect(inputField.findButtonActivated, isTrue);
        expect(
          inputField.historyCurEntry,
          'Entrada anterior',
        ); // Validamos el mapeo del nombre
        expect(inputField.historyCurIndex, 2);
        expect(inputField.historyIsActive, isTrue);
        expect(inputField.historyList, ['Uno', 'Dos']);
        expect(inputField.labelText, 'Usuario:');
        expect(inputField.promptText, 'Ingrese usuario');
      },
    );
  });
}
