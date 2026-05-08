import 'package:sap_gui_scripting/gui_classes/gui_collection.dart';
import 'package:sap_gui_scripting/gui_classes/gui_shell.dart';

class GuiTree extends GuiShell {
  GuiTree(super.obj);

  void collapseNode(String nodeKey) => obj.collapseNode(nodeKey);
  void expandNode(String nodeKey) => obj.expandNode(nodeKey);
  void doubleClickNode(String nodeKey) => obj.doubleClickNode(nodeKey);
  void selectNode(String nodeKey) => obj.selectNode(nodeKey);
  void unselectNode(String nodeKey) => obj.unselectNode(nodeKey);
  void unselectAll() => obj.unselectAll();

  void changeCheckbox(String nodeKey, String itemName, bool checked) {
    obj.changeCheckbox(nodeKey, itemName, checked);
  }

  void clickLink(String nodeKey, String itemName) {
    obj.clickLink(nodeKey, itemName);
  }

  void doubleClickItem(String nodeKey, String itemName) {
    obj.doubleClickItem(nodeKey, itemName);
  }

  void pressButton(String nodeKey, String itemName) {
    obj.pressButton(nodeKey, itemName);
  }

  void selectItem(String nodeKey, String itemName) {
    obj.selectItem(nodeKey, itemName);
  }

  void ensureVisibleHorizontalItem(String nodeKey, String itemName) {
    obj.ensureVisibleHorizontalItem(nodeKey, itemName);
  }

  void defaultContextMenu() => obj.defaultContextMenu();
  void headerContextMenu(String headerName) =>
      obj.headerContextMenu(headerName);
  void itemContextMenu(String nodeKey, String itemName) =>
      obj.itemContextMenu(nodeKey, itemName);
  void nodeContextMenu(String nodeKey) => obj.nodeContextMenu(nodeKey);
  void pressKey(String key) => obj.pressKey(key);

  String getItemText(String key, String name) => obj.getItemText(key, name);
  String getNodeTextByKey(String key) => obj.getNodeTextByKey(key);
  String getNodeTextByPath(String path) => obj.getNodeTextByPath(path);

  bool getCheckBoxState(String nodeKey, String itemName) =>
      obj.getCheckBoxState(nodeKey, itemName);
  bool isFolder(String nodeKey) => obj.isFolder(nodeKey);
  bool isFolderExpandable(String nodeKey) => obj.isFolderExpandable(nodeKey);
  bool isFolderExpanded(String nodeKey) => obj.isFolderExpanded(nodeKey);

  /// Return tree type: 0 (Simple), 1 (List), 2 (Column)
  int getTreeType() => obj.getTreeType();

  List<String>? getAllNodeKeys() => obj.getAllNodeKeys();
  List<String>? getSelectedNodes() => obj.getSelectedNodes();
  List<String>? getColumnNames() => obj.getColumnNames();
  List<String>? getColumnHeaders() => obj.getColumnHeaders();

  List<String>? get columnOrder => obj.columnOrder;
  set columnOrder(GuiCollection order) => obj.columnOrder = order.handle;

  int get hierarchyHeaderWidth => obj.hierarchyHeaderWidth;
  set hierarchyHeaderWidth(int value) => obj.hierarchyHeaderWidth = value;

  String get selectedNode => obj.selectedNode;
  set selectedNode(String value) => obj.selectedNode = value;

  String get topNode => obj.topNode;
  set topNode(String value) => obj.topNode = value;
}
