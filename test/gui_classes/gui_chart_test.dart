import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:sap_gui_scripting/gui_classes/gui_chart.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;

  setUp(() {
    mockObj = MockSapObject();
  });

  test(
    'GuiChart - valueChange debe pasar todos los parámetros correctamente',
    () {
      final chart = GuiChart(mockObj);

      chart.valueChange(1, 5, 'X-Val', 'Y-Val', true, 'ID_01', 'Z-Val', 0);

      verify(
        () => mockObj.valueChange(
          1,
          5,
          'X-Val',
          'Y-Val',
          true,
          'ID_01',
          'Z-Val',
          0,
        ),
      ).called(1);
    },
  );
}
