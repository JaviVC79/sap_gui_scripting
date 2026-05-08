import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_dialog_shell.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;

  setUp(() {
    mockObj = MockSapObject();
  });

  // ==========================================
  // GuiDialogShell
  // ==========================================
  group('GuiDialogShell', () {
    test(
      'close() debe delegar al objeto base y title debe retornar el texto',
      () {
        final dialog = GuiDialogShell(mockObj);
        when(() => mockObj.title).thenReturn('Ventana de confirmación');

        dialog.close();
        verify(() => mockObj.close()).called(1);

        expect(dialog.title, 'Ventana de confirmación');
      },
    );
  });
}
