import 'package:sap_gui_scripting/gui_classes/gui_v_container.dart';

class GuiDialogShell extends GuiVContainer {
  GuiDialogShell(super.obj);

  void close() => obj.close();

  String get title => obj.title;
}
