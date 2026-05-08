import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_toolbar.dart';
import 'package:sap_gui_scripting/gui_classes/gui_button.dart';
import 'package:sap_gui_scripting/enums/enum_gui_component_type_number.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockToolbarObj;
  late MockSapObject mockChildrenCollection;

  setUp(() {
    mockToolbarObj = MockSapObject();
    mockChildrenCollection = MockSapObject();
  });

  group('GuiToolbar (Versión Robusta)', () {
    test('Debe retornar null si la propiedad children de SAP es nula', () {
      final toolbar = GuiToolbar(mockToolbarObj);

      // Simulamos que SAP devuelve null para la colección de hijos
      when(() => mockToolbarObj.children).thenReturn(null);

      expect(toolbar.childrenButtons, isNull);
    });

    test('Debe filtrar y retornar solo los componentes de tipo botón', () {
      final toolbar = GuiToolbar(mockToolbarObj);

      final mockBtn = MockSapObject();
      final mockOther = MockSapObject();

      // Mock del botón (tipo 40)
      when(
        () => mockBtn.typeAsNumber,
      ).thenReturn(GuiComponentType.guiButton.value);
      // Mock de otro objeto (ej. un separador o campo de texto)
      when(() => mockOther.typeAsNumber).thenReturn(999);

      // Configuramos la colección simulada
      when(() => mockChildrenCollection.count).thenReturn(2);
      when(() => mockChildrenCollection.item(0)).thenReturn(mockBtn);
      when(() => mockChildrenCollection.item(1)).thenReturn(mockOther);

      when(() => mockToolbarObj.children).thenReturn(mockChildrenCollection);

      final result = toolbar.childrenButtons;

      expect(result, isNotNull);
      expect(result!.length, 1);
      expect(result.first, isA<GuiButton>());
    });

    test(
      'Debe retornar una lista vacía si no se encuentran botones en la colección',
      () {
        final toolbar = GuiToolbar(mockToolbarObj);

        final mockOther = MockSapObject();
        when(() => mockOther.typeAsNumber).thenReturn(123); // No es tipo botón

        when(() => mockChildrenCollection.count).thenReturn(1);
        when(() => mockChildrenCollection.item(0)).thenReturn(mockOther);
        when(() => mockToolbarObj.children).thenReturn(mockChildrenCollection);

        final result = toolbar.childrenButtons;

        expect(result, isEmpty);
      },
    );

    test(
      'Debe manejar elementos nulos dentro de la colección de hijos sin fallar',
      () {
        final toolbar = GuiToolbar(mockToolbarObj);

        // Simulamos que SAP reporta un elemento pero al pedirlo devuelve null
        when(() => mockChildrenCollection.count).thenReturn(1);
        when(() => mockChildrenCollection.item(0)).thenReturn(null);
        when(() => mockToolbarObj.children).thenReturn(mockChildrenCollection);

        final result = toolbar.childrenButtons;

        expect(result, isEmpty);
      },
    );
  });
}
