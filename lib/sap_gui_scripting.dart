/// True Multi-threaded SAP GUI Automation for Dart (Windows only).
///
/// This package provides a high-performance bridge between Dart and the
/// SAP GUI Scripting API via FFI and a native C++/COM core.
///
/// ## Quick start
///
/// ```dart
/// import 'package:sap_gui_scripting/sap_gui_scripting.dart';
///
/// void main() async {
///   final orchestrator = SapOrchestrator();
///   await orchestrator.initialize();
///   final result = await orchestrator.runScript<String>(myScript, 'XD03');
///   print(result);
/// }
/// ```
library;

// ── Core FFI bridge ──
export 'methods/sap_api.dart';
export 'methods/sap_object.dart';
export 'methods/load_dll_helper.dart';

// ── Orchestrator (session pool + isolate execution) ──
export 'sap_orchestrator/sap_orchestrator.dart';
export 'sap_orchestrator/script_runner.dart';

// ── Enums ──
export 'enums/enum_gui_component_type_number.dart';

// ── SAP GUI component wrappers ──
export 'gui_classes/gui_application.dart';
export 'gui_classes/gui_bar_chart.dart';
export 'gui_classes/gui_box.dart';
export 'gui_classes/gui_button.dart';
export 'gui_classes/gui_c_text_field.dart';
export 'gui_classes/gui_calendar.dart';
export 'gui_classes/gui_chart.dart';
export 'gui_classes/gui_checkbox.dart';
export 'gui_classes/gui_collection.dart';
export 'gui_classes/gui_color_selector.dart';
export 'gui_classes/gui_combo_box.dart';
export 'gui_classes/gui_combo_box_control.dart';
export 'gui_classes/gui_combo_box_entry.dart';
export 'gui_classes/gui_component.dart';
export 'gui_classes/gui_component_collection.dart';
export 'gui_classes/gui_connection.dart';
export 'gui_classes/gui_container.dart';
export 'gui_classes/gui_container_shell.dart';
export 'gui_classes/gui_custom_control.dart';
export 'gui_classes/gui_dialog_shell.dart';
export 'gui_classes/gui_dock_shell.dart';
export 'gui_classes/gui_eai_viewer_2d.dart';
export 'gui_classes/gui_eai_viewer_3d.dart';
export 'gui_classes/gui_frame_window.dart';
export 'gui_classes/gui_gos_shell.dart';
export 'gui_classes/gui_graph_adapt.dart';
export 'gui_classes/gui_grid_view.dart';
export 'gui_classes/gui_html_viewer.dart';
export 'gui_classes/gui_input_field_control.dart';
export 'gui_classes/gui_label.dart';
export 'gui_classes/gui_main_window.dart';
export 'gui_classes/gui_map.dart';
export 'gui_classes/gui_menu.dart';
export 'gui_classes/gui_menubar.dart';
export 'gui_classes/gui_message_window.dart';
export 'gui_classes/gui_modal_window.dart';
export 'gui_classes/gui_net_chart.dart';
export 'gui_classes/gui_office_integration.dart';
export 'gui_classes/gui_ok_code_field.dart';
export 'gui_classes/gui_password_field.dart';
export 'gui_classes/gui_picture.dart';
export 'gui_classes/gui_radio_button.dart';
export 'gui_classes/gui_sap_chart.dart';
export 'gui_classes/gui_scroll_bar.dart';
export 'gui_classes/gui_scroll_container.dart';
export 'gui_classes/gui_session.dart';
export 'gui_classes/gui_session_info.dart';
export 'gui_classes/gui_shell.dart';
export 'gui_classes/gui_simple_container.dart';
export 'gui_classes/gui_split.dart';
export 'gui_classes/gui_splitter_container.dart';
export 'gui_classes/gui_stage.dart';
export 'gui_classes/gui_status_bar_link.dart';
export 'gui_classes/gui_status_pane.dart';
export 'gui_classes/gui_statusbar.dart';
export 'gui_classes/gui_tab.dart';
export 'gui_classes/gui_tab_strip.dart';
export 'gui_classes/gui_table_column.dart';
export 'gui_classes/gui_table_control.dart';
export 'gui_classes/gui_table_row.dart';
export 'gui_classes/gui_text_field.dart';
export 'gui_classes/gui_textedit.dart';
export 'gui_classes/gui_titlebar.dart';
export 'gui_classes/gui_toolbar.dart';
export 'gui_classes/gui_toolbar_control.dart';
export 'gui_classes/gui_tree.dart';
export 'gui_classes/gui_user_area.dart';
export 'gui_classes/gui_utils.dart';
export 'gui_classes/gui_v_component.dart';
export 'gui_classes/gui_v_container.dart';
export 'gui_classes/gui_vh_view_switch.dart';

// ── Interfaces (for mocking / custom implementations) ──
export 'interfaces/i_sap_api.dart';
export 'interfaces/i_sap_object.dart';
