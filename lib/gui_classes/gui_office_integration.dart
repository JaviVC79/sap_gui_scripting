import 'package:sap_gui_scripting/gui_classes/gui_shell.dart';

class GuiOfficeIntegration extends GuiShell {
  GuiOfficeIntegration(super.obj);

  void appendRow(String name, String row) => obj.appendRow(name, row);

  void closeDocument(int cookie, bool everChanged, bool changedAfterSave) =>
      obj.closeDocument(cookie, everChanged, changedAfterSave);

  void customEvent(
    int cookie,
    String eventName,
    int paramCount, [
    String? p1,
    String? p2,
    String? p3,
    String? p4,
    String? p5,
    String? p6,
    String? p7,
    String? p8,
    String? p9,
    String? p10,
    String? p11,
    String? p12,
  ]) => obj.customEvent(
    cookie,
    eventName,
    paramCount,
    p1,
    p2,
    p3,
    p4,
    p5,
    p6,
    p7,
    p8,
    p9,
    p10,
    p11,
    p12,
  );

  void removeContent(String name) => obj.removeContent(name);

  void saveDocument(int cookie, bool changed) =>
      obj.saveDocument(cookie, changed);

  void setDocument(int index, String document) =>
      obj.setDocument(index, document);

  Object? get document => obj.document;

  int get hostedApplication => obj.hostedApplication;
}
