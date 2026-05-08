import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_status_bar_link.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  test('GuiStatusBarLink - press() debe delegar al objeto base', () {
    final mockObj = MockSapObject();
    final link = GuiStatusBarLink(mockObj);

    link.press();
    verify(() => mockObj.press()).called(1);
  });
}
