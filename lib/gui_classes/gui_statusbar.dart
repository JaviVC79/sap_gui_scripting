import 'package:sap_gui_scripting/gui_classes/gui_v_component.dart';

class GuiStatusbar extends GuiVComponent {
  GuiStatusbar(super.obj);

  void createSupportMessageClick() => obj.createSupportMessageClick();
  void doubleClick() => obj.doubleClickNoArgs();
  void serviceRequestClick() => obj.serviceRequestClick();
  
  bool get messageAsPopup => obj.messageAsPopup;
  int get messageHasLongText => obj.messageHasLongText;

  /*
  Possible return values of MessageHasLongText are:
    -1: Presently no message is displayed in the statusbar
    0: The message which is displayed does not have a long text
    1: The message which is displayed has a long text
    This property is available as of patchlevel 2 of SAP GUI for Windows 7.60.
  */
  String get messageId => obj.messageId;
  String get messageNumber => obj.messageNumber;
  String get messageParameter => obj.messageParameter;
  String get messageType => obj.messageTypeRetunString;
  /*
  The property messageType may have any of the following values:

    Value	Description
    S	Success
    W	Warning
    E	Error
    A	Abort
    I	Information
  */
}
