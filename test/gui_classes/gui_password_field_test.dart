import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_password_field.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;

  setUp(() {
    mockObj = MockSapObject();
  });

  // ==========================================
  // GuiPasswordField
  // ==========================================
  group('GuiPasswordField', () {
    test('Seguridad: texto siempre vacío y excepciones en historial', () {
      final pwd = GuiPasswordField(mockObj);

      expect(pwd.text, "");
      expect(pwd.displayedText, "");
      expect(() => pwd.isListElement, throwsUnimplementedError);
      expect(() => pwd.historyCurEntry, throwsUnimplementedError);
      expect(() => pwd.historyCurIndex, throwsUnimplementedError);
      expect(() => pwd.historyIsActive, throwsUnimplementedError);
      expect(() => pwd.historyList, throwsUnimplementedError);
    });
  });
}
