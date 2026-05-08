import 'package:sap_gui_scripting/enums/enum_gui_component_type_number.dart';
import 'package:sap_gui_scripting/gui_classes/gui_application.dart';
import 'package:sap_gui_scripting/gui_classes/gui_box.dart';
import 'package:sap_gui_scripting/gui_classes/gui_button.dart';
import 'package:sap_gui_scripting/gui_classes/gui_c_text_field.dart';
import 'package:sap_gui_scripting/gui_classes/gui_checkbox.dart';
import 'package:sap_gui_scripting/gui_classes/gui_component.dart';
import 'package:sap_gui_scripting/gui_classes/gui_connection.dart';
import 'package:sap_gui_scripting/gui_classes/gui_container.dart';
import 'package:sap_gui_scripting/gui_classes/gui_container_shell.dart';
import 'package:sap_gui_scripting/gui_classes/gui_custom_control.dart';
import 'package:sap_gui_scripting/gui_classes/gui_frame_window.dart';
import 'package:sap_gui_scripting/gui_classes/gui_label.dart';
import 'package:sap_gui_scripting/gui_classes/gui_main_window.dart';
import 'package:sap_gui_scripting/gui_classes/gui_menu.dart';
import 'package:sap_gui_scripting/gui_classes/gui_menubar.dart';
import 'package:sap_gui_scripting/gui_classes/gui_message_window.dart';
import 'package:sap_gui_scripting/gui_classes/gui_modal_window.dart';
import 'package:sap_gui_scripting/gui_classes/gui_ok_code_field.dart';
import 'package:sap_gui_scripting/gui_classes/gui_password_field.dart';
import 'package:sap_gui_scripting/gui_classes/gui_radio_button.dart';
import 'package:sap_gui_scripting/gui_classes/gui_scroll_bar.dart';
import 'package:sap_gui_scripting/gui_classes/gui_scroll_container.dart';
import 'package:sap_gui_scripting/gui_classes/gui_session.dart';
import 'package:sap_gui_scripting/gui_classes/gui_session_info.dart';
import 'package:sap_gui_scripting/gui_classes/gui_shell.dart';
import 'package:sap_gui_scripting/gui_classes/gui_status_bar_link.dart';
import 'package:sap_gui_scripting/gui_classes/gui_status_pane.dart';
import 'package:sap_gui_scripting/gui_classes/gui_statusbar.dart';
import 'package:sap_gui_scripting/gui_classes/gui_tab.dart';
import 'package:sap_gui_scripting/gui_classes/gui_tab_strip.dart';
import 'package:sap_gui_scripting/gui_classes/gui_table_column.dart';
import 'package:sap_gui_scripting/gui_classes/gui_table_control.dart';
import 'package:sap_gui_scripting/gui_classes/gui_table_row.dart';
import 'package:sap_gui_scripting/gui_classes/gui_text_field.dart';
import 'package:sap_gui_scripting/gui_classes/gui_titlebar.dart';
import 'package:sap_gui_scripting/gui_classes/gui_toolbar.dart';
import 'package:sap_gui_scripting/gui_classes/gui_user_area.dart';
import 'package:sap_gui_scripting/gui_classes/gui_v_component.dart';
import 'package:sap_gui_scripting/gui_classes/gui_v_container.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class GuiComponentCollection<T extends GuiComponent> {
  final ISapObject obj;
  GuiComponentCollection(this.obj);

  T elementAt(int index) {
    final element = obj.elementAt(index);
    if (element == null) throw Exception("Element not found");
    final componentType = GuiComponentType.values
        .where((e) => e.value == element.typeAsNumber)
        .firstOrNull;
    return _classByTypeNumber(componentType, element);
  }

  T item(dynamic index) {
    final element = obj.item(index);
    if (element == null) throw Exception("Item not found");
    final componentType = GuiComponentType.values
        .where((e) => e.value == element.typeAsNumber)
        .firstOrNull;
    return _classByTypeNumber(componentType, element);
  }

  dynamic _classByTypeNumber(
    GuiComponentType? componentType,
    ISapObject element,
  ) {
    return switch (componentType) {
      GuiComponentType.guiComponent => GuiComponent(element) as T,
      GuiComponentType.guiVComponent => GuiVComponent(element) as T,
      GuiComponentType.guiApplication => GuiApplication(element) as T,
      GuiComponentType.guiConnection => GuiConnection(element) as T,
      GuiComponentType.guiSession => GuiSession(element) as T,

      GuiComponentType.guiFrameWindow => GuiFrameWindow(element) as T,
      GuiComponentType.guiMainWindow => GuiMainWindow(element) as T,
      GuiComponentType.guiModalWindow => GuiModalWindow(element) as T,
      GuiComponentType.guiMessageWindow => GuiMessageWindow(element) as T,

      GuiComponentType.guiLabel => GuiLabel(element) as T,
      GuiComponentType.guiTextField => GuiTextField(element) as T,
      GuiComponentType.guiCTextField => GuiCTextField(element) as T,
      GuiComponentType.guiPasswordField => GuiPasswordField(element) as T,
      GuiComponentType.guiOkCodeField => GuiOkCodeField(element) as T,

      GuiComponentType.guiButton => GuiButton(element) as T,
      GuiComponentType.guiRadioButton => GuiRadioButton(element) as T,
      GuiComponentType.guiCheckBox => GuiCheckBox(element) as T,
      GuiComponentType.guiStatusPane => GuiStatusPane(element) as T,

      GuiComponentType.guiCustomControl => GuiCustomControl(element) as T,
      GuiComponentType.guiContainerShell => GuiContainerShell(element) as T,
      GuiComponentType.guiBox => GuiBox(element) as T,
      GuiComponentType.guiContainer => GuiContainer(element) as T,
      GuiComponentType.guiVContainer => GuiVContainer(element) as T,
      GuiComponentType.guiScrollContainer => GuiScrollContainer(element) as T,
      GuiComponentType.guiUserArea => GuiUserArea(element) as T,

      GuiComponentType.guiTableControl => GuiTableControl(element) as T,
      GuiComponentType.guiTableColumn => GuiTableColumn(element) as T,
      GuiComponentType.guiTableRow => GuiTableRow(element) as T,

      GuiComponentType.guiTabStrip => GuiTabStrip(element) as T,
      GuiComponentType.guiTab => GuiTab(element) as T,

      GuiComponentType.guiScrollbar => GuiScrollbar(element) as T,
      GuiComponentType.guiToolbar => GuiToolbar(element) as T,
      GuiComponentType.guiTitlebar => GuiTitlebar(element) as T,
      GuiComponentType.guiStatusbar => GuiStatusbar(element) as T,

      GuiComponentType.guiMenu => GuiMenu(element) as T,
      GuiComponentType.guiMenubar => GuiMenuBar(element) as T,

      GuiComponentType.guiSessionInfo => GuiSessionInfo(element) as T,
      GuiComponentType.guiShell => GuiShell(element) as T,
      GuiComponentType.guiStatusBarLink => GuiStatusBarLink(element) as T,

      _ => GuiComponent(element) as T,
    };
  }

  int get count => obj.count;
  int get length => obj.count;
  String get type => obj.type;
  int get typeAsNumber => obj.typeAsNumber;
}
