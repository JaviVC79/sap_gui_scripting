import 'package:mocktail/mocktail.dart';
import 'package:sap_gui_scripting/gui_classes/gui_component_collection.dart';
import 'package:sap_gui_scripting/gui_classes/gui_connection.dart';
import 'package:sap_gui_scripting/gui_classes/gui_session.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';
import 'package:test/test.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;
  late GuiConnection connection;

  setUp(() {
    mockObj = MockSapObject();
    connection = GuiConnection(mockObj);
  });

  group('GuiConnection - Lógica de Estado (Handle)', () {
    test('isValid debe ser true si el handle es distinto de 0', () {
      when(() => mockObj.handle).thenReturn(12345);
      expect(connection.isValid, isTrue);
      expect(connection.isInvalid, isFalse);
    });

    test('isInvalid debe ser true si el handle es 0', () {
      when(() => mockObj.handle).thenReturn(0);
      expect(connection.isValid, isFalse);
      expect(connection.isInvalid, isTrue);
    });
  });

  group('GuiConnection - Getters de Propiedades', () {
    test('Debe retornar los datos de conexión correctamente', () {
      when(() => mockObj.connectionString).thenReturn('/H/10.0.0.1/S/3200');
      when(() => mockObj.description).thenReturn('Sistema Producción');
      when(() => mockObj.disabledByServer).thenReturn(false);

      expect(connection.connectionString, '/H/10.0.0.1/S/3200');
      expect(connection.description, 'Sistema Producción');
      expect(connection.disabledByServer, isFalse);
    });
  });

  group('GuiConnection - Sesiones (Colecciones)', () {
    test(
      'children y sessions deben lanzar excepción si el objeto base devuelve null',
      () {
        when(() => mockObj.children).thenReturn(null);

        expect(() => connection.children, throwsException);
        expect(() => connection.sessions, throwsException);
      },
    );

    test(
      'sessions debe retornar una colección si el objeto base tiene hijos',
      () {
        final mockChildren = MockSapObject();
        when(() => mockObj.children).thenReturn(mockChildren);

        final result = connection.sessions;
        final children = connection.children;

        expect(result, isNotNull);
        // Verificamos que se llamó a .children en el objeto mock
        expect(children, isA<GuiComponentCollection<GuiSession>>());
        verify(() => mockObj.children).called(2);
      },
    );
  });

  group('GuiConnection - Métodos de Cierre', () {
    test(
      'closeConnection debe llamar al método correspondiente en el mock',
      () {
        // Los métodos void en mocktail no necesitan 'when' a menos que quieras
        // simular una excepción o comportamiento específico.

        connection.closeConnection();

        verify(() => mockObj.closeConnection()).called(1);
      },
    );

    test('closeSession debe pasar el ID correcto al objeto base', () {
      const sessionId = '/app/con[0]/ses[0]';

      connection.closeSession(sessionId);

      verify(() => mockObj.closeSession(sessionId)).called(1);
    });
  });
  test('Después de cerrar, el estado debería reflejar que es inválido', () {
    // Simulamos que al inicio el handle es 1
    when(() => mockObj.handle).thenReturn(1);
    expect(connection.isValid, isTrue);

    // Simulamos que después de cerrar, el handle pasa a ser 0
    connection.closeConnection();
    when(() => mockObj.handle).thenReturn(0);

    expect(connection.isValid, isFalse);
  });
}
