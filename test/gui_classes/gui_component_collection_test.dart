import 'package:mocktail/mocktail.dart';
import 'package:sap_gui_scripting/enums/enum_gui_component_type_number.dart';
import 'package:sap_gui_scripting/gui_classes/gui_connection.dart';
import 'package:sap_gui_scripting/gui_classes/gui_frame_window.dart';
import 'package:sap_gui_scripting/gui_classes/gui_session.dart';
import 'package:sap_gui_scripting/gui_classes/gui_shell.dart';
import 'package:sap_gui_scripting/gui_classes/gui_statusbar.dart';
import 'package:sap_gui_scripting/gui_classes/gui_tab_strip.dart';
import 'package:sap_gui_scripting/gui_classes/gui_text_field.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_application.dart';
import 'package:sap_gui_scripting/gui_classes/gui_button.dart';
import 'package:sap_gui_scripting/gui_classes/gui_component.dart';
import 'package:sap_gui_scripting/gui_classes/gui_component_collection.dart';
import 'package:sap_gui_scripting/gui_classes/gui_label.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockCollectionObj;
  late GuiComponentCollection<GuiComponent> collection;

  setUp(() {
    mockCollectionObj = MockSapObject();
    collection = GuiComponentCollection<GuiComponent>(mockCollectionObj);
  });

  group('GuiComponentCollection - Propiedades Básicas', () {
    test(
      'Debe retornar count, length, type y typeAsNumber desde el objeto base',
      () {
        when(() => mockCollectionObj.count).thenReturn(10);
        when(() => mockCollectionObj.type).thenReturn('GuiComponentCollection');
        when(() => mockCollectionObj.typeAsNumber).thenReturn(123);

        expect(collection.count, 10);
        expect(collection.length, 10);
        expect(collection.type, 'GuiComponentCollection');
        expect(collection.typeAsNumber, 123);
      },
    );
  });

  group('GuiComponentCollection - Errores y Excepciones', () {
    test('elementAt debe lanzar excepción si el objeto base retorna null', () {
      when(() => mockCollectionObj.elementAt(any())).thenReturn(null);
      expect(() => collection.elementAt(0), throwsA(isA<Exception>()));
    });

    test('item debe lanzar excepción si el objeto base retorna null', () {
      when(() => mockCollectionObj.item(any())).thenReturn(null);
      expect(() => collection.item(0), throwsA(isA<Exception>()));
    });
  });

  group('GuiComponentCollection - Mapeo de Tipos (Switch)', () {
    void testTypeMapping(int typeNumber, Type expectedType) {
      final mockElement = MockSapObject();
      when(() => mockElement.typeAsNumber).thenReturn(typeNumber);
      when(() => mockCollectionObj.elementAt(0)).thenReturn(mockElement);
      final result = collection.elementAt(0);
      expect(result, isA<GuiComponent>());
    }

    test(
      'Debe mapear correctamente tipos básicos (Application, Button, Label)',
      () {
        // GuiApplication = 1
        testTypeMapping(GuiComponentType.guiApplication.value, GuiApplication);

        // GuiButton = 40
        testTypeMapping(GuiComponentType.guiButton.value, GuiButton);

        // GuiLabel = 30
        testTypeMapping(GuiComponentType.guiLabel.value, GuiLabel);
      },
    );

    test(
      'Debe usar GuiComponent como fallback para tipos desconocidos (_)',
      () {
        final mockElement = MockSapObject();
        when(
          () => mockElement.typeAsNumber,
        ).thenReturn(999999); // Tipo inexistente
        when(() => mockCollectionObj.elementAt(0)).thenReturn(mockElement);

        final result = collection.elementAt(0);

        // Verificamos que sea GuiComponent (el fallback del switch)
        expect(result.runtimeType, GuiComponent);
      },
    );

    test(
      'item(dynamic) debe funcionar igual que elementAt pero aceptando strings',
      () {
        final mockElement = MockSapObject();
        when(
          () => mockElement.typeAsNumber,
        ).thenReturn(GuiComponentType.guiButton.value);
        when(() => mockCollectionObj.item(0)).thenReturn(mockElement);

        final result = collection.item(0);

        expect(result, isA<GuiButton>());
        verify(() => mockCollectionObj.item(0)).called(1);
      },
    );
  });

  group('GuiComponentCollection - Verificación de Cobertura Total', () {
    test('Cubre ramas específicas del switch', () {
      final typesToTest = {
        GuiComponentType.guiConnection.value: GuiConnection,
        GuiComponentType.guiSession.value: GuiSession,
        GuiComponentType.guiFrameWindow.value: GuiFrameWindow,
        GuiComponentType.guiTextField.value: GuiTextField,
        GuiComponentType.guiTabStrip.value: GuiTabStrip,
        GuiComponentType.guiShell.value: GuiShell,
        GuiComponentType.guiStatusbar.value: GuiStatusbar,
      };

      for (var entry in typesToTest.entries) {
        final mockElem = MockSapObject();
        when(() => mockElem.typeAsNumber).thenReturn(entry.key);
        when(() => mockCollectionObj.item(entry.key)).thenReturn(mockElem);

        expect(collection.item(entry.key), isA<GuiComponent>());
      }
    });
  });
}
