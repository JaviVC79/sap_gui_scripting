import 'package:sap_gui_scripting/gui_classes/gui_component.dart';
import 'package:sap_gui_scripting/gui_classes/gui_component_collection.dart';
import 'package:sap_gui_scripting/gui_classes/gui_label.dart';
import 'package:sap_gui_scripting/gui_classes/gui_v_component.dart';

class GuiOkCodeField extends GuiVComponent {
  GuiOkCodeField(super.obj);

  void pressF1() => obj.pressF1();

  bool get opened => obj.opened;
  // Some properties are not supported,
  // because the GuiOkCodeField is not an object that can be influenced by the ABAP application:
  @override
  GuiComponentCollection<GuiLabel>
  get accLabelCollection => throw UnimplementedError(
    "The property 'accLabelCollection' is not implemented for GuiOkCodeField.",
  );

  @override
  String get accText => throw UnimplementedError(
    "The property 'accText' is not implemented for GuiOkCodeField.",
  );

  @override
  String get accTextOnRequest => throw UnimplementedError(
    "The property 'accTextOnRequest' is not implemented for GuiOkCodeField.",
  );

  @override
  String get accTooltip => throw UnimplementedError(
    "The property 'accTooltip' is not implemented for GuiOkCodeField.",
  );

  @override
  String get defaultTooltip => throw UnimplementedError(
    "The property 'defaultTooltip' is not implemented for GuiOkCodeField.",
  );

  @override
  bool get isSymbolFont => throw UnimplementedError(
    "The property 'isSymbolFont' is not implemented for GuiOkCodeField.",
  );

  @override
  GuiComponent? get parentFrame => throw UnimplementedError(
    "The property 'parentFrame' is not implemented for GuiOkCodeField.",
  );

  @override
  String get tooltip => throw UnimplementedError(
    "The property 'tooltip' is not implemented for GuiOkCodeField.",
  );
}
