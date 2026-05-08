import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_splitter_container.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;

  setUp(() {
    mockObj = MockSapObject();
  });

  group('GuiSplitterContainer', () {
    test('Debe manejar la visibilidad vertical y posición del sash', () {
      final splitter = GuiSplitterContainer(mockObj);

      when(() => mockObj.isVertical).thenReturn(true);
      when(() => mockObj.sashPosition).thenReturn(50);

      expect(splitter.isVertical, isTrue);
      expect(splitter.sashPosition, 50);

      splitter.sashPosition = 75;
      verify(() => mockObj.sashPosition = 75).called(1);
    });
  });
}
