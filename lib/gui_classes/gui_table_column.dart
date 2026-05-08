import 'package:sap_gui_scripting/gui_classes/gui_component_collection.dart';

class GuiTableColumn extends GuiComponentCollection {
  GuiTableColumn(super.obj);

  String get title => obj.title;

  bool get fixed => obj.fixed;

  String get iconName => obj.iconName;

  String get defaultTooltip => obj.defaultTooltip;

  String get tooltip => obj.tooltip;

  bool get selected => obj.selected;

  set selected(bool value) => obj.selected = value;

  @override
  int get count => obj.count;

  @override
  int get length => obj.count;
}
