import 'package:mocktail/mocktail.dart';
import 'package:sap_gui_scripting/gui_classes/gui_collection.dart';
import 'package:sap_gui_scripting/gui_classes/gui_utils.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_application.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;
  late GuiApplication app;

  setUp(() {
    mockObj = MockSapObject();
    app = GuiApplication(mockObj);
  });

  group('GuiApplication - Propiedades de Versión y Diseño', () {
    test(
      'Debe retornar las versiones y propiedades correctamente desde el objeto base',
      () {
        // Arrange
        when(() => mockObj.connectionErrorText).thenReturn('errorText');
        when(() => mockObj.historyEnabled).thenReturn(true);
        when(() => mockObj.majorVersion).thenReturn(7);
        when(() => mockObj.minorVersion).thenReturn(60);
        when(() => mockObj.patchlevel).thenReturn(2);
        when(() => mockObj.revision).thenReturn(3);
        when(() => mockObj.newVisualDesign).thenReturn(true);

        // Mocks para los nuevos getters de visibilidad
        when(() => mockObj.buttonbarVisible).thenReturn(true);
        when(() => mockObj.statusbarVisible).thenReturn(false);
        when(() => mockObj.titlebarVisible).thenReturn(true);
        when(() => mockObj.toolbarVisible).thenReturn(false);

        when(() => mockObj.utils).thenReturn(mockObj);

        // Act & Assert
        expect(app.connectionErrorText, 'errorText');
        expect(app.historyEnabled, true);
        expect(app.majorVersion, 7);
        expect(app.minorVersion, 60);
        expect(app.patchlevel, 2);
        expect(app.revision, 3);
        expect(app.newVisualDesign, true);

        // Asserts para los nuevos getters
        expect(app.buttonbarVisible, true);
        expect(app.statusbarVisible, false);
        expect(
          app.titlebarvisible,
          true,
        ); // Usando 'v' minúscula según tu getter
        expect(app.toolbarVisible, false);
        expect(app.utils, isA<GuiUtils>());
      },
    );

    test(
      'Debe asignar los valores de visibilidad (setters) correctamente al objeto base',
      () {
        // Act
        app.historyEnabled = false;
        app.buttonbarVisible = true;
        app.statusbarVisible = false;
        app.titlebarVisible = true;
        app.toolbarVisible = false;

        // Assert
        // Verificamos que la asignación en 'app' haya llamado al setter correspondiente en 'mockObj'
        verify(() => mockObj.historyEnabled = false).called(1);
        verify(() => mockObj.buttonbarVisible = true).called(1);
        verify(() => mockObj.statusbarVisible = false).called(1);
        verify(() => mockObj.titlebarVisible = true).called(1);
        verify(() => mockObj.toolbarVisible = false).called(1);
      },
    );

    test('Debe permitir cambiar allowSystemMessages', () {
      // Test Getter
      when(() => mockObj.allowSystemMessages).thenReturn(true);
      expect(app.allowSystemMessages, isTrue);

      // Test Setter
      app.allowSystemMessages = false;
      verify(() => mockObj.allowSystemMessages = false).called(1);
    });
  });

  group('GuiApplication - Sesiones y Conexiones', () {
    test('activeSession devuelve null si el objeto base devuelve null', () {
      when(() => mockObj.activeSession).thenReturn(null);
      expect(app.activeSession, isNull);
    });

    test(
      'activeSession devuelve una instancia de GuiSession si el objeto base tiene una',
      () {
        final mockSession =
            MockSapObject(); // Una sesión también es un ISapObject
        when(() => mockObj.activeSession).thenReturn(mockSession);

        final session = app.activeSession;

        expect(session, isNotNull);
        // Verificamos que el objeto interno de la sesión sea nuestro mockSession
        expect(session!.obj, equals(mockSession));
      },
    );

    test('openConnection debe propagar parámetros y envolver el resultado', () {
      final mockConn = MockSapObject();
      const desc = 'PRD - SAP ERP';

      when(
        () => mockObj.openConnection(desc, sync: true, raise: true),
      ).thenReturn(mockConn);

      final result = app.openConnection(desc);

      expect(result!.obj, equals(mockConn));
      verify(
        () => mockObj.openConnection(desc, sync: true, raise: true),
      ).called(1);
    });
  });

  group('GuiApplication - Historial', () {
    test(
      'addHistoryEntry llama al método del objeto base con los strings correctos',
      () {
        when(
          () => mockObj.addHistoryEntry('campo1', 'valor1'),
        ).thenReturn(true);

        final result = app.addHistoryEntry('campo1', 'valor1');

        expect(result, isTrue);
        verify(() => mockObj.addHistoryEntry('campo1', 'valor1')).called(1);
      },
    );

    test('dropHistory delega la llamada', () {
      when(() => mockObj.dropHistory()).thenReturn(true);
      app.dropHistory();
      verify(() => mockObj.dropHistory()).called(1);
    });
  });
  test('connections lanza excepción si children es null', () {
    when(() => mockObj.children).thenReturn(null);
    expect(() => app.connections, throwsException);
  });

  test('connections devuelve la colección si existe', () {
    final mockChildren = MockSapObject();
    when(() => mockObj.children).thenReturn(mockChildren);

    final coll = app.connections;
    expect(coll, isNotNull);
  });

  group('GuiApplication - Conexiones Avanzadas y Colecciones', () {
    test(
      'openConnectionByConnectionString debe envolver el objeto o retornar null',
      () {
        final mockConn = MockSapObject();
        const connStr = "SAP_CONNECTION_STRING";

        // 1. Probar éxito
        when(
          () => mockObj.openConnectionByConnectionString(
            connStr,
            sync: true,
            raise: true,
          ),
        ).thenReturn(mockConn);

        final result = app.openConnectionByConnectionString(connStr);

        expect(result, isNotNull);
        expect(result!.obj, equals(mockConn));
        verify(
          () => mockObj.openConnectionByConnectionString(
            connStr,
            sync: true,
            raise: true,
          ),
        ).called(1);

        // 2. Probar retorno null (Cubre la línea 93)
        when(
          () => mockObj.openConnectionByConnectionString(
            "invalid",
            sync: true,
            raise: true,
          ),
        ).thenReturn(null);

        expect(app.openConnectionByConnectionString("invalid"), isNull);
      },
    );

    test('createGuiCollection debe retornar una colección envuelta o null', () {
      final mockColObj = MockSapObject();

      // 1. Probar éxito
      when(() => mockObj.createGuiCollection()).thenReturn(mockColObj);

      final result = app.createGuiCollection();

      expect(result, isNotNull);
      expect(result, isA<GuiCollection>());
      verify(() => mockObj.createGuiCollection()).called(1);

      // 2. Probar retorno null (Cubre la línea 109)
      when(() => mockObj.createGuiCollection()).thenReturn(null);

      expect(app.createGuiCollection(), isNull);
    });
  });

  group('GuiApplication - Gestión de ROT e Ignore', () {
    test('registerROT delega la llamada y devuelve el resultado', () {
      when(() => mockObj.registerROT()).thenReturn(true);

      final result = app.registerROT();

      expect(result, isTrue);
      verify(() => mockObj.registerROT()).called(1);
    });

    test('revokeROT delega la llamada correctamente', () {
      app.revokeROT();

      verify(() => mockObj.revokeROT()).called(1);
    });

    test('ignore envía el handle de ventana correcto al objeto base', () {
      const windowHandle = 987654;

      app.ignore(windowHandle);

      verify(() => mockObj.ignore(windowHandle)).called(1);
    });
  });
}
