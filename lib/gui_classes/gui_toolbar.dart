import 'package:sap_gui_scripting/enums/enum_gui_component_type_number.dart';
import 'package:sap_gui_scripting/gui_classes/gui_button.dart';
import 'package:sap_gui_scripting/gui_classes/gui_v_container.dart';

class GuiToolbar extends GuiVContainer {
  GuiToolbar(super.obj);

  List<GuiButton>? get childrenButtons {
    final objects = obj.children;
    if (objects == null) return null;
    List<GuiButton> buttons = [];
    for (var i = 0; i < objects.count; i++) {
      final child = objects.item(i);
      if (child != null &&
          child.typeAsNumber == GuiComponentType.guiButton.value) {
        buttons.add(GuiButton(child));
      } // 40 = Button
    }
    return buttons;
  }
}
