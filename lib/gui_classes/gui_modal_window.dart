import 'package:sap_gui_scripting/gui_classes/gui_frame_window.dart';

class GuiModalWindow extends GuiFrameWindow {
  GuiModalWindow(super.obj);

  bool get isPopupDialog => obj.isPopupDialog;
  set isPopupDialog(bool value) => obj.isPopupDialog = value;

  String get popupDialog => obj.popupDialog;
  set popupDialog(String value) => obj.popupDialog = value;
}
