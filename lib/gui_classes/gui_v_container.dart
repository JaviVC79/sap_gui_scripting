import 'package:sap_gui_scripting/gui_classes/gui_component.dart';
import 'package:sap_gui_scripting/gui_classes/gui_component_collection.dart';
import 'package:sap_gui_scripting/gui_classes/gui_container.dart';
import 'package:sap_gui_scripting/gui_classes/gui_label.dart';

class GuiVContainer extends GuiContainer {
  GuiVContainer(super.obj);

  GuiComponent? findByName(String name, String type) {
    final res = obj.findByName(name, type);
    return res != null ? GuiComponent(res) : null;
  }

  GuiComponent? findByNameEx(String name, int typeAsNumber) {
    final res = obj.findByNameEx(name, typeAsNumber);
    return res != null ? GuiComponent(res) : null;
  }

  GuiComponentCollection<GuiComponent> findAllByName(String name, String type) {
    final col = obj.findAllByName(name, type);
    if (col == null) {
      throw Exception("No components found for this name and type");
    }
    return GuiComponentCollection<GuiComponent>(col);
  }

  GuiComponentCollection<GuiComponent> findAllByNameEx(
    String name,
    int typeAsNumber,
  ) {
    final col = obj.findAllByNameEx(name, typeAsNumber);
    if (col == null) {
      throw Exception("No components found for this name and type");
    }
    return GuiComponentCollection<GuiComponent>(col);
  }

  void setFocus() => obj.setFocus();

  int visualize(bool on, [String innerObject = ""]) =>
      obj.visualize(on, innerObject);

  GuiComponentCollection<GuiComponent> dumpState([String innerObject = ""]) {
    final res = obj.dumpState(innerObject);
    if (res == null) {
      throw Exception("No state found for this component");
    }
    return GuiComponentCollection<GuiComponent>(res);
  }

  String get text => obj.text;
  set text(String value) => obj.text = value;

  int get left => obj.left;
  int get top => obj.top;
  int get width => obj.width;
  int get height => obj.height;
  int get screenLeft => obj.screenLeft;
  int get screenTop => obj.screenTop;

  String get tooltip => obj.tooltip;
  String get iconName => obj.iconName;
  bool get isSymbolFont => obj.isSymbolFont;
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

  GuiComponent? get parentFrame {
    final p = obj.parentFrame;
    return p != null ? GuiComponent(p) : null;
  }
}
