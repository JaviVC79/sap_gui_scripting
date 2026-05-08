import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_net_chart.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;

  setUp(() {
    mockObj = MockSapObject();
  });

  // ==========================================
  // GuiNetChart
  // ==========================================
  group('GuiNetChart', () {
    test('Obtención de contenido y envío de datos', () {
      final netChart = GuiNetChart(mockObj);
      when(() => mockObj.getLinkContent(1, 2)).thenReturn('LinkData');
      when(() => mockObj.getNodeContent(3, 4)).thenReturn('NodeData');
      when(() => mockObj.linkCountProperty).thenReturn(10);
      when(() => mockObj.nodeCount).thenReturn(5);

      expect(netChart.getLinkContent(1, 2), 'LinkData');
      expect(netChart.getNodeContent(3, 4), 'NodeData');
      expect(netChart.linkCount, 10); // Valida mapeo a linkCountProperty
      expect(netChart.nodeCount, 5);

      netChart.sendData('XML_DATA');
      verify(() => mockObj.sendData('XML_DATA')).called(1);
    });
  });
}
