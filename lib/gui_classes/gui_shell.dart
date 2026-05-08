import 'package:sap_gui_scripting/gui_classes/gui_v_container.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class GuiShell extends GuiVContainer {
  GuiShell(super.obj);

  void selectContextMenuItem(String functionCode) {
    obj.selectContextMenuItem(functionCode);
  }

  void selectContextMenuItemByPosition(String positionDesc) {
    obj.selectContextMenuItemByPosition(positionDesc);
  }

  void selectContextMenuItemByText(String text) {
    obj.selectContextMenuItemByText(text);
  }

  String get accDescription => obj.accDescription;

  bool get dragDropSupported => obj.dragDropSupported;

  @override
  int get handle => obj.handle;

  String get subType => obj.subType;

  ISapObject? get ocxEvents => obj.ocxEvents;
}
