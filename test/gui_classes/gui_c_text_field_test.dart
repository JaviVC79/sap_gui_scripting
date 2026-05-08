import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_c_text_field.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;

  setUp(() {
    mockObj = MockSapObject();
  });

  test('GuiCTextField - isListElement debe lanzar UnsupportedError', () {
    final ctxt = GuiCTextField(mockObj);

    expect(
      () => ctxt.isListElement,
      throwsA(
        isA<UnsupportedError>().having(
          (e) => e.message,
          'message',
          contains('no está disponible para GuiCTextField'),
        ),
      ),
    );
  });
}
