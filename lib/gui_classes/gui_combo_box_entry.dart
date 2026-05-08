import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class GuiComboBoxEntry {
  final ISapObject obj;

  GuiComboBoxEntry(this.obj);

  String get key => obj.key;
  int get pos => obj.pos;
  String get value => obj.value;
}
