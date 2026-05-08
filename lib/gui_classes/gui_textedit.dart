import 'package:sap_gui_scripting/gui_classes/gui_shell.dart';

class GuiTextedit extends GuiShell {
  GuiTextedit(super.obj);

  void contextMenu() => obj.contextMenu();
  void doubleClick() => obj.doubleClickNoArgs();
  String getLineText(int nLine) => obj.getLineText(nLine);
  String getUnprotectedTextPart(int part) => obj.getUnprotectedTextPart(part);
  bool isBreakpointLine(int nLine) => obj.isBreakpointLine(nLine);
  bool isCommentLine(int nLine) => obj.isCommentLine(nLine);
  bool isHighlightedLine(int nLine) => obj.isHighlightedLine(nLine);
  bool isProtectedLine(int nLine) => obj.isProtectedLine(nLine);
  bool isSelectedLine(int nLine) => obj.isSelectedLine(nLine);
  void modifiedStatusChanged(bool status) => obj.modifiedStatusChanged(status);
  void multipleFilesDropped() => obj.multipleFilesDropped();
  void pressF1() => obj.pressF1();
  void pressF4() => obj.pressF4();
  void setSelectionIndexes(int start, int end) =>
      obj.setSelectionIndexes(start, end);
  bool setUnprotectedTextPart(int part, String text) =>
      obj.setUnprotectedTextPart(part, text);
  void singleFileDropped(String filename) => obj.singleFileDropped(filename);

  int get currentColumn => obj.currentColumn;
  int get currentLine => obj.currentLine;
  int get firstVisibleLine => obj.firstVisibleLine;
  set firstVisibleLine(int value) => obj.firstVisibleLine = value;
  int get lastVisibleLine => obj.lastVisibleLine;
  int get lineCount => obj.lineCount;
  int get numberOfUnprotectedTextParts => obj.numberOfUnprotectedTextParts;
  String get selectedText => obj.selectedText;
  int get selectionEndColumn => obj.selectionEndColumn;
  int get selectionEndLine => obj.selectionEndLine;
  int get selectionIndexEnd => obj.selectionIndexEnd;
  int get selectionIndexStart => obj.selectionIndexStart;
  int get selectionStartColumn => obj.selectionStartColumn;
  int get selectionStartLine => obj.selectionStartLine;
}
