import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_toolbar_control.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;
  late GuiToolbarControl control;

  setUp(() {
    mockObj = MockSapObject();
    control = GuiToolbarControl(mockObj);
  });

  group('GuiToolbarControl - Consultas', () {
    test('Debe retornar propiedades generales y por índice', () {
      when(() => mockObj.buttonCount).thenReturn(5);
      when(() => mockObj.focusedButton).thenReturn(2);
      when(() => mockObj.getButtonText(0)).thenReturn('Guardar');
      when(() => mockObj.getButtonEnabled(0)).thenReturn(true);
      when(() => mockObj.getButtonChecked(0)).thenReturn(false);
      when(() => mockObj.getButtonTooltip(0)).thenReturn('Tooltip');
      when(() => mockObj.getButtonType(0)).thenReturn('Button');
      when(
        () => mockObj.getMenuItemIdFromPosition(0),
      ).thenReturn('MenuItemIdFromPosition');

      expect(control.buttonCount, 5);
      expect(control.focusedButton, 2);
      expect(control.getButtonText(0), 'Guardar');
      expect(control.getButtonChecked(0), isFalse);
      expect(control.getButtonEnabled(0), isTrue);
      expect(control.getButtonTooltip(0), 'Tooltip');
      expect(control.getButtonType(0), 'Button');
      expect(control.getMenuItemIdFromPosition(0), 'MenuItemIdFromPosition');
    });

    test('Debe delegar llamadas a iconos, IDs y Tooltips', () {
      when(() => mockObj.getButtonIcon(1)).thenReturn('@01@');
      when(() => mockObj.getButtonId(1)).thenReturn('BTN_SAVE');

      expect(control.getButtonIcon(1), '@01@');
      expect(control.getButtonId(1), 'BTN_SAVE');
    });
  });

  group('GuiToolbarControl - Acciones', () {
    test('pressButton debe mapear a pressButtonToolBarControl', () {
      control.pressButton('ID_1');
      verify(() => mockObj.pressButtonToolBarControl('ID_1')).called(1);
    });

    test('Métodos de menú deben delegar correctamente', () {
      control.selectMenuItem('MI_1');
      control.selectMenuItemByText('Texto');
      control.pressContextButton('CB_1');

      verify(() => mockObj.selectMenuItem('MI_1')).called(1);
      verify(() => mockObj.selectMenuItemByText('Texto')).called(1);
      verify(() => mockObj.pressContextButton('CB_1')).called(1);
    });
  });
}
