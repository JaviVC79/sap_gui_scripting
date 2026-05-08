import 'package:sap_gui_scripting/gui_classes/gui_shell.dart';

class GuiPicture extends GuiShell {
  GuiPicture(super.obj);

  void click() => obj.clickInPicture();
  void clickControlArea(int x, int y) => obj.clickControlArea(x, y);
  void clickPictureArea(int x, int y) => obj.clickPictureArea(x, y);
  void contextMenu(int x, int y) => obj.contextMenuInPicture(x, y);
  void doubleClick() => obj.doubleClickInPicture();
  void doubleClickControlArea(int x, int y) => obj.doubleClickControlArea(x, y);
  void doubleClickPictureArea(int x, int y) => obj.doubleClickPictureArea(x, y);

  String get altText => obj.altText;
  String get displayMode => obj.displayMode;
  String get icon => obj.icon;
  String get url => obj.url;
}
