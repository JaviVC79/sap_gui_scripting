import 'dart:ffi';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_html_viewer.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;

  setUp(() {
    mockObj = MockSapObject();
  });

  // ==========================================
  // GuiHTMLViewer
  // ==========================================
  group('GuiHTMLViewer', () {
    test('Debe delegar llamadas a métodos y manejar punteros COM', () {
      final htmlViewer = GuiHTMLViewer(mockObj);

      // Simular métodos
      when(() => mockObj.getBrowerControlType()).thenReturn(1);
      htmlViewer.contextMenu();
      htmlViewer.sapEvent('frame1', 'data', 'http://url.com');

      verify(() => mockObj.contextMenu()).called(1);
      verify(
        () => mockObj.sapEvent('frame1', 'data', 'http://url.com'),
      ).called(1);
      expect(htmlViewer.getBrowerControlType(), 1);

      // Simular propiedades y punteros FFI
      when(
        () => mockObj.browserHandle,
      ).thenReturn(nullptr); // Usamos nullptr de dart:ffi
      when(() => mockObj.documentComplete).thenReturn(4);

      expect(htmlViewer.browserHandle, nullptr);
      expect(htmlViewer.documentComplete, 4);
    });
  });
}
