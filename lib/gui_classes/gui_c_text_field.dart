import 'package:sap_gui_scripting/gui_classes/gui_text_field.dart';

class GuiCTextField extends GuiTextField {
  GuiCTextField(super.obj);

  @override
  bool get isListElement {
    throw UnsupportedError(
      'La propiedad isListElement no está disponible para GuiCTextField '
      'ya que la ayuda F4 no existe en listas ABAP.',
    );
  }
}
