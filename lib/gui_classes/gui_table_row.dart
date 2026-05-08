import 'package:sap_gui_scripting/gui_classes/gui_component_collection.dart';

class GuiTableRow extends GuiComponentCollection {
  GuiTableRow(super.obj);

  bool get selectable => obj.selectable;

  bool get selected => obj.selected;

  set selected(bool value) => obj.selected = value;

  @override
  int get count => obj.count;

  @override
  int get length => obj.count;
}
