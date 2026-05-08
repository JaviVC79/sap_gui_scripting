import 'package:sap_gui_scripting/enums/enum_gui_component_type_number.dart';
import 'package:sap_gui_scripting/gui_classes/gui_bar_chart.dart';
import 'package:sap_gui_scripting/gui_classes/gui_box.dart';
import 'package:sap_gui_scripting/gui_classes/gui_button.dart';
import 'package:sap_gui_scripting/gui_classes/gui_c_text_field.dart';
import 'package:sap_gui_scripting/gui_classes/gui_calendar.dart';
import 'package:sap_gui_scripting/gui_classes/gui_chart.dart';
import 'package:sap_gui_scripting/gui_classes/gui_checkbox.dart';
import 'package:sap_gui_scripting/gui_classes/gui_combo_box.dart';
import 'package:sap_gui_scripting/gui_classes/gui_combo_box_control.dart';
import 'package:sap_gui_scripting/gui_classes/gui_combo_box_entry.dart';
import 'package:sap_gui_scripting/gui_classes/gui_component.dart';
import 'package:sap_gui_scripting/gui_classes/gui_component_collection.dart';
import 'package:sap_gui_scripting/gui_classes/gui_container_shell.dart';
import 'package:sap_gui_scripting/gui_classes/gui_custom_control.dart';
import 'package:sap_gui_scripting/gui_classes/gui_dialog_shell.dart';
import 'package:sap_gui_scripting/gui_classes/gui_dock_shell.dart';
import 'package:sap_gui_scripting/gui_classes/gui_eai_viewer_2d.dart';
import 'package:sap_gui_scripting/gui_classes/gui_eai_viewer_3d.dart';
import 'package:sap_gui_scripting/gui_classes/gui_frame_window.dart';
import 'package:sap_gui_scripting/gui_classes/gui_gos_shell.dart';
import 'package:sap_gui_scripting/gui_classes/gui_grid_view.dart';
import 'package:sap_gui_scripting/gui_classes/gui_html_viewer.dart';
import 'package:sap_gui_scripting/gui_classes/gui_input_field_control.dart';
import 'package:sap_gui_scripting/gui_classes/gui_label.dart';
import 'package:sap_gui_scripting/gui_classes/gui_main_window.dart';
import 'package:sap_gui_scripting/gui_classes/gui_menu.dart';
import 'package:sap_gui_scripting/gui_classes/gui_menubar.dart';
import 'package:sap_gui_scripting/gui_classes/gui_message_window.dart';
import 'package:sap_gui_scripting/gui_classes/gui_net_chart.dart';
import 'package:sap_gui_scripting/gui_classes/gui_office_integration.dart';
import 'package:sap_gui_scripting/gui_classes/gui_ok_code_field.dart';
import 'package:sap_gui_scripting/gui_classes/gui_picture.dart';
import 'package:sap_gui_scripting/gui_classes/gui_radio_button.dart';
import 'package:sap_gui_scripting/gui_classes/gui_sap_chart.dart';
import 'package:sap_gui_scripting/gui_classes/gui_scroll_bar.dart';
import 'package:sap_gui_scripting/gui_classes/gui_scroll_container.dart';
import 'package:sap_gui_scripting/gui_classes/gui_shell.dart';
import 'package:sap_gui_scripting/gui_classes/gui_simple_container.dart';
import 'package:sap_gui_scripting/gui_classes/gui_split.dart';
import 'package:sap_gui_scripting/gui_classes/gui_splitter_container.dart';
import 'package:sap_gui_scripting/gui_classes/gui_stage.dart';
import 'package:sap_gui_scripting/gui_classes/gui_status_bar_link.dart';
import 'package:sap_gui_scripting/gui_classes/gui_status_pane.dart';
import 'package:sap_gui_scripting/gui_classes/gui_statusbar.dart';
import 'package:sap_gui_scripting/gui_classes/gui_tab.dart';
import 'package:sap_gui_scripting/gui_classes/gui_tab_strip.dart';
import 'package:sap_gui_scripting/gui_classes/gui_table_control.dart';
import 'package:sap_gui_scripting/gui_classes/gui_text_field.dart';
import 'package:sap_gui_scripting/gui_classes/gui_textedit.dart';
import 'package:sap_gui_scripting/gui_classes/gui_titlebar.dart';
import 'package:sap_gui_scripting/gui_classes/gui_toolbar.dart';
import 'package:sap_gui_scripting/gui_classes/gui_toolbar_control.dart';
import 'package:sap_gui_scripting/gui_classes/gui_tree.dart';
import 'package:sap_gui_scripting/gui_classes/gui_user_area.dart';
import 'package:sap_gui_scripting/gui_classes/gui_vh_view_switch.dart';
import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class GuiContainer extends GuiComponent {
  GuiContainer(super.obj);

  GuiComponentCollection get children {
    final childrenObj = obj.children;
    if (childrenObj == null) {
      throw Exception("No children found for this container");
    }
    return GuiComponentCollection<GuiComponent>(childrenObj);
  }

  ISapObject? findById(String id, {bool raise = true}) {
    final childObj = obj.findById(id);
    if (childObj == null) {
      if (raise) throw Exception("Element with ID '$id' not found.");
      return null;
    }
    return childObj;
  }

  T? _findGeneric<T extends GuiComponent>(
    String id,
    T Function(ISapObject) factory,
    bool raise, {
    int? expectedSapType,
    String? expectedSapSubType,
  }) {
    final childObj = obj.findById(id);
    if (childObj == null) {
      if (raise) throw Exception("Element with ID '$id' not found.");
      return null;
    }
    if (expectedSapType != null) {
      final actualType = childObj.typeAsNumber;
      if (actualType != expectedSapType) {
        if (raise) {
          throw Exception(
            "Type mismatch for ID '$id'. Expected type '$expectedSapType', got '$actualType'.",
          );
        }
        return null;
      }
    }
    if (expectedSapSubType != null) {
      final actualSubType = childObj.subType;
      if (actualSubType != expectedSapSubType) {
        if (raise) {
          throw Exception(
            "SubType mismatch for ID '$id'. Expected subtype '$expectedSapSubType', got '$actualSubType'.",
          );
        }
        return null;
      }
    }
    return factory(childObj);
  }

  V? _findGenericNoGuiComponent<V extends dynamic>(
    String id,
    V Function(ISapObject) factory,
    bool raise, {
    int? expectedSapType,
    String? expectedSapSubType,
  }) {
    final childObj = obj.findById(id);
    if (childObj == null) {
      if (raise) throw Exception("Element with ID '$id' not found.");
      return null;
    }
    if (expectedSapType != null) {
      final actualType = childObj.typeAsNumber;
      if (actualType != expectedSapType) {
        if (raise) {
          throw Exception(
            "Type mismatch for ID '$id'. Expected type '$expectedSapType', got '$actualType'.",
          );
        }
        return null;
      }
    }
    if (expectedSapSubType != null) {
      final actualSubType = childObj.subType;
      if (actualSubType != expectedSapSubType) {
        if (raise) {
          throw Exception(
            "SubType mismatch for ID '$id'. Expected subtype '$expectedSapSubType', got '$actualSubType'.",
          );
        }
        return null;
      }
    }
    return factory(childObj);
  }

  GuiBox? findBox(String id, {bool raise = true}) {
    return _findGeneric<GuiBox>(
      id,
      (s) => GuiBox(s),
      raise,
      expectedSapType: GuiComponentType.guiBox.value, // 62
    );
  }

  GuiChart? findChart(String id, {bool raise = true}) {
    return _findGeneric<GuiChart>(
      id,
      (s) => GuiChart(s),
      raise,
      expectedSapType: GuiComponentType.guiShell.value, // 122
    );
  }

  GuiCheckBox? findCheckBox(String id, {bool raise = true}) {
    return _findGeneric<GuiCheckBox>(
      id,
      (s) => GuiCheckBox(s),
      raise,
      expectedSapType: GuiComponentType.guiCheckBox.value, // 42
    );
  }

  GuiComboBoxEntry? findComboBoxEntry(String id, {bool raise = true}) {
    final entryObj = obj.findById(id);
    if (entryObj == null) {
      if (raise) throw Exception("Element with ID '$id' not found.");
      return null;
    }
    return GuiComboBoxEntry(entryObj);
  }

  GuiComboBoxControl? findComboBoxControl(String id, {bool raise = true}) {
    final entryObj = obj.findById(id);
    if (entryObj == null) {
      if (raise) throw Exception("Element with ID '$id' not found.");
      return null;
    }
    return GuiComboBoxControl(entryObj);
  }

  GuiComboBox? findComboBox(String id, {bool raise = true}) {
    return _findGeneric<GuiComboBox>(
      id,
      (s) => GuiComboBox(s),
      raise,
      expectedSapType: GuiComponentType.guiComboBox.value, // 34
    );
  }

  GuiButton? findButton(String id, {bool raise = true}) {
    return _findGeneric<GuiButton>(
      id,
      (s) => GuiButton(s),
      raise,
      expectedSapType: GuiComponentType.guiButton.value, // 40
    );
  }

  GuiBarChart? findBarChart(String id, {bool raise = true}) {
    return _findGeneric<GuiBarChart>(
      id,
      (s) => GuiBarChart(s),
      raise,
      expectedSapType: GuiComponentType.guiShell.value, // 122
    );
  }

  GuiCalendar? findCalendar(String id, {bool raise = true}) {
    return _findGeneric<GuiCalendar>(
      id,
      (s) => GuiCalendar(s),
      raise,
      expectedSapType: GuiComponentType.guiShell.value, // 122
      expectedSapSubType: "Calendar",
    );
  }

  GuiContainerShell? findContainerShell(String id, {bool raise = true}) {
    return _findGeneric<GuiContainerShell>(
      id,
      (s) => GuiContainerShell(s),
      raise,
      expectedSapType: GuiComponentType.guiContainerShell.value, // 51
    );
  }

  GuiCustomControl? findCustomControl(String id, {bool raise = true}) {
    return _findGeneric<GuiCustomControl>(
      id,
      (s) => GuiCustomControl(s),
      raise,
      expectedSapType: GuiComponentType.guiCustomControl.value, // 50
    );
  }

  GuiDialogShell? findDialogShell(String id, {bool raise = true}) {
    return _findGeneric<GuiDialogShell>(
      id,
      (s) => GuiDialogShell(s),
      raise,
      expectedSapType: GuiComponentType.guiDialogShell.value, // 125
    );
  }

  GuiDockShell? findDockShell(String id, {bool raise = true}) {
    return _findGeneric<GuiDockShell>(
      id,
      (s) => GuiDockShell(s),
      raise,
      expectedSapType: GuiComponentType.guiDockShell.value, // 126
    );
  }

  GuiEAIViewer2D? findEAIViewer2D(String id, {bool raise = true}) {
    final entryObj = obj.findById(id);
    if (entryObj == null) {
      if (raise) throw Exception("Element with ID '$id' not found.");
      return null;
    }
    return GuiEAIViewer2D(entryObj);
  }

  GuiEAIViewer3D? findEAIViewer3D(String id, {bool raise = true}) {
    final entryObj = obj.findById(id);
    if (entryObj == null) {
      if (raise) throw Exception("Element with ID '$id' not found.");
      return null;
    }
    return GuiEAIViewer3D(entryObj);
  }

  GuiGOSShell? findGOSShell(String id, {bool raise = true}) {
    return _findGeneric<GuiGOSShell>(
      id,
      (s) => GuiGOSShell(s),
      raise,
      expectedSapType: GuiComponentType.guiGOSShell.value, // 123
    );
  }

  GuiHTMLViewer? findHTMLViewer(String id, {bool raise = true}) {
    return _findGeneric<GuiHTMLViewer>(
      id,
      (s) => GuiHTMLViewer(s),
      raise,
      expectedSapType: GuiComponentType.guiShell.value, // 122
      expectedSapSubType: "HTMLViewer",
    );
  }

  GuiInputFieldControl? findInputFieldControl(String id, {bool raise = true}) {
    final entryObj = obj.findById(id);
    if (entryObj == null) {
      if (raise) throw Exception("Element with ID '$id' not found.");
      return null;
    }
    return GuiInputFieldControl(entryObj);
  }

  GuiNetChart? findNetChart(String id, {bool raise = true}) {
    return _findGeneric<GuiNetChart>(
      id,
      (s) => GuiNetChart(s),
      raise,
      expectedSapType: GuiComponentType.guiShell.value, // 122
      //expectedSapSubType: "", TODO: Confirmar si tiene un subTipo específico para NetChart o si se identifica solo por ser un Shell
    );
  }

  GuiOfficeIntegration? findOfficeIntegration(String id, {bool raise = true}) {
    return _findGeneric<GuiOfficeIntegration>(
      id,
      (s) => GuiOfficeIntegration(s),
      raise,
      expectedSapType: GuiComponentType.guiShell.value, // 122
      //expectedSapSubType: "", TODO: Confirmar si tiene un subTipo específico para OfficeIntegration o si se identifica solo por ser un Shell
    );
  }

  GuiPicture? findPicture(String id, {bool raise = true}) {
    return _findGeneric<GuiPicture>(
      id,
      (s) => GuiPicture(s),
      raise,
      expectedSapType: GuiComponentType.guiShell.value, // 122
      //expectedSapSubType: "", TODO: Confirmar si tiene un subTipo específico para OfficeIntegration o si se identifica solo por ser un Shell
    );
  }

  GuiRadioButton? findRadioButton(String id, {bool raise = true}) {
    return _findGeneric<GuiRadioButton>(
      id,
      (s) => GuiRadioButton(s),
      raise,
      expectedSapType: GuiComponentType.guiRadioButton.value, // 41
    );
  }

  GuiTextField? findTextField(String id, {bool raise = true}) {
    return _findGeneric<GuiTextField>(
      id,
      (s) => GuiTextField(s),
      raise,
      expectedSapType: GuiComponentType.guiTextField.value, // 31
    );
  }

  GuiCTextField? findCTextField(String id, {bool raise = true}) {
    return _findGeneric<GuiCTextField>(
      id,
      (s) => GuiCTextField(s),
      raise,
      expectedSapType: GuiComponentType.guiCTextField.value, // 32
    );
  }

  GuiLabel? findLabel(String id, {bool raise = true}) {
    return _findGeneric<GuiLabel>(
      id,
      (s) => GuiLabel(s),
      raise,
      expectedSapType: GuiComponentType.guiLabel.value, // 30
    );
  }

  GuiFrameWindow? findFrameWindow(String id, {bool raise = true}) {
    return _findGeneric<GuiFrameWindow>(
      id,
      (s) => GuiFrameWindow(s),
      raise,
      expectedSapType: GuiComponentType.guiFrameWindow.value, // 20
    );
  }

  GuiMainWindow? findMainWindow(String id, {bool raise = true}) {
    return _findGeneric<GuiMainWindow>(
      id,
      (s) => GuiMainWindow(s),
      raise,
      expectedSapType: GuiComponentType.guiMainWindow.value, // 21
    );
  }

  GuiMenu? findMenu(String id, {bool raise = true}) {
    return _findGeneric<GuiMenu>(
      id,
      (s) => GuiMenu(s),
      raise,
      expectedSapType: GuiComponentType.guiMenu.value, // 110
    );
  }

  GuiMenuBar? findMenuBar(String id, {bool raise = true}) {
    return _findGeneric<GuiMenuBar>(
      id,
      (s) => GuiMenuBar(s),
      raise,
      expectedSapType: GuiComponentType.guiMenubar.value, // 111
    );
  }

  GuiMessageWindow? findMessageWindow(String id, {bool raise = true}) {
    return _findGeneric<GuiMessageWindow>(
      id,
      (s) => GuiMessageWindow(s),
      raise,
      expectedSapType: GuiComponentType.guiMessageWindow.value, // 23
    );
  }

  GuiOkCodeField? findOkCodeField(String id, {bool raise = true}) {
    return _findGeneric<GuiOkCodeField>(
      id,
      (s) => GuiOkCodeField(s),
      raise,
      expectedSapType: GuiComponentType.guiOkCodeField.value, // 35
    );
  }

  GuiScrollbar? findScrollBar(String id, {bool raise = true}) {
    return _findGenericNoGuiComponent<GuiScrollbar>(
      id,
      (s) => GuiScrollbar(s),
      raise,
      expectedSapType: GuiComponentType.guiScrollbar.value, // 100
    );
  }

  GuiShell? findShell(String id, {bool raise = true}) {
    return _findGeneric<GuiShell>(
      id,
      (s) => GuiShell(s),
      raise,
      expectedSapType: GuiComponentType.guiShell.value, // 122
    );
  }

  GuiSapChart? findSapChart(String id, {bool raise = true}) {
    return _findGeneric<GuiSapChart>(
      id,
      (s) => GuiSapChart(s),
      raise,
      expectedSapType: GuiComponentType.guiShell.value, // 122
      //expectedSapSubType: "SapChart", TODO: Confirmar si tiene un subTipo específico para GuiSapChart o si se identifica solo por ser un Shell
    );
  }

  GuiSimpleContainer? findSimpleContainer(String id, {bool raise = true}) {
    return _findGeneric<GuiSimpleContainer>(
      id,
      (s) => GuiSimpleContainer(s),
      raise,
      expectedSapType: GuiComponentType.guiSimpleContainer.value, // 71
    );
  }

  GuiSplit? findSplitterShell(String id, {bool raise = true}) {
    return _findGeneric<GuiSplit>(
      id,
      (s) => GuiSplit(s),
      raise,
      expectedSapType: GuiComponentType.guiSplitterShell.value, // 124
    );
  }

  GuiSplitterContainer? findSplitterContainer(String id, {bool raise = true}) {
    return _findGeneric<GuiSplitterContainer>(
      id,
      (s) => GuiSplitterContainer(s),
      raise,
      expectedSapType: GuiComponentType.guiSplitterContainer.value, // 75
    );
  }

  GuiStage? findStage(String id, {bool raise = true}) {
    return _findGeneric<GuiStage>(
      id,
      (s) => GuiStage(s),
      raise,
      expectedSapType: GuiComponentType.guiShell.value, // 122
      //expectedSapSubType: "Stage", TODO: Confirmar si tiene un subTipo específico para Stage o si se identifica solo por ser un Shell
    );
  }

  GuiTextedit? findTextedit(String id, {bool raise = true}) {
    return _findGeneric<GuiTextedit>(
      id,
      (s) => GuiTextedit(s),
      raise,
      expectedSapType: GuiComponentType.guiShell.value, // 122
      //expectedSapSubType: "Textedit", TODO: Confirmar si tiene un subTipo específico para Textedit o si se identifica solo por ser un Shell
    );
  }

  GuiTitlebar? findTitlebar(String id, {bool raise = true}) {
    return _findGeneric<GuiTitlebar>(
      id,
      (s) => GuiTitlebar(s),
      raise,
      expectedSapType: GuiComponentType.guiTitlebar.value, // 102
    );
  }

  GuiGridView? findGridView(String id, {bool raise = true}) {
    return _findGeneric<GuiGridView>(
      id,
      (s) => GuiGridView(s),
      raise,
      expectedSapType: GuiComponentType.guiShell.value, // 122
      expectedSapSubType: "GridView",
    );
  }

  GuiScrollContainer? findScrollContainer(String id, {bool raise = true}) {
    return _findGeneric<GuiScrollContainer>(
      id,
      (s) => GuiScrollContainer(s),
      raise,
      expectedSapType: GuiComponentType.guiScrollContainer.value, // 72
    );
  }

  GuiStatusbar? findStatusbar(String id, {bool raise = true}) {
    return _findGeneric<GuiStatusbar>(
      id,
      (s) => GuiStatusbar(s),
      raise,
      expectedSapType: GuiComponentType.guiStatusbar.value, // 103
    );
  }

  GuiStatusBarLink? findStatusbarLink(String id, {bool raise = true}) {
    return _findGeneric<GuiStatusBarLink>(
      id,
      (s) => GuiStatusBarLink(s),
      raise,
      expectedSapType: GuiComponentType.guiStatusBarLink.value, // 130
    );
  }

  GuiStatusPane? findStatusPane(String id, {bool raise = true}) {
    return _findGeneric<GuiStatusPane>(
      id,
      (s) => GuiStatusPane(s),
      raise,
      expectedSapType: GuiComponentType.guiStatusPane.value, // 43
    );
  }

  GuiTableControl? findTableControl(String id, {bool raise = true}) {
    return _findGeneric<GuiTableControl>(
      id,
      (s) => GuiTableControl(s),
      raise,
      expectedSapType: GuiComponentType.guiTableControl.value, // 80
    );
  }

  GuiTab? findTab(String id, {bool raise = true}) {
    return _findGeneric<GuiTab>(
      id,
      (s) => GuiTab(s),
      raise,
      expectedSapType: GuiComponentType.guiTab.value, // 91
    );
  }

  GuiTabStrip? findTabStrip(String id, {bool raise = true}) {
    return _findGeneric<GuiTabStrip>(
      id,
      (s) => GuiTabStrip(s),
      raise,
      expectedSapType: GuiComponentType.guiTabStrip.value, // 90
    );
  }

  GuiTree? findTree(String id, {bool raise = true}) {
    return _findGeneric<GuiTree>(
      id,
      (s) => GuiTree(s),
      raise,
      expectedSapType: GuiComponentType.guiShell.value, // 122
      expectedSapSubType: "Tree",
    );
  }

  GuiToolbarControl? findToolbarControl(String id, {bool raise = true}) {
    return _findGeneric<GuiToolbarControl>(
      id,
      (s) => GuiToolbarControl(s),
      raise,
      expectedSapType: GuiComponentType.guiShell.value, // 122
    );
  }

  GuiToolbar? findToolbar(String id, {bool raise = true}) {
    return _findGeneric<GuiToolbar>(
      id,
      (s) => GuiToolbar(s),
      raise,
      expectedSapType: GuiComponentType.guiToolbar.value, // 101
    );
  }

  GuiUserArea? findUserArea(String id, {bool raise = true}) {
    return _findGeneric<GuiUserArea>(
      id,
      (s) => GuiUserArea(s),
      raise,
      expectedSapType: GuiComponentType.guiUserArea.value, // 74
    );
  }

  GuiVHViewSwitch? findVHViewSwitch(String id, {bool raise = true}) {
    return _findGeneric<GuiVHViewSwitch>(
      id,
      (s) => GuiVHViewSwitch(s),
      raise,
      expectedSapType: GuiComponentType.guiVHViewSwitch.value, // 129
    );
  }

  GuiComponent? findComponent(String id, {bool raise = true}) {
    return _findGeneric<GuiComponent>(id, (s) => GuiComponent(s), raise);
  }
}
