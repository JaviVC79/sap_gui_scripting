import 'package:sap_gui_scripting/gui_classes/gui_tab.dart';
import 'package:sap_gui_scripting/gui_classes/gui_v_container.dart';

class GuiTabStrip extends GuiVContainer {
  GuiTabStrip(super.obj);

  int get charHeight => obj.charHeight;
  int get charLeft => obj.charLeft;
  int get charTop => obj.charTop;
  int get charWidth => obj.charWidth;

  GuiTab? get leftTab {
    final tabObj = obj.leftTab;
    return tabObj != null ? GuiTab(tabObj) : null;
  }

  GuiTab? get selectedTab {
    final tabObj = obj.selectedTab;
    return tabObj != null ? GuiTab(tabObj) : null;
  }
}
