import 'package:sap_gui_scripting/gui_classes/gui_frame_window.dart';

class GuiMainWindow extends GuiFrameWindow {
  GuiMainWindow(super.obj);

  void resizeWorkingPane(int width, int height, bool throwOnFail) =>
      obj.resizeWorkingPane(width, height, throwOnFail);

  void resizeWorkingPaneEx(int width, int height, bool throwOnFail) =>
      obj.resizeWorkingPaneEx(width, height, throwOnFail);

  bool get buttonbarVisible => obj.buttonbarVisible;
  set buttonbarVisible(bool value) => obj.buttonbarVisible = value;
  bool get statusbarVisible => obj.statusbarVisible;
  set statusbarVisible(bool value) => obj.statusbarVisible = value;
  bool get titlebarVisible => obj.titlebarVisible;
  set titlebarVisible(bool value) => obj.titlebarVisible = value;
  bool get toolbarVisible => obj.toolbarVisible;
  set toolbarVisible(bool value) => obj.toolbarVisible = value;
}
