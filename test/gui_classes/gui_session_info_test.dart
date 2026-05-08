import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_session_info.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;
  late GuiSessionInfo sessionInfo;

  setUp(() {
    mockObj = MockSapObject();
    sessionInfo = GuiSessionInfo(mockObj);
  });

  group('GuiSessionInfo - Información del Servidor', () {
    test('Debe retornar los datos del servidor y sistema', () {
      when(() => mockObj.applicationServer).thenReturn('APPSRV_01');
      when(() => mockObj.messageServer).thenReturn('MSSRV_01');
      when(() => mockObj.systemName).thenReturn('PRD');
      when(() => mockObj.systemNumber).thenReturn(0);
      when(() => mockObj.group).thenReturn('PUBLIC');

      expect(sessionInfo.applicationServer, 'APPSRV_01');
      expect(sessionInfo.messageServer, 'MSSRV_01');
      expect(sessionInfo.systemName, 'PRD');
      expect(sessionInfo.systemNumber, 0);
      expect(sessionInfo.group, 'PUBLIC');
    });
  });

  group('GuiSessionInfo - Sesión y Usuario', () {
    test('Debe retornar los datos del usuario y la sesión actual', () {
      when(() => mockObj.client).thenReturn('100');
      when(() => mockObj.user).thenReturn('BASIS_USER');
      when(() => mockObj.language).thenReturn('ES');
      when(() => mockObj.sessionNumber).thenReturn(1);
      when(() => mockObj.systemSessionId).thenReturn('SID_HANDLE_01');

      expect(sessionInfo.client, '100');
      expect(sessionInfo.user, 'BASIS_USER');
      expect(sessionInfo.language, 'ES');
      expect(sessionInfo.sessionNumber, 1);
      expect(sessionInfo.systemSessionId, 'SID_HANDLE_01');
    });
  });

  group('GuiSessionInfo - Contexto de Ejecución', () {
    test('Debe identificar la transacción, programa y pantalla actual', () {
      when(() => mockObj.transaction).thenReturn('VA01');
      when(() => mockObj.program).thenReturn('SAPMV45A');
      when(() => mockObj.screenNumber).thenReturn(101);

      expect(sessionInfo.transaction, 'VA01');
      expect(sessionInfo.program, 'SAPMV45A');
      expect(sessionInfo.screenNumber, 101);
    });
  });

  group('GuiSessionInfo - Rendimiento y Configuración Técnica', () {
    test('Debe reportar métricas de red y rendimiento', () {
      when(() => mockObj.responseTime).thenReturn(150);
      when(() => mockObj.roundTrips).thenReturn(5);
      when(() => mockObj.flushes).thenReturn(2);
      when(() => mockObj.isLowSpeedConnection).thenReturn(false);

      expect(sessionInfo.responseTime, 150);
      expect(sessionInfo.roundTrips, 5);
      expect(sessionInfo.flushes, 2);
      expect(sessionInfo.isLowSpeedConnection, isFalse);
    });

    test('Debe retornar codepage, guideline y estado de scripting', () {
      when(() => mockObj.guiCodepage).thenReturn(1100);
      when(() => mockObj.uiGuideline).thenReturn('FIORI');
      when(() => mockObj.scriptingModeReadOnly).thenReturn(true);

      expect(sessionInfo.guiCodepage, 1100);
      expect(sessionInfo.uiGuideline, 'FIORI');
      expect(sessionInfo.scriptingModeReadOnly, isTrue);
    });
  });
}
