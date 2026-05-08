import 'package:mocktail/mocktail.dart';
import 'package:sap_gui_scripting/gui_classes/gui_session.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';
import 'package:test/test.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;
  late GuiSession session;

  setUp(() {
    mockObj = MockSapObject();
    session = GuiSession(mockObj);
  });

  group('GuiSession - Objetos Complejos (Wrappers)', () {
    test('info lanza excepción si el objeto base devuelve null', () {
      when(() => mockObj.info).thenReturn(null);
      expect(() => session.info, throwsException);
    });

    test('info devuelve GuiSessionInfo si el objeto base existe', () {
      final mockInfo = MockSapObject();
      when(() => mockObj.info).thenReturn(mockInfo);

      final result = session.info;

      expect(result, isNotNull);
      expect(result.runtimeType.toString(), 'GuiSessionInfo');
    });

    test('activeWindow devuelve null si no hay ventana activa', () {
      when(() => mockObj.activeWindow).thenReturn(null);
      expect(session.activeWindow, isNull);
    });

    test('activeWindow devuelve GuiMainWindow si hay ventana activa', () {
      final mockWindow = MockSapObject();
      when(() => mockObj.activeWindow).thenReturn(mockWindow);

      final result = session.activeWindow;

      expect(result, isNotNull);
      expect(result.runtimeType.toString(), 'GuiMainWindow');
    });
  });

  group('GuiSession - Propiedades Primitivas (Getters / Setters)', () {
    test('Propiedades Booleanas (busy)', () {
      when(() => mockObj.busy).thenReturn(true);
      expect(session.busy, isTrue);
      verify(() => mockObj.busy).called(1);
    });

    test('Propiedades Numéricas (testToolMode)', () {
      // Getter
      when(() => mockObj.testToolMode).thenReturn(1);
      expect(session.testToolMode, 1);

      // Setter
      session.testToolMode = 0;
      verify(() => mockObj.testToolMode = 0).called(1);
    });

    test('Propiedades de Texto (recordFile)', () {
      // Getter
      when(() => mockObj.recordFile).thenReturn('C:\\script.vbs');
      expect(session.recordFile, 'C:\\script.vbs');

      // Setter
      session.recordFile = 'D:\\nuevo.vbs';
      verify(() => mockObj.recordFile = 'D:\\nuevo.vbs').called(1);
    });
  });

  group('GuiSession - Métodos', () {
    test('sendCommand delega el comando correctamente', () {
      session.sendCommand('/nVA01');
      verify(() => mockObj.sendCommand('/nVA01')).called(1);
    });

    test('sendVKey pasa el código de tecla correcto', () {
      session.sendVKey(0); // Enter
      verify(() => mockObj.sendVKey(0)).called(1);
    });

    test('clearErrorList limpia la lista de errores de controles ActiveX.', () {
      session.clearErrorList();
      verify(() => mockObj.clearErrorList()).called(1);
    });

    test(
      'findByPosition pasa los parámetros incluyendo los opcionales por defecto',
      () {
        when(
          () => mockObj.findByPosition(100, 200, raise: true),
        ).thenReturn(['id1', 'id2']);

        final result = session.findByPosition(100, 200);

        expect(result, equals(['id1', 'id2']));
        verify(() => mockObj.findByPosition(100, 200, raise: true)).called(1);
      },
    );

    test('getObjectTree pasa los parámetros personalizados correctamente', () {
      when(
        () => mockObj.getObjectTree('wnd[0]', properties: ['Text', 'Type']),
      ).thenReturn('{"tree": "data"}');

      final result = session.getObjectTree(
        'wnd[0]',
        properties: ['Text', 'Type'],
      );

      expect(result, '{"tree": "data"}');
      verify(
        () => mockObj.getObjectTree('wnd[0]', properties: ['Text', 'Type']),
      ).called(1);
    });
  });

  group('GuiSession - Accesibilidad y Estado UI', () {
    test('Propiedades booleanas de lectura/escritura', () {
      // isActive (solo lectura)
      when(() => mockObj.isActive).thenReturn(true);
      expect(session.isActive, isTrue);

      // accEnhancedTabChain (lectura/escritura)
      when(() => mockObj.accEnhancedTabChain).thenReturn(true);
      expect(session.accEnhancedTabChain, isTrue);
      session.accEnhancedTabChain = false;
      verify(() => mockObj.accEnhancedTabChain = false).called(1);

      // accSymbolReplacement
      when(() => mockObj.accSymbolReplacement).thenReturn(false);
      expect(session.accSymbolReplacement, isFalse);
      session.accSymbolReplacement = true;
      verify(() => mockObj.accSymbolReplacement = true).called(1);
    });

    test('errorList devuelve el objeto dinámico correctamente', () {
      final MockSapObject? mockErrors = null;
      when(() => mockObj.errorList).thenReturn(mockErrors);
      expect(session.errorList, equals(mockErrors));
    });
  });

  group('GuiSession - Progreso y ListBox', () {
    test('Propiedades de progreso', () {
      when(() => mockObj.progressPercent).thenReturn(45);
      when(() => mockObj.progressText).thenReturn('Cargando...');

      expect(session.progressPercent, 45);
      expect(session.progressText, 'Cargando...');
    });

    test('Propiedades de geometría del ListBox', () {
      when(() => mockObj.listBoxCurrEntry).thenReturn(5);
      when(() => mockObj.listBoxCurrEntryHeight).thenReturn(10);
      when(() => mockObj.listBoxCurrEntryLeft).thenReturn(8);
      when(() => mockObj.listBoxCurrEntryTop).thenReturn(12);
      when(() => mockObj.listBoxCurrEntryWidth).thenReturn(20);
      when(() => mockObj.isListBoxActive).thenReturn(true);
      when(() => mockObj.listBoxHeight).thenReturn(200);
      when(() => mockObj.listBoxWidth).thenReturn(100);
      // Agrega uno de posición para verificar
      when(() => mockObj.listBoxLeft).thenReturn(10);
      when(() => mockObj.listBoxTop).thenReturn(20);

      expect(session.listBoxCurrEntry, 5);
      expect(session.listBoxCurrEntryHeight, 10);
      expect(session.listBoxCurrEntryLeft, 8);
      expect(session.listBoxCurrEntryTop, 12);
      expect(session.listBoxCurrEntryWidth, 20);
      expect(session.isListBoxActive, isTrue);
      expect(session.listBoxHeight, 200);
      expect(session.listBoxWidth, 100);
      expect(session.listBoxLeft, 10);
      expect(session.listBoxTop, 20);
    });
  });

  group('GuiSession - Pasaporte y Grabación', () {
    test('Passport properties', () {
      when(() => mockObj.passportSystemId).thenReturn('PRD');
      expect(session.passportSystemId, 'PRD');
      when(() => mockObj.passportPreSystemId).thenReturn('PPRD');
      expect(session.passportPreSystemId, 'PPRD');
      when(() => mockObj.passportTransactionId).thenReturn('PRDID');
      expect(session.passportTransactionId, 'PRDID');

      session.passportSystemId = 'DEV';
      verify(() => mockObj.passportSystemId = 'DEV').called(1);
      session.passportPreSystemId = 'PDEV';
      verify(() => mockObj.passportPreSystemId = 'PDEV').called(1);
      session.passportTransactionId = 'DEVID';
      verify(() => mockObj.passportTransactionId = 'DEVID').called(1);
    });

    test('Flags de configuración (record, unicode, popups)', () {
      when(() => mockObj.record).thenReturn(false);
      expect(session.record, false);
      session.record = true;
      verify(() => mockObj.record = true).called(1);

      when(() => mockObj.suppressBackendPopups).thenReturn(true);
      expect(session.suppressBackendPopups, isTrue);
      when(() => mockObj.saveAsUnicode).thenReturn(true);
      expect(session.saveAsUnicode, isTrue);
      when(() => mockObj.showDropdownKeys).thenReturn(true);
      expect(session.showDropdownKeys, isTrue);

      session.suppressBackendPopups = false;
      verify(() => mockObj.suppressBackendPopups = false).called(1);
      session.saveAsUnicode = false;
      verify(() => mockObj.saveAsUnicode = false).called(1);
      session.showDropdownKeys = false;
      verify(() => mockObj.showDropdownKeys = false).called(1);
    });
  });

  group('GuiSession - Métodos de Acción y Utilidades', () {
    test('Delegación de métodos de transacción y sesión', () {
      session.sendCommandAsync('/nVA01');
      verify(() => mockObj.sendCommandAsync('/nVA01')).called(1);

      session.startTransaction('SU01');
      verify(() => mockObj.startTransaction('SU01')).called(1);

      session.endTransaction();
      verify(() => mockObj.endTransaction()).called(1);

      session.createSession();
      verify(() => mockObj.createSession()).called(1);
    });

    test('Métodos de UI (Lock/Unlock y JAWS)', () {
      session.lockSessionUI();
      verify(() => mockObj.lockSessionUI()).called(1);

      session.unlockSessionUI();
      verify(() => mockObj.unlockSessionUI()).called(1);

      session.enableJawsEvents();
      verify(() => mockObj.enableJawsEvents()).called(1);
    });

    test('Métodos de utilidad de conversión', () {
      when(() => mockObj.asStdNumberFormat('100-')).thenReturn('-100');
      expect(session.asStdNumberFormat('100-'), '-100');

      when(() => mockObj.getIconResourceName('@01@')).thenReturn('S_B_OKAY');
      expect(session.getIconResourceName('@01@'), 'S_B_OKAY');

      when(() => mockObj.getVKeyDescription(0)).thenReturn('Enter');
      expect(session.getVKeyDescription(0), 'Enter');
    });
  });
}
