import 'package:sap_gui_scripting/gui_classes/gui_scroll_bar.dart';
import 'package:sap_gui_scripting/gui_classes/gui_v_container.dart';

class GuiScrollContainer extends GuiVContainer {
  GuiScrollContainer(super.obj);

  GuiScrollbar? get horizontalScrollbar {
    final scrollbarObj = obj.horizontalScrollbar;
    if (scrollbarObj == null) return null;
    return GuiScrollbar(scrollbarObj);
  }

  GuiScrollbar? get verticalScrollbar {
    final scrollbarObj = obj.verticalScrollbar;
    if (scrollbarObj == null) return null;
    return GuiScrollbar(scrollbarObj);
  }
}
