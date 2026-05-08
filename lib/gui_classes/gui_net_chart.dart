import 'package:sap_gui_scripting/gui_classes/gui_shell.dart';

class GuiNetChart extends GuiShell {
  GuiNetChart(super.obj);

  String getLinkContent(int linkId, int textId) =>
      obj.getLinkContent(linkId, textId);

  String getNodeContent(int nodeId, int textId) =>
      obj.getNodeContent(nodeId, textId);

  void sendData(String data) => obj.sendData(data);

  int get linkCount => obj.linkCountProperty;

  int get nodeCount => obj.nodeCount;
}
