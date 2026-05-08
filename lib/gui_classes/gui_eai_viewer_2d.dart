import 'package:sap_gui_scripting/gui_classes/gui_shell.dart';

class GuiEAIViewer2D extends GuiShell {
  GuiEAIViewer2D(super.obj);

  void annotationTextRequest(String strText) =>
      obj.annotationTextRequest(strText);

  bool get annotationEnabled => obj.annotationEnabled;
  set annotationEnabled(bool value) => obj.annotationEnabled = value;

  int get annotationMode => obj.annotationMode;
  set annotationMode(int value) => obj.annotationMode = value;

  String get redliningStream => obj.redliningStream;
  set redliningStream(String value) => obj.redliningStream = value;
}
