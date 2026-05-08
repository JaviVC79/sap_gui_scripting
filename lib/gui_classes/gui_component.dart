import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class GuiComponent {
  final ISapObject obj;

  GuiComponent(this.obj);

  int get handle => obj.handle;

  bool get containerType => obj.containerType;
  String get id => obj.id;
  String get name => obj.name;
  String get type => obj.type;

  int get typeAsNumber => obj.typeAsNumber;

  GuiComponent? get parent {
    final p = obj.parent;
    return p != null ? GuiComponent(p) : null;
  }
}
