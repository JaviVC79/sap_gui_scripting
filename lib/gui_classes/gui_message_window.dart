import 'package:sap_gui_scripting/gui_classes/gui_v_component.dart';

class GuiMessageWindow extends GuiVComponent {
  GuiMessageWindow(super.obj);

  int get focusedButton => obj.focusedButton;
  String get helpButtonHelpText => obj.helpButtonHelpText;
  String get helpButtonText => obj.helpButtonText;
  String get messageText => obj.messageText;
  int get messageType => obj.messageType;
  String get okButtonText => obj.okButtonText;
  @override
  int get screenLeft => obj.screenLeft;
  @override
  int get screenTop => obj.screenTop;
  bool get visible => obj.visible;
  set screenLeft(int value) {
    obj.screenLeft = value;
  }

  set screenTop(int value) {
    obj.screenTop = value;
  }
}
