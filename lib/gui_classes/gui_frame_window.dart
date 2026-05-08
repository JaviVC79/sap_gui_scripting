import 'dart:typed_data';
import 'package:sap_gui_scripting/gui_classes/gui_v_container.dart';
import 'package:sap_gui_scripting/gui_classes/gui_v_component.dart';

class GuiFrameWindow extends GuiVContainer {
  GuiFrameWindow(super.obj);

  void close() => obj.close();

  void maximize() => obj.maximize();

  void iconify() => obj.iconify();

  void restore() => obj.restore();

  void sendVKey(int vKey) => obj.sendVKey(vKey);

  bool isVKeyAllowed(int vKey) => obj.isVKeyAllowed(vKey);

  void jumpBackward() => obj.jumpBackward();
  void jumpForward() => obj.jumpForward();
  void tabBackward() => obj.tabBackward();
  void tabForward() => obj.tabForward();

  int compBitmap(String filename1, String filename2) =>
      obj.compBitmap(filename1, filename2);

  /// Saves a screenshot of the window to the disk.
  /// Note: Only the mandatory argument (Filename) is implemented.
  /// To use ImageType, xPos, yPos, nWidth, nHeight, it would be necessary
  /// to create an FFI helper '_invokeStrStrIntIntIntInt' in SapObject.
  String hardCopy(String filename) => obj.hardCopy(filename);

  /// This function returns a hardcopy of the window as a safe array of bytes.
  /// The following values are valid:
  /// 0: BMP
  /// 1: JPG
  /// 2: PNG
  /// 3: GIF
  /// BMP is the default format.
  Uint8List hardCopyToMemory() => obj.hardCopyToMemory();

  int showMessageBox(String title, String text, int msgIcon, int msgType) =>
      obj.showMessageBox(title, text, msgIcon, msgType);

  bool get elementVisualizationMode => obj.elementVisualizationMode;
  set elementVisualizationMode(bool value) =>
      obj.elementVisualizationMode = value;

  GuiVComponent? get guiFocus {
    final focusObj = obj.guiFocus;
    return focusObj != null ? GuiVComponent(focusObj) : null;
  }

  GuiVComponent? get systemFocus {
    final focusObj = obj.systemFocus;
    return focusObj != null ? GuiVComponent(focusObj) : null;
  }

  bool get iconic => obj.iconic;
  int get workingPaneHeight => obj.workingPaneHeight;
  int get workingPaneWidth => obj.workingPaneWidth;
}
