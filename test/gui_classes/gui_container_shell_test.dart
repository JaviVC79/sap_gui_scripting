import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_container_shell.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;

  setUp(() {
    mockObj = MockSapObject();
  });

  // ==========================================
  // GuiContainerShell
  // ==========================================
  group('GuiContainerShell', () {
    test('Debe retornar accDescription', () {
      final shell = GuiContainerShell(mockObj);
      when(() => mockObj.accDescription).thenReturn('Contenedor Principal');

      expect(shell.accDescription, 'Contenedor Principal');
    });
  });
}
