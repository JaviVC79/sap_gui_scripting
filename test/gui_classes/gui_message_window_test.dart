import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_message_window.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;
  late GuiMessageWindow msgWindow;

  setUp(() {
    mockObj = MockSapObject();
    msgWindow = GuiMessageWindow(mockObj);
  });

  test('GuiMessageWindow - Propiedades de Mensaje', () {
    when(() => mockObj.messageText).thenReturn('Error crítico');
    when(() => mockObj.messageType).thenReturn(1);
    when(() => mockObj.focusedButton).thenReturn(0);
    when(() => mockObj.visible).thenReturn(true);

    expect(msgWindow.messageText, 'Error crítico');
    expect(msgWindow.messageType, 1);
    expect(msgWindow.focusedButton, 0);
    expect(msgWindow.visible, isTrue);
  });

  test('GuiMessageWindow - Botones y Ayuda', () {
    when(() => mockObj.okButtonText).thenReturn('Aceptar');
    when(() => mockObj.helpButtonText).thenReturn('Ayuda');
    when(() => mockObj.helpButtonHelpText).thenReturn('F1 para más info');

    expect(msgWindow.okButtonText, 'Aceptar');
    expect(msgWindow.helpButtonText, 'Ayuda');
    expect(msgWindow.helpButtonHelpText, 'F1 para más info');
  });

  test('GuiMessageWindow - Pantalla (Overrides)', () {
    when(() => mockObj.screenLeft).thenReturn(100);
    when(() => mockObj.screenTop).thenReturn(200);

    expect(msgWindow.screenLeft, 100);
    expect(msgWindow.screenTop, 200);

    msgWindow.screenLeft = 150;
    msgWindow.screenTop = 250;

    verify(() => mockObj.screenLeft = 150).called(1);
    verify(() => mockObj.screenTop = 250).called(1);
  });
}
