import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_stage.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;
  late GuiStage stage;

  setUp(() {
    mockObj = MockSapObject();
    stage = GuiStage(mockObj);
  });

  group('GuiStage', () {
    test('Acciones en Stage deben delegar a métodos específicos', () {
      stage.contextMenu('ctx123');
      stage.doubleClick('item456');
      stage.selectItems('items_all');

      verify(() => mockObj.contextMenuInStage('ctx123')).called(1);
      verify(() => mockObj.doubleClickInStage('item456')).called(1);
      verify(() => mockObj.selectItemsInStage('items_all')).called(1);
    });
  });
}
