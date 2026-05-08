import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_shell.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;

  setUp(() {
    mockObj = MockSapObject();
  });

  group('GuiShell - Métodos y Propiedades ActiveX', () {
    late GuiShell shell;

    setUp(() {
      shell = GuiShell(mockObj);
    });

    test('Métodos de menú contextual deben delegar correctamente', () {
      shell.selectContextMenuItem('SAVE');
      shell.selectContextMenuItemByPosition('1');
      shell.selectContextMenuItemByText('Aceptar');

      verify(() => mockObj.selectContextMenuItem('SAVE')).called(1);
      verify(() => mockObj.selectContextMenuItemByPosition('1')).called(1);
      verify(() => mockObj.selectContextMenuItemByText('Aceptar')).called(1);
    });

    test('Propiedades específicas deben retornar valores del objeto base', () {
      when(() => mockObj.accDescription).thenReturn('Descripción Shell');
      when(() => mockObj.dragDropSupported).thenReturn(true);
      when(() => mockObj.handle).thenReturn(98765);
      when(() => mockObj.subType).thenReturn('GridView');

      final mockEvents = MockSapObject();
      when(() => mockObj.ocxEvents).thenReturn(mockEvents);

      expect(shell.accDescription, 'Descripción Shell');
      expect(shell.dragDropSupported, isTrue);
      expect(shell.handle, 98765);
      expect(shell.subType, 'GridView');
      expect(shell.ocxEvents, equals(mockEvents));
    });

    test('ocxEvents debe poder ser null', () {
      when(() => mockObj.ocxEvents).thenReturn(null);
      expect(shell.ocxEvents, isNull);
    });
  });
}
