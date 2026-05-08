import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_calendar.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;

  setUp(() {
    mockObj = MockSapObject();
  });

  test(
    'GuiCalendar - contextMenu debe mapear a contextMenuCalendar con todos los argumentos',
    () {
      final calendar = GuiCalendar(mockObj);

      calendar.contextMenu(1, 10, 2, '20230101', '20230131');

      verify(
        () => mockObj.contextMenuCalendar(1, 10, 2, '20230101', '20230131'),
      ).called(1);
    },
  );
}
