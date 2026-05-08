import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_component.dart';
import 'package:sap_gui_scripting/gui_classes/gui_component_collection.dart';
import 'package:sap_gui_scripting/gui_classes/gui_label.dart';
import 'package:sap_gui_scripting/gui_classes/gui_v_component.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;
  late GuiVComponent component;

  setUp(() {
    mockObj = MockSapObject();
    component = GuiVComponent(mockObj);
  });

  group('GuiVComponent - Métodos', () {
    test('setFocus debe delegar al objeto base', () {
      component.setFocus();
      verify(() => mockObj.setFocus()).called(1);
    });

    test('visualize debe delegar respetando los parámetros opcionales', () {
      // Con parámetro opcional
      when(() => mockObj.visualize(true, 'inner')).thenReturn(1);
      expect(component.visualize(true, 'inner'), 1);

      // Sin parámetro opcional (usa el default "")
      when(() => mockObj.visualize(false, '')).thenReturn(0);
      expect(component.visualize(false), 0);
    });

    test('dumpState debe retornar colección o lanzar excepción si es nulo', () {
      final mockRes = MockSapObject();

      // Camino de éxito
      when(() => mockObj.dumpState('inner')).thenReturn(mockRes);
      expect(
        component.dumpState('inner'),
        isA<GuiComponentCollection<GuiComponent>>(),
      );

      // Camino de error (Líneas 28-30)
      when(() => mockObj.dumpState('')).thenReturn(null);
      expect(() => component.dumpState(), throwsException);
    });
  });

  group('GuiVComponent - Propiedades Visuales y de Contenido', () {
    test('Debe mapear getters y setters numéricos y de texto', () {
      when(() => mockObj.left).thenReturn(10);
      when(() => mockObj.top).thenReturn(20);
      when(() => mockObj.width).thenReturn(100);
      when(() => mockObj.height).thenReturn(50);
      when(() => mockObj.screenLeft).thenReturn(1000);
      when(() => mockObj.screenTop).thenReturn(500);

      when(() => mockObj.text).thenReturn('Texto');
      when(() => mockObj.tooltip).thenReturn('Tooltip');
      when(() => mockObj.iconName).thenReturn('ICON_OK');

      when(() => mockObj.modified).thenReturn(true);
      when(() => mockObj.changeable).thenReturn(false);
      when(() => mockObj.isSymbolFont).thenReturn(true);

      // Asserts de lectura
      expect(component.left, 10);
      expect(component.top, 20);
      expect(component.width, 100);
      expect(component.height, 50);
      expect(component.screenLeft, 1000);
      expect(component.screenTop, 500);

      expect(component.text, 'Texto');
      expect(component.tooltip, 'Tooltip');
      expect(component.iconName, 'ICON_OK');

      expect(component.modified, isTrue);
      expect(component.changeable, isFalse);
      expect(component.isSymbolFont, isTrue);

      // Asserts de escritura (Setters)
      component.text = 'Nuevo texto';
      component.modified = false;

      verify(() => mockObj.text = 'Nuevo texto').called(1);
      verify(() => mockObj.modified = false).called(1);
    });
  });

  group('GuiVComponent - Accesibilidad y Jerarquía', () {
    test('accLabelCollection debe retornar colección o lanzar excepción', () {
      final mockCol = MockSapObject();

      // Camino de éxito
      when(() => mockObj.accLabelCollection).thenReturn(mockCol);
      expect(
        component.accLabelCollection,
        isA<GuiComponentCollection<GuiLabel>>(),
      );

      // Camino de error (Líneas 78-80)
      when(() => mockObj.accLabelCollection).thenReturn(null);
      expect(() => component.accLabelCollection, throwsException);
    });

    test('Debe mapear los textos de accesibilidad', () {
      when(() => mockObj.accText).thenReturn('AText');
      when(() => mockObj.accTextOnRequest).thenReturn('AReq');
      when(() => mockObj.accTooltip).thenReturn('ATip');
      when(() => mockObj.defaultTooltip).thenReturn('DTip');

      expect(component.accText, 'AText');
      expect(component.accTextOnRequest, 'AReq');
      expect(component.accTooltip, 'ATip');
      expect(component.defaultTooltip, 'DTip');
    });

    test('parentFrame debe retornar un GuiComponent envuelto o null', () {
      final mockFrame = MockSapObject();

      // Camino con objeto (Línea 97 verdadera)
      when(() => mockObj.parentFrame).thenReturn(mockFrame);
      expect(component.parentFrame, isA<GuiComponent>());

      // Camino nulo (Línea 97 falsa)
      when(() => mockObj.parentFrame).thenReturn(null);
      expect(component.parentFrame, isNull);
    });
  });
}
