import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_v_container.dart';
import 'package:sap_gui_scripting/gui_classes/gui_component.dart';
import 'package:sap_gui_scripting/gui_classes/gui_component_collection.dart';
import 'package:sap_gui_scripting/gui_classes/gui_label.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;
  late GuiVContainer container;

  setUp(() {
    mockObj = MockSapObject();
    container = GuiVContainer(mockObj);
  });

  group('GuiVContainer - Búsqueda Avanzada', () {
    test('findByName y findByNameEx deben devolver GuiComponent o null', () {
      final mockRes = MockSapObject();

      // Caso éxito findByName
      when(() => mockObj.findByName('Name', 'Type')).thenReturn(mockRes);
      expect(container.findByName('Name', 'Type'), isA<GuiComponent>());

      // Caso null findByName
      when(() => mockObj.findByName('Wrong', 'Type')).thenReturn(null);
      expect(container.findByName('Wrong', 'Type'), isNull);

      // Caso éxito findByNameEx
      when(() => mockObj.findByNameEx('Name', 34)).thenReturn(mockRes);
      expect(container.findByNameEx('Name', 34), isA<GuiComponent>());
    });

    test(
      'findAllByName y findAllByNameEx deben devolver colección o lanzar excepción',
      () {
        final mockCol = MockSapObject();

        // Caso éxito findAllByName
        when(() => mockObj.findAllByName('Name', 'Type')).thenReturn(mockCol);
        expect(
          container.findAllByName('Name', 'Type'),
          isA<GuiComponentCollection>(),
        );

        // Caso error findAllByName (Línea 31-33)
        when(() => mockObj.findAllByName('Empty', 'Type')).thenReturn(null);
        expect(() => container.findAllByName('Empty', 'Type'), throwsException);

        // Caso éxito findAllByNameEx
        when(() => mockObj.findAllByNameEx('Name', 34)).thenReturn(mockCol);
        expect(
          container.findAllByNameEx('Name', 34),
          isA<GuiComponentCollection>(),
        );

        // Caso error findAllByNameEx (Línea 43-45)
        when(() => mockObj.findAllByNameEx('Empty', 34)).thenReturn(null);
        expect(() => container.findAllByNameEx('Empty', 34), throwsException);
      },
    );
  });

  group('GuiVContainer - Métodos y Propiedades Visuales', () {
    test('setFocus y visualize deben delegar correctamente', () {
      container.setFocus();
      verify(() => mockObj.setFocus()).called(1);

      when(() => mockObj.visualize(true, 'inner')).thenReturn(1);
      expect(container.visualize(true, 'inner'), 1);
    });

    test('dumpState debe devolver colección o lanzar excepción', () {
      final mockRes = MockSapObject();

      when(() => mockObj.dumpState('')).thenReturn(mockRes);
      expect(container.dumpState(), isA<GuiComponentCollection>());

      when(() => mockObj.dumpState('error')).thenReturn(null);
      expect(() => container.dumpState('error'), throwsException);
    });

    test('Debe manejar getters y setters de propiedades visuales', () {
      when(() => mockObj.text).thenReturn('Value');
      when(() => mockObj.left).thenReturn(10);
      when(() => mockObj.top).thenReturn(20);
      when(() => mockObj.width).thenReturn(100);
      when(() => mockObj.height).thenReturn(50);
      when(() => mockObj.screenLeft).thenReturn(15);
      when(() => mockObj.screenTop).thenReturn(25);
      when(() => mockObj.tooltip).thenReturn('Hint');
      when(() => mockObj.iconName).thenReturn('ICON_OK');
      when(() => mockObj.isSymbolFont).thenReturn(false);
      when(() => mockObj.modified).thenReturn(true);
      when(() => mockObj.changeable).thenReturn(true);

      expect(container.text, 'Value');
      expect(container.left, 10);
      expect(container.top, 20);
      expect(container.width, 100);
      expect(container.height, 50);
      expect(container.screenLeft, 15);
      expect(container.screenTop, 25);
      expect(container.tooltip, 'Hint');
      expect(container.iconName, 'ICON_OK');
      expect(container.isSymbolFont, isFalse);
      expect(container.modified, isTrue);
      expect(container.changeable, isTrue);

      container.text = 'New';
      container.modified = false;
      verify(() => mockObj.text = 'New').called(1);
      verify(() => mockObj.modified = false).called(1);
    });
  });

  group('GuiVContainer - Accesibilidad y Estructura', () {
    test(
      'accLabelCollection debe devolver colección de etiquetas o fallar',
      () {
        final mockCol = MockSapObject();

        when(() => mockObj.accLabelCollection).thenReturn(mockCol);
        expect(
          container.accLabelCollection,
          isA<GuiComponentCollection<GuiLabel>>(),
        );

        when(() => mockObj.accLabelCollection).thenReturn(null);
        expect(() => container.accLabelCollection, throwsException);
      },
    );

    test('Debe devolver textos de accesibilidad', () {
      when(() => mockObj.accText).thenReturn('AText');
      when(() => mockObj.accTextOnRequest).thenReturn('AReq');
      when(() => mockObj.accTooltip).thenReturn('ATip');
      when(() => mockObj.defaultTooltip).thenReturn('DTip');

      expect(container.accText, 'AText');
      expect(container.accTextOnRequest, 'AReq');
      expect(container.accTooltip, 'ATip');
      expect(container.defaultTooltip, 'DTip');
    });

    test('parentFrame debe devolver GuiComponent o null', () {
      final mockFrame = MockSapObject();

      when(() => mockObj.parentFrame).thenReturn(mockFrame);
      expect(container.parentFrame, isA<GuiComponent>());

      when(() => mockObj.parentFrame).thenReturn(null);
      expect(container.parentFrame, isNull);
    });
  });
}
