import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_custom_control.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;

  setUp(() {
    mockObj = MockSapObject();
  });

  // ==========================================
  // GuiCustomControl
  // ==========================================
  group('GuiCustomControl', () {
    test(
      'Debe retornar las métricas de caracteres (incluyendo mapeos invertidos)',
      () {
        final control = GuiCustomControl(mockObj);

        when(() => mockObj.charHeight).thenReturn(10);
        when(() => mockObj.charWidth).thenReturn(25);
        when(() => mockObj.charTop).thenReturn(5);
        when(() => mockObj.charLeft).thenReturn(50);

        expect(control.charHeight, 10);
        expect(control.charTop, 5);
        expect(control.charLeft, 50);
        expect(control.charWidth, 25);
      },
    );
  });
}
