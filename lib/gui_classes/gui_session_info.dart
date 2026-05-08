import 'package:sap_gui_scripting/gui_classes/gui_component.dart';

class GuiSessionInfo extends GuiComponent {
  GuiSessionInfo(super.obj);

  String get applicationServer => obj.applicationServer;
  String get messageServer => obj.messageServer;
  String get systemName => obj.systemName;
  int get systemNumber => obj.systemNumber;
  String get group => obj.group;
  String get client => obj.client;
  String get user => obj.user;
  String get language => obj.language;
  int get sessionNumber => obj.sessionNumber;
  String get systemSessionId => obj.systemSessionId;
  String get transaction => obj.transaction;
  String get program => obj.program;
  int get screenNumber => obj.screenNumber;
  int get responseTime => obj.responseTime;
  int get roundTrips => obj.roundTrips;
  int get flushes => obj.flushes;
  bool get isLowSpeedConnection => obj.isLowSpeedConnection;
  int get guiCodepage => obj.guiCodepage;
  String get uiGuideline => obj.uiGuideline;
  bool get scriptingModeReadOnly => obj.scriptingModeReadOnly;
}
