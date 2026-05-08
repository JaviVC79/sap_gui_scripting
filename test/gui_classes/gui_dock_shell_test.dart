import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_dock_shell.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;

  setUp(() {
    mockObj = MockSapObject();
  });

  // ==========================================
  // GuiDockShell
  // ==========================================
  group('GuiDockShell', () {
    test('Debe retornar descripción y propiedades físicas del dock', () {
      final dock = GuiDockShell(mockObj);

      when(() => mockObj.accDescription).thenReturn('Panel lateral SAP');
      when(() => mockObj.dockerIsVertical).thenReturn(true);
      when(() => mockObj.dockerPixelSize).thenReturn(250);

      expect(dock.accDescription, 'Panel lateral SAP');
      expect(dock.dockerIsVertical, isTrue);
      expect(dock.dockerPixelSize, 250);
    });
  });
}
