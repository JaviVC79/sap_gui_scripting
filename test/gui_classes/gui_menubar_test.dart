import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_menubar.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;

  setUp(() {
    mockObj = MockSapObject();
  });

  // ==========================================
  // GuiMenuBar
  // ==========================================
  group('GuiMenuBar', () {
    test(
      'Todas las propiedades no soportadas deben lanzar UnimplementedError',
      () {
        final menuBar = GuiMenuBar(mockObj);

        expect(() => menuBar.parentFrame, throwsUnimplementedError);
        expect(() => menuBar.isSymbolFont, throwsUnimplementedError);
        expect(() => menuBar.accTooltip, throwsUnimplementedError);
        expect(() => menuBar.accTextOnRequest, throwsUnimplementedError);
        expect(() => menuBar.accText, throwsUnimplementedError);
        expect(() => menuBar.accLabelCollection, throwsUnimplementedError);
      },
    );
  });
}
