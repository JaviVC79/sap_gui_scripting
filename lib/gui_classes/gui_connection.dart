import 'package:sap_gui_scripting/gui_classes/gui_component_collection.dart';
import 'package:sap_gui_scripting/gui_classes/gui_container.dart';
import 'package:sap_gui_scripting/gui_classes/gui_session.dart';

class GuiConnection extends GuiContainer {
  GuiConnection(super.obj);

  bool get isValid => obj.handle != 0;

  bool get isInvalid => obj.handle == 0;

  String get connectionString => obj.connectionString;

  String get description => obj.description;

  bool get disabledByServer => obj.disabledByServer;

  @override
  GuiComponentCollection<GuiSession> get children {
    final childrenObj = obj.children;
    if (childrenObj == null) throw Exception("Connections not found");
    return GuiComponentCollection<GuiSession>(childrenObj);
  }

  GuiComponentCollection<GuiSession> get sessions {
    final childrenObj = obj.children;
    if (childrenObj == null) throw Exception("Connections not found");
    return GuiComponentCollection<GuiSession>(childrenObj);
  }

  void closeConnection() {
    obj.closeConnection();
  }

  void closeSession(String sessionId) {
    obj.closeSession(sessionId);
  }
}
