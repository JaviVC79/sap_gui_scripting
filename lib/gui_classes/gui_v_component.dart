import 'package:sap_gui_scripting/gui_classes/gui_component.dart';
import 'package:sap_gui_scripting/gui_classes/gui_component_collection.dart';
import 'package:sap_gui_scripting/gui_classes/gui_label.dart';

class GuiVComponent extends GuiComponent {
  GuiVComponent(super.obj);

  void setFocus() => obj.setFocus();

  int visualize(bool on, [String innerObject = ""]) {
    return obj.visualize(on, innerObject);
  }

  GuiComponentCollection<GuiComponent> dumpState([String innerObject = ""]) {
    final res = obj.dumpState(innerObject);
    if (res == null) {
      throw Exception("No state found for this component");
    }
    return GuiComponentCollection<GuiComponent>(res);
  }

  int get left => obj.left;
  int get top => obj.top;
  int get width => obj.width;
  int get height => obj.height;

  int get screenLeft => obj.screenLeft;

  int get screenTop => obj.screenTop;

  String get text => obj.text;
  set text(String value) => obj.text = value;

  String get tooltip => obj.tooltip;

  String get iconName => obj.iconName;

  bool get modified => obj.modified;
  set modified(bool value) => obj.modified = value;

  bool get changeable => obj.changeable;

  GuiComponentCollection<GuiLabel> get accLabelCollection {
    final col = obj.accLabelCollection;
    if (col == null) {
      throw Exception("No labels found for this component");
    }
    return GuiComponentCollection<GuiLabel>(col);
  }

  String get accText => obj.accText;
  String get accTextOnRequest => obj.accTextOnRequest;
  String get accTooltip => obj.accTooltip;
  String get defaultTooltip => obj.defaultTooltip;
  bool get isSymbolFont => obj.isSymbolFont;

  GuiComponent? get parentFrame {
    final p = obj.parentFrame;
    return p != null ? GuiComponent(p) : null;
  }
}
