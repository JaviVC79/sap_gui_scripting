import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_eai_viewer_2d.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;

  setUp(() {
    mockObj = MockSapObject();
  });

  // ==========================================
  // GuiEAIViewer2D
  // ==========================================
  group('GuiEAIViewer2D', () {
    test('Debe manejar anotaciones (get/set) y streams de redlining', () {
      final viewer = GuiEAIViewer2D(mockObj);

      // Probando Getters
      when(() => mockObj.annotationEnabled).thenReturn(true);
      when(() => mockObj.annotationMode).thenReturn(2);
      when(() => mockObj.redliningStream).thenReturn('stream_data_v1');

      expect(viewer.annotationEnabled, isTrue);
      expect(viewer.annotationMode, 2);
      expect(viewer.redliningStream, 'stream_data_v1');

      // Probando Setters
      viewer.annotationEnabled = false;
      viewer.annotationMode = 1;
      viewer.redliningStream = 'stream_data_v2';

      verify(() => mockObj.annotationEnabled = false).called(1);
      verify(() => mockObj.annotationMode = 1).called(1);
      verify(() => mockObj.redliningStream = 'stream_data_v2').called(1);

      // Probando Métodos
      viewer.annotationTextRequest('Texto de prueba');
      verify(() => mockObj.annotationTextRequest('Texto de prueba')).called(1);
    });
  });
}
