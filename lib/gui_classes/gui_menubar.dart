import 'package:sap_gui_scripting/gui_classes/gui_component.dart';
import 'package:sap_gui_scripting/gui_classes/gui_component_collection.dart';
import 'package:sap_gui_scripting/gui_classes/gui_label.dart';
import 'package:sap_gui_scripting/gui_classes/gui_v_container.dart';

class GuiMenuBar extends GuiVContainer {
  GuiMenuBar(super.obj);

  @override
  GuiComponent get parentFrame => throw UnimplementedError(
    "The property 'ParentFrame' is not implemented in GuiMenu.",
  );

  @override
  bool get isSymbolFont => throw UnimplementedError(
    "The property 'IsSymbolFont' is not implemented in GuiMenu.",
  );

  @override
  String get accTooltip => throw UnimplementedError(
    "The property 'AccTooltip' is not implemented in GuiMenu.",
  );

  @override
  String get accTextOnRequest => throw UnimplementedError(
    "The property 'AccTextOnRequest' is not implemented in GuiMenu.",
  );

  @override
  String get accText => throw UnimplementedError(
    "The property 'AccText' is not implemented in GuiMenu.",
  );

  @override
  GuiComponentCollection<GuiLabel> get accLabelCollection =>
      throw UnimplementedError(
        "The property 'AccLabelCollection' is not implemented in GuiMenu.",
      );
}
