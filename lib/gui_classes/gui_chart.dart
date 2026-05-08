import 'package:sap_gui_scripting/gui_classes/gui_shell.dart';

class GuiChart extends GuiShell {
  GuiChart(super.obj);

  void valueChange(
    int series,
    int point,
    String xValue,
    String yValue,
    bool dataChange,
    String id,
    String zValue,
    int changeFlag,
  ) => obj.valueChange(
    series,
    point,
    xValue,
    yValue,
    dataChange,
    id,
    zValue,
    changeFlag,
  );
}
