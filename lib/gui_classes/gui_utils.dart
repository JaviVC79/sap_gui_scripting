import 'package:sap_gui_scripting/interfaces/i_sap_object.dart';

class GuiUtils {
  final ISapObject obj;
  GuiUtils(this.obj);

  void closeFile(int file) => obj.closeFile(file);
  int openFile(String filename) => obj.openFile(filename);
  int showMessageBox(String title, String text, int msgIcon, int msgType) =>
      obj.showMessageBox(title, text, msgIcon, msgType);
  void write(int file, String text) => obj.write(file, text);
  void writeLine(int file, String text) => obj.writeLine(file, text);

  int get messageOptionOk => obj.messageOptionOk;
  int get messageOptionOkCancel => obj.messageOptionOkCancel;
  //TODO implementar el resto de propiedades de GuiUtils
}
