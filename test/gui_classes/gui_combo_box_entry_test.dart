import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_combo_box_entry.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;

  setUp(() {
    mockObj = MockSapObject();
  });

  test('GuiComboBoxEntry - Debe mapear key, pos y value', () {
    final entry = GuiComboBoxEntry(mockObj);
    when(() => mockObj.key).thenReturn('ES');
    when(() => mockObj.pos).thenReturn(2);
    when(() => mockObj.value).thenReturn('Spain');

    expect(entry.key, 'ES');
    expect(entry.pos, 2);
    expect(entry.value, 'Spain');
  });
}
