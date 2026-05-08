import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_scroll_container.dart';
import 'package:sap_gui_scripting/gui_classes/gui_scroll_bar.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;

  setUp(() {
    mockObj = MockSapObject();
  });

  group('GuiScrollContainer - Gestión de Scrollbars', () {
    late GuiScrollContainer scrollContainer;

    setUp(() {
      scrollContainer = GuiScrollContainer(mockObj);
    });

    test('Debe retornar GuiScrollbar cuando las barras existen', () {
      final mockHScroll = MockSapObject();
      final mockVScroll = MockSapObject();

      when(() => mockObj.horizontalScrollbar).thenReturn(mockHScroll);
      when(() => mockObj.verticalScrollbar).thenReturn(mockVScroll);

      expect(scrollContainer.horizontalScrollbar, isA<GuiScrollbar>());
      expect(scrollContainer.verticalScrollbar, isA<GuiScrollbar>());
    });

    test('Debe retornar null cuando las barras no existen', () {
      when(() => mockObj.horizontalScrollbar).thenReturn(null);
      when(() => mockObj.verticalScrollbar).thenReturn(null);

      expect(scrollContainer.horizontalScrollbar, isNull);
      expect(scrollContainer.verticalScrollbar, isNull);
    });
  });
}
