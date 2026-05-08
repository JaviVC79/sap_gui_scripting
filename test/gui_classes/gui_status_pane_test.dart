import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_status_pane.dart';
import 'package:sap_gui_scripting/gui_classes/gui_status_bar_link.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;
  late GuiStatusPane pane;

  setUp(() {
    mockObj = MockSapObject();
    pane = GuiStatusPane(mockObj);
  });

  test('children debe retornar GuiStatusBarLink si el objeto existe', () {
    final mockChild = MockSapObject();
    when(() => mockObj.children).thenReturn(mockChild);

    expect(pane.children, isA<GuiStatusBarLink>());
  });

  test('children debe retornar null si no hay objeto hijo', () {
    when(() => mockObj.children).thenReturn(null);

    expect(pane.children, isNull);
  });
}
