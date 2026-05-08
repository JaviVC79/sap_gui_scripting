import 'package:sap_gui_scripting/gui_classes/gui_shell.dart';

class GuiToolbarControl extends GuiShell {
  GuiToolbarControl(super.obj);

  int get buttonCount => obj.buttonCount;
  int get focusedButton => obj.focusedButton;

  bool getButtonChecked(int buttonPos) => obj.getButtonChecked(buttonPos);
  bool getButtonEnabled(int buttonPos) => obj.getButtonEnabled(buttonPos);
  String getButtonIcon(int buttonPos) => obj.getButtonIcon(buttonPos);
  String getButtonId(int buttonPos) => obj.getButtonId(buttonPos);
  String getButtonText(int buttonPos) => obj.getButtonText(buttonPos);
  String getButtonTooltip(int buttonPos) => obj.getButtonTooltip(buttonPos);
  String getButtonType(int buttonPos) => obj.getButtonType(buttonPos); // Possible values are:"Button", "ButtonAndMenu", "Menu", "Separator", "Group", "CheckBox"
  String getMenuItemIdFromPosition(int pos) => obj.getMenuItemIdFromPosition(pos);
  void pressButton(String id) => obj.pressButtonToolBarControl(id);
  void pressContextButton(String id) => obj.pressContextButton(id);
  void selectMenuItem(String id) => obj.selectMenuItem(id);
  void selectMenuItemByText(String text) => obj.selectMenuItemByText(text);



}
