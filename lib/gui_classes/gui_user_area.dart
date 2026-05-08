import 'package:sap_gui_scripting/gui_classes/gui_component.dart';
import 'package:sap_gui_scripting/gui_classes/gui_scroll_bar.dart';
import 'package:sap_gui_scripting/gui_classes/gui_v_container.dart';

class GuiUserArea extends GuiVContainer {
  GuiUserArea(super.obj);

  GuiComponent? findByLabel(String text, String type) {
    final object = obj.findByLabel(text, type);
    if (object == null) {
      throw Exception(
        "Component with label '$text' and type '$type' not found.",
      );
    }
    return GuiComponent(object);
  }

  void listNavigate(NavType navType) {
    obj.listNavigate(navType.name.toUpperCase());
  }

  GuiScrollbar? get horizontalScrollbar {
    return obj.horizontalScrollbar != null
        ? GuiScrollbar(obj.horizontalScrollbar!)
        : null;
  }

bool get isOTFPreview => obj.isOTFPreview;

  GuiScrollbar? get verticalScrollbar {
    return obj.verticalScrollbar != null
        ? GuiScrollbar(obj.verticalScrollbar!)
        : null;
  }
}

enum NavType {
  tab('TAB'),
  tabBack('TAB_BACK'),
  jumpOver('JUMP_OVER'),
  jumpOverBack('JUMP_OVER_BACK'),
  jumpOut('JUMP_OUT'),
  jumpOutBack('JUMP_OUT_BACK'),
  jumpSection('JUMP_SECTION'),
  jumpSectionBack('JUMP_SECTION_BACK');

  final String name;
  const NavType(this.name);
}
