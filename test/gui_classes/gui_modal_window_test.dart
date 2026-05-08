import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_modal_window.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;

  setUp(() {
    mockObj = MockSapObject();
  });

  // ==========================================
  // GuiModalWindow
  // ==========================================
  group('GuiModalWindow', () {
    test('Manejo de propiedades de diálogo popup', () {
      final modal = GuiModalWindow(mockObj);
      when(() => mockObj.isPopupDialog).thenReturn(true);
      when(() => mockObj.popupDialog).thenReturn('X');

      expect(modal.isPopupDialog, isTrue);
      expect(modal.popupDialog, 'X');

      modal.isPopupDialog = false;
      modal.popupDialog = '';
      verify(() => mockObj.isPopupDialog = false).called(1);
      verify(() => mockObj.popupDialog = '').called(1);
    });
  });
}
