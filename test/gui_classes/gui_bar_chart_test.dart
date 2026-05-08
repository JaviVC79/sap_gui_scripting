import 'package:mocktail/mocktail.dart';
import 'package:sap_gui_scripting/gui_classes/gui_bar_chart.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';
import 'package:test/test.dart';

class MockSapObject extends Mock implements ISapObject {}

void main() {
  late MockSapObject mockObj;
  late GuiBarChart barChart;

  setUp(() {
    mockObj = MockSapObject();
    barChart = GuiBarChart(mockObj);
  });

  group('GuiBarChart - Propiedades', () {
    test('chartCount devuelve la cantidad correcta de gráficos', () {
      // Arrange
      when(() => mockObj.chartCount).thenReturn(3);

      // Act
      final result = barChart.chartCount;

      // Assert
      expect(result, 3);
      verify(() => mockObj.chartCount).called(1);
    });
  });

  group('GuiBarChart - Métodos de Extracción de Datos', () {
    test('barCount delega el chartId y devuelve el conteo', () {
      when(() => mockObj.barCount(1)).thenReturn(15);

      expect(barChart.barCount(1), 15);
      verify(() => mockObj.barCount(1)).called(1);
    });

    test('getBarContent envía los 3 parámetros y devuelve el texto', () {
      when(
        () => mockObj.getBarContent(1, 2, 3),
      ).thenReturn('Contenido de la barra');

      final result = barChart.getBarContent(1, 2, 3);

      expect(result, 'Contenido de la barra');
      verify(() => mockObj.getBarContent(1, 2, 3)).called(1);
    });

    test('getGridLineContent envía los 3 parámetros y devuelve el texto', () {
      when(
        () => mockObj.getGridLineContent(0, 1, 5),
      ).thenReturn('Línea de cuadrícula');

      final result = barChart.getGridLineContent(0, 1, 5);

      expect(result, 'Línea de cuadrícula');
      verify(() => mockObj.getGridLineContent(0, 1, 5)).called(1);
    });

    test('gridCount delega el chartId y devuelve el conteo', () {
      when(() => mockObj.gridCount(2)).thenReturn(10);

      expect(barChart.gridCount(2), 10);
      verify(() => mockObj.gridCount(2)).called(1);
    });

    test('linkCount delega el chartId y devuelve el conteo', () {
      when(() => mockObj.linkCount(0)).thenReturn(4);

      expect(barChart.linkCount(0), 4);
      verify(() => mockObj.linkCount(0)).called(1);
    });
  });

  group('GuiBarChart - Acciones', () {
    test('sendData pasa la cadena de texto correctamente al objeto base', () {
      // Para métodos void, solo actuamos y verificamos
      barChart.sendData('XML_DATA_STRING');

      verify(() => mockObj.sendData('XML_DATA_STRING')).called(1);
    });
  });
}
