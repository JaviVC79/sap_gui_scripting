import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class GuiCollection {
  final ISapObject obj;

  GuiCollection(this.obj);

  int get handle => obj.handle;
  int get count => obj.count;
  int get length => obj.length;
  String get type => obj.type;
  int get typeAsNumber => obj.typeAsNumber;
  void add(String item) => obj.add(item);
  ISapObject? elementAt(int index) => obj.elementAt(index);
  ISapObject? item(int index) => obj.item(index);
}
