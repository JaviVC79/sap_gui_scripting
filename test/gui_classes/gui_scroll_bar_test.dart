import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_scroll_bar.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;

  setUp(() {
    mockObj = MockSapObject();
  });

  // ==========================================
  // GuiPicture
  // ==========================================
  group('GuiScrollBar', () {
    test('Propiedades de scrollBar', () {
      final scrollBar = GuiScrollbar(mockObj);

      when(() => mockObj.maximum).thenReturn(250);
      expect(scrollBar.maximum, 250);

      when(() => mockObj.minimum).thenReturn(10);
      expect(scrollBar.minimum, 10);

      when(() => mockObj.pageSize).thenReturn(40);
      expect(scrollBar.pageSize, 40);

      when(() => mockObj.range).thenReturn(20);
      expect(scrollBar.range, 20);

      when(() => mockObj.position).thenReturn(5);
      expect(scrollBar.position, 5);

      scrollBar.position = 10;
      verify(() => mockObj.position = 10).called(1);
    });
  });
}
