import 'dart:typed_data';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_frame_window.dart';
import 'package:sap_gui_scripting/gui_classes/gui_v_component.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;
  late GuiFrameWindow window;

  setUp(() {
    mockObj = MockSapObject();
    window = GuiFrameWindow(mockObj);
  });

  group('GuiFrameWindow - Gestión de Ventana', () {
    test(
      'Debe llamar a los métodos de estado de ventana (maximize, iconify, etc)',
      () {
        window.close();
        window.maximize();
        window.iconify();
        window.restore();

        verify(() => mockObj.close()).called(1);
        verify(() => mockObj.maximize()).called(1);
        verify(() => mockObj.iconify()).called(1);
        verify(() => mockObj.restore()).called(1);
      },
    );
  });

  group('GuiFrameWindow - Teclado y Navegación', () {
    test('Debe enviar VKeys y validar si están permitidas', () {
      when(() => mockObj.isVKeyAllowed(8)).thenReturn(true);

      window.sendVKey(8);
      final allowed = window.isVKeyAllowed(8);

      verify(() => mockObj.sendVKey(8)).called(1);
      expect(allowed, isTrue);
    });

    test('Debe delegar los accesos directos de navegación (Tab/Jump)', () {
      window.jumpBackward();
      window.jumpForward();
      window.tabBackward();
      window.tabForward();

      verify(() => mockObj.jumpBackward()).called(1);
      verify(() => mockObj.jumpForward()).called(1);
      verify(() => mockObj.tabBackward()).called(1);
      verify(() => mockObj.tabForward()).called(1);
    });
  });

  group('GuiFrameWindow - Imagen y Diálogos', () {
    test('compBitmap y hardCopy deben funcionar correctamente', () {
      when(() => mockObj.compBitmap('a.bmp', 'b.bmp')).thenReturn(0);
      when(() => mockObj.hardCopy('test.bmp')).thenReturn('OK');

      expect(window.compBitmap('a.bmp', 'b.bmp'), 0);
      expect(window.hardCopy('test.bmp'), 'OK');
    });

    test('hardCopyToMemory debe devolver Uint8List', () {
      final bytes = Uint8List.fromList([0, 1, 2, 3]);
      when(() => mockObj.hardCopyToMemory()).thenReturn(bytes);

      final result = window.hardCopyToMemory();

      expect(result, isA<Uint8List>());
      expect(result.length, 4);
    });

    test('showMessageBox debe enviar todos los argumentos', () {
      when(() => mockObj.showMessageBox('T', 'M', 1, 2)).thenReturn(1);

      final res = window.showMessageBox('T', 'M', 1, 2);

      expect(res, 1);
      verify(() => mockObj.showMessageBox('T', 'M', 1, 2)).called(1);
    });
  });

  group('GuiFrameWindow - Propiedades y Foco', () {
    test('elementVisualizationMode debe permitir get y set', () {
      when(() => mockObj.elementVisualizationMode).thenReturn(true);

      expect(window.elementVisualizationMode, isTrue);

      window.elementVisualizationMode = false;
      verify(() => mockObj.elementVisualizationMode = false).called(1);
    });

    test('guiFocus y systemFocus deben retornar GuiVComponent o null', () {
      final mockFocus = MockSapObject();

      // Caso éxito (No nulo)
      when(() => mockObj.guiFocus).thenReturn(mockFocus);
      when(() => mockObj.systemFocus).thenReturn(mockFocus);
      expect(window.guiFocus, isA<GuiVComponent>());
      expect(window.systemFocus, isA<GuiVComponent>());

      // Caso nulo (Líneas 89 y 95)
      when(() => mockObj.guiFocus).thenReturn(null);
      when(() => mockObj.systemFocus).thenReturn(null);
      expect(window.guiFocus, isNull);
      expect(window.systemFocus, isNull);
    });

    test('Debe retornar métricas de panel y estado iconic', () {
      when(() => mockObj.iconic).thenReturn(false);
      when(() => mockObj.workingPaneHeight).thenReturn(600);
      when(() => mockObj.workingPaneWidth).thenReturn(800);

      expect(window.iconic, isFalse);
      expect(window.workingPaneHeight, 600);
      expect(window.workingPaneWidth, 800);
    });
  });
}
