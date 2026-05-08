import 'package:sap_gui_scripting/gui_classes/gui_shell.dart';

class GuiBarChart extends GuiShell {
  GuiBarChart(super.obj);

  int get chartCount => obj.chartCount;

  int barCount(int chartId) => obj.barCount(chartId);

  String getBarContent(int chartId, int barId, int textId) =>
      obj.getBarContent(chartId, barId, textId);

  String getGridLineContent(int chartId, int gridlineId, int lineId) =>
      obj.getGridLineContent(chartId, gridlineId, lineId);

  int gridCount(int chartId) => obj.gridCount(chartId);

  int linkCount(int chartId) => obj.linkCount(chartId);

  void sendData(String data) => obj.sendData(data);
}
