import 'package:sap_gui_scripting/gui_classes/gui_text_field.dart';

class GuiPasswordField extends GuiTextField {
  GuiPasswordField(super.obj);

  @override
  bool get isListElement => throw UnimplementedError(
    "The property 'isListElement' is not applicable to GuiPasswordField",
  );

  @override
  String get text => "";

  @override
  String get displayedText => "";

  @override
  String get historyCurEntry => throw UnimplementedError(
    "The property 'HistoryCurEntry' is not applicable to GuiPasswordField",
  );

  @override
  int get historyCurIndex => throw UnimplementedError(
    "The property 'HistoryCurIndex' is not applicable to GuiPasswordField",
  );

  @override
  bool get historyIsActive => throw UnimplementedError(
    "The property 'HistoryIsActive' is not applicable to GuiPasswordField",
  );

  @override
  List<String> get historyList => throw UnimplementedError(
    "The property 'HistoryList' is not applicable to GuiPasswordField",
  );
}
