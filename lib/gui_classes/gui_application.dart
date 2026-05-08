import 'package:sap_gui_scripting/gui_classes/gui_collection.dart';
import 'package:sap_gui_scripting/gui_classes/gui_component_collection.dart';
import 'package:sap_gui_scripting/gui_classes/gui_connection.dart';
import 'package:sap_gui_scripting/gui_classes/gui_container.dart';
import 'package:sap_gui_scripting/gui_classes/gui_session.dart';
import 'package:sap_gui_scripting/gui_classes/gui_utils.dart';

class GuiApplication extends GuiContainer {
  GuiApplication(super.obj);

  GuiSession? get activeSession {
    final sessionObj = obj.activeSession;
    return sessionObj != null ? GuiSession(sessionObj) : null;
  }

  bool get allowSystemMessages => obj.allowSystemMessages;
  set allowSystemMessages(bool value) => obj.allowSystemMessages = value;
  GuiComponentCollection<GuiConnection> get connections {
    final childrenObj = obj.children;
    if (childrenObj == null) throw Exception("Connections not found");
    return GuiComponentCollection<GuiConnection>(childrenObj);
  }

  String get connectionErrorText => obj.connectionErrorText;
  bool get historyEnabled => obj.historyEnabled;
  set historyEnabled(bool value) => obj.historyEnabled = value;
  int get majorVersion => obj.majorVersion;
  int get minorVersion => obj.minorVersion;
  int get patchlevel => obj.patchlevel;
  int get revision => obj.revision;
  bool get newVisualDesign => obj.newVisualDesign;
  bool get buttonbarVisible => obj.buttonbarVisible;
  set buttonbarVisible(bool v) => obj.buttonbarVisible = v;
  bool get statusbarVisible => obj.statusbarVisible;
  set statusbarVisible(bool v) => obj.statusbarVisible = v;
  bool get titlebarvisible => obj.titlebarVisible;
  set titlebarVisible(bool v) => obj.titlebarVisible = v;
  bool get toolbarVisible => obj.toolbarVisible;
  set toolbarVisible(bool v) => obj.toolbarVisible = v;
  GuiUtils? get utils {
    final object = obj.utils;
    if (object == null) return null;
    return GuiUtils(object);
  }

  GuiConnection? openConnection(
    String description, {
    bool sync = true,
    bool raise = true,
  }) {
    final connObj = obj.openConnection(description, sync: sync, raise: raise);
    if (connObj == null) return null;
    return GuiConnection(connObj);
  }

  GuiConnection? openConnectionByConnectionString(
    String connectString, {
    bool sync = true,
    bool raise = true,
  }) {
    final connObj = obj.openConnectionByConnectionString(
      connectString,
      sync: sync,
      raise: raise,
    );
    if (connObj == null) return null;
    return GuiConnection(connObj);
  }

  bool addHistoryEntry(String fieldName, String value) {
    return obj.addHistoryEntry(fieldName, value);
  }

  bool dropHistory() => obj.dropHistory();
  GuiCollection? createGuiCollection() {
    final colObj = obj.createGuiCollection();
    if (colObj == null) return null;
    return GuiCollection(colObj);
  }

  bool registerROT() => obj.registerROT();
  void revokeROT() => obj.revokeROT();
  void ignore(int windowHandle) => obj.ignore(windowHandle);
}
