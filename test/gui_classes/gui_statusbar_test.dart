import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_statusbar.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;
  late GuiStatusbar statusbar;

  setUp(() {
    mockObj = MockSapObject();
    statusbar = GuiStatusbar(mockObj);
  });

  group('GuiStatusbar - Acciones', () {
    test('Métodos de click y doubleClick deben delegar correctamente', () {
      statusbar.createSupportMessageClick();
      statusbar.serviceRequestClick();
      statusbar.doubleClick();

      verify(() => mockObj.createSupportMessageClick()).called(1);
      verify(() => mockObj.serviceRequestClick()).called(1);
      // ¡Ojo al mapeo interno!
      verify(() => mockObj.doubleClickNoArgs()).called(1);
    });
  });

  group('GuiStatusbar - Propiedades de Mensaje', () {
    test('Debe retornar la información del mensaje actual', () {
      when(() => mockObj.messageAsPopup).thenReturn(false);
      when(() => mockObj.messageHasLongText).thenReturn(1);
      when(() => mockObj.messageId).thenReturn('S1');
      when(() => mockObj.messageNumber).thenReturn('123');
      when(() => mockObj.messageParameter).thenReturn('Param');
      when(() => mockObj.messageTypeRetunString).thenReturn('S');

      expect(statusbar.messageAsPopup, isFalse);
      expect(statusbar.messageHasLongText, 1);
      expect(statusbar.messageId, 'S1');
      expect(statusbar.messageNumber, '123');
      expect(statusbar.messageParameter, 'Param');
      expect(
        statusbar.messageType,
        'S',
      ); // Valida mapeo a messageTypeRetunString
    });
  });
}
