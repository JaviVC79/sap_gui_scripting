import 'package:sap_gui_scripting/gui_classes/gui_status_bar_link.dart';
import 'package:sap_gui_scripting/gui_classes/gui_v_component.dart';

class GuiStatusPane extends GuiVComponent {
  GuiStatusPane(super.obj);

  GuiStatusBarLink? get children {
    final object = obj.children;
    if (object == null) return null;
    return GuiStatusBarLink(object);
  }
}
