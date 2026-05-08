import 'package:mocktail/mocktail.dart';
import 'package:sap_gui_scripting/gui_classes/gui_collection.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockISapObject extends Mock implements ISapObject {}

void main() {
  late MockISapObject mockSapObject;
  late GuiCollection collection;

  setUp(() {
    mockSapObject = MockISapObject();
    collection = GuiCollection(mockSapObject);
  });

  group('GuiCollection - Propiedades Delegadas', () {
    test('handle debe retornar el handle del objeto subyacente', () {
      when(() => mockSapObject.handle).thenReturn(123);
      expect(collection.handle, 123);
      verify(() => mockSapObject.handle).called(1);
    });

    test('count y length deben retornar los valores del objeto subyacente', () {
      when(() => mockSapObject.count).thenReturn(5);
      when(() => mockSapObject.length).thenReturn(5);

      expect(collection.count, 5);
      expect(collection.length, 5);

      verify(() => mockSapObject.count).called(1);
      verify(() => mockSapObject.length).called(1);
    });

    test('type y typeAsNumber deben delegar correctamente', () {
      when(() => mockSapObject.type).thenReturn("GuiCollection");
      when(() => mockSapObject.typeAsNumber).thenReturn(34);

      expect(collection.type, "GuiCollection");
      expect(collection.typeAsNumber, 34);

      verify(() => mockSapObject.type).called(1);
      verify(() => mockSapObject.typeAsNumber).called(1);
    });
  });

  group('GuiCollection - Métodos', () {
    test('add debe llamar a obj.add con el item correcto', () {
      const itemToAdd = "NuevoItem";
      // Mocktail requiere configurar el retorno incluso si es void para evitar errores
      when(() => mockSapObject.add(itemToAdd)).thenReturn(null);

      collection.add(itemToAdd);

      verify(() => mockSapObject.add(itemToAdd)).called(1);
    });

    test('elementAt debe retornar el ISapObject correspondiente', () {
      final mockElement = MockISapObject();
      when(() => mockSapObject.elementAt(0)).thenReturn(mockElement);

      final result = collection.elementAt(0);

      expect(result, mockElement);
      verify(() => mockSapObject.elementAt(0)).called(1);
    });

    test('item debe delegar a obj.item (Detector de recursión infinita)', () {
      final mockElement = MockISapObject();

      // Si en tu código tienes: item(index) => item(index);
      // este test lanzará un Stack Overflow y fallará.
      when(() => mockSapObject.item(1)).thenReturn(mockElement);

      final result = collection.item(1);

      expect(result, mockElement);
      verify(() => mockSapObject.item(1)).called(1);
    });

    test(
      'elementAt e item deben retornar null si el objeto subyacente retorna null',
      () {
        when(() => mockSapObject.elementAt(any())).thenReturn(null);
        when(() => mockSapObject.item(any())).thenReturn(null);

        expect(collection.elementAt(99), isNull);
        expect(collection.item(99), isNull);
      },
    );
  });
}
