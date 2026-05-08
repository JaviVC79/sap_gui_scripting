import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_main_window.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;

  setUp(() {
    mockObj = MockSapObject();
  });

  // ==========================================
  // GuiMainWindow
  // ==========================================
  group('GuiMainWindow', () {
    test('Debe delegar el redimensionamiento del panel de trabajo', () {
      final mainWindow = GuiMainWindow(mockObj);

      mainWindow.resizeWorkingPane(800, 600, true);
      mainWindow.resizeWorkingPaneEx(1024, 768, false);

      verify(() => mockObj.resizeWorkingPane(800, 600, true)).called(1);
      verify(() => mockObj.resizeWorkingPaneEx(1024, 768, false)).called(1);
    });

    test('Debe permitir obtener y establecer la visibilidad de las barras', () {
      final mainWindow = GuiMainWindow(mockObj);

      // Configurar Getters
      when(() => mockObj.buttonbarVisible).thenReturn(true);
      when(() => mockObj.statusbarVisible).thenReturn(false);
      when(() => mockObj.titlebarVisible).thenReturn(true);
      when(() => mockObj.toolbarVisible).thenReturn(false);

      expect(mainWindow.buttonbarVisible, isTrue);
      expect(mainWindow.statusbarVisible, isFalse);
      expect(mainWindow.titlebarVisible, isTrue);
      expect(mainWindow.toolbarVisible, isFalse);

      // Verificar Setters
      mainWindow.buttonbarVisible = false;
      mainWindow.statusbarVisible = true;
      mainWindow.titlebarVisible = false;
      mainWindow.toolbarVisible = true;

      verify(() => mockObj.buttonbarVisible = false).called(1);
      verify(() => mockObj.statusbarVisible = true).called(1);
      verify(() => mockObj.titlebarVisible = false).called(1);
      verify(() => mockObj.toolbarVisible = true).called(1);
    });
  });
}
