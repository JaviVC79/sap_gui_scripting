import 'package:sap_gui_scripting/gui_classes/gui_v_container.dart';

class GuiSimpleContainer extends GuiVContainer {
  GuiSimpleContainer(super.obj);

  String getListProperty(String property) => obj.getListProperty(property);
  String getListPropertyNonRec(String property) =>
      obj.getListPropertyNonRec(property);

  bool get isListElement => obj.isListElement;
  bool get isStepLoop => obj.isStepLoop;
  bool get isStepLoopInTableStructure => obj.isStepLoopInTableStructure;
  int get loopColCount => obj.loopColCount;
  int get loopCurrentCol => obj.loopCurrentCol;
  int get loopCurrentColCount => obj.loopCurrentColCount;
  int get loopCurrentRow => obj.loopCurrentRow;
  int get loopRowCount => obj.loopRowCount;
}
