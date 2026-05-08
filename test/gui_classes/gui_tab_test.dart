import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_tab.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  test('GuiTab - scrollToLeft y select deben delegar al objeto base', () {
    final mockObj = MockSapObject();
    final tab = GuiTab(mockObj);

    tab.scrollToLeft();
    tab.select();

    verify(() => mockObj.scrollToLeft()).called(1);
    verify(() => mockObj.select()).called(1);
  });
}
