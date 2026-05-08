import 'package:sap_gui_scripting/gui_classes/gui_shell.dart';

class GuiHTMLViewer extends GuiShell {
  GuiHTMLViewer(super.obj);

  void contextMenu() => obj.contextMenu();

  int getBrowerControlType() => obj.getBrowerControlType();

  void sapEvent(String frameName, String postData, String url) =>
      obj.sapEvent(frameName, postData, url);

  Object? get browserHandle => obj.browserHandle;

  int get documentComplete => obj.documentComplete;
}
