import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class GuiScrollbar {
  final ISapObject obj;
  GuiScrollbar(this.obj);

  int get maximum => obj.maximum;

  int get minimum => obj.minimum;

  int get pageSize => obj.pageSize;

  int get range => obj.range;

  int get position => obj.position;

  set position(int value) {
    obj.position = value;
  }
}
