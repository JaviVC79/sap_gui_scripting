import 'package:sap_gui_scripting/sap_gui_scripting.dart';

/// Script 1: Extraccion de datos
void script1(Map<String, dynamic> msg) async {
  await runScriptSafely<String>(msg, (session, args) async {
    print("🟢 [Script Extraccion] Iniciando...");

    session.startTransaction("SE38");
    final textField = session.findCTextField("wnd[0]/usr/ctxtRS38M-PROGRAMM");
    for (int i = 0; i < 2000; i++) {
      textField?.text = i.toString();
    }
    session.findRadioButton("wnd[0]/usr/radRS38M-FUNC_DOCU")?.select();
    final value = session.findCTextField("wnd[0]/usr/ctxtRS38M-PROGRAMM")!.text;
    session.endTransaction();

    print("✅ [Script Extraccion] Terminado");
    return value;
  });
}

/// Script 2: Procesamiento en SYCM
void script2(Map<String, dynamic> msg) async {
  await runScriptSafely<bool>(msg, (session, args) async {
    print("🔵 [Script Actualizacion] Iniciando...");

    session.startTransaction("SYCM");
    final textField = session.findCTextField("wnd[0]/usr/ctxtSO_NOTE-LOW");
    for (int i = 10000; i < 12000; i++) {
      textField?.text = i.toString();
    }
    session.findCTextField("wnd[0]/usr/ctxtSO_NOTE-LOW")?.text = "0002728880";
    session.findCTextField("wnd[0]/usr/ctxtSO_NOTE-LOW")?.caretPosition = 0;
    session.findButton("wnd[0]/tbar[1]/btn[8]")?.press();
    session
        .findGridView("wnd[0]/usr/cntlCUSTOM/shellcont/shell")
        ?.setCurrentCell(1, "REF_OBJ_NAME");
    session
        .findGridView("wnd[0]/usr/cntlCUSTOM/shellcont/shell")
        ?.doubleClickCurrentCell();
    session.findTab("wnd[0]/usr/tabsCTS/tabpTAB_CLSD")?.select();
    session.findTab("wnd[0]/usr/tabsCTS/tabpTAB_MTD")?.select();
    session
            .findTableControl(
              "wnd[0]/usr/tabsCTS/tabpTAB_MTD/ssubCSS:SAPLSEOD:0253/tblSAPLSEODMC",
            )
            ?.verticalScrollbar
            ?.position =
        1;
    session
            .findTableControl(
              "wnd[0]/usr/tabsCTS/tabpTAB_MTD/ssubCSS:SAPLSEOD:0253/tblSAPLSEODMC",
            )
            ?.verticalScrollbar
            ?.position =
        2;
    session
        .findTextField(
          "wnd[0]/usr/tabsCTS/tabpTAB_MTD/ssubCSS:SAPLSEOD:0253/tblSAPLSEODMC/txtVSEOMETHOD-DESCRIPT[4,2]",
        )
        ?.setFocus();
    session
            .findTextField(
              "wnd[0]/usr/tabsCTS/tabpTAB_MTD/ssubCSS:SAPLSEOD:0253/tblSAPLSEODMC/txtVSEOMETHOD-DESCRIPT[4,2]",
            )
            ?.caretPosition =
        0;
    final tbl = session
        .findTableControl(
          "wnd[0]/usr/tabsCTS/tabpTAB_MTD/ssubCSS:SAPLSEOD:0253/tblSAPLSEODMC",
        )
        ?.getAbsoluteRow(5);
    final cell = tbl?.elementAt(4) as GuiTextField;
    print(cell.text);

    session.endTransaction();
    print("✅ [Script Actualizacion] Terminado");
    return true;
  });
}

/// Script 3: Identico a script 2
void script3(Map<String, dynamic> msg) async {
  await runScriptSafely<bool>(msg, (session, args) async {
    return await _script2Logic(session);
  });
}

Future<bool> _script2Logic(GuiSession session) async {
  print("🔵 [Script Actualizacion] Iniciando...");

  session.startTransaction("SYCM");
  final textField = session.findCTextField("wnd[0]/usr/ctxtSO_NOTE-LOW");
  for (int i = 10000; i < 12000; i++) {
    textField?.text = i.toString();
  }
  session.findCTextField("wnd[0]/usr/ctxtSO_NOTE-LOW")?.text = "0002728880";
  session.findCTextField("wnd[0]/usr/ctxtSO_NOTE-LOW")?.caretPosition = 0;
  session.findButton("wnd[0]/tbar[1]/btn[8]")?.press();
  session
      .findGridView("wnd[0]/usr/cntlCUSTOM/shellcont/shell")
      ?.setCurrentCell(1, "REF_OBJ_NAME");
  session
      .findGridView("wnd[0]/usr/cntlCUSTOM/shellcont/shell")
      ?.doubleClickCurrentCell();
  session.findTab("wnd[0]/usr/tabsCTS/tabpTAB_CLSD")?.select();
  session.findTab("wnd[0]/usr/tabsCTS/tabpTAB_MTD")?.select();
  session
          .findTableControl(
            "wnd[0]/usr/tabsCTS/tabpTAB_MTD/ssubCSS:SAPLSEOD:0253/tblSAPLSEODMC",
          )
          ?.verticalScrollbar
          ?.position =
      1;
  session
          .findTableControl(
            "wnd[0]/usr/tabsCTS/tabpTAB_MTD/ssubCSS:SAPLSEOD:0253/tblSAPLSEODMC",
          )
          ?.verticalScrollbar
          ?.position =
      2;
  session
      .findTextField(
        "wnd[0]/usr/tabsCTS/tabpTAB_MTD/ssubCSS:SAPLSEOD:0253/tblSAPLSEODMC/txtVSEOMETHOD-DESCRIPT[4,2]",
      )
      ?.setFocus();
  session
          .findTextField(
            "wnd[0]/usr/tabsCTS/tabpTAB_MTD/ssubCSS:SAPLSEOD:0253/tblSAPLSEODMC/txtVSEOMETHOD-DESCRIPT[4,2]",
          )
          ?.caretPosition =
      0;
  final tbl = session
      .findTableControl(
        "wnd[0]/usr/tabsCTS/tabpTAB_MTD/ssubCSS:SAPLSEOD:0253/tblSAPLSEODMC",
      )
      ?.getAbsoluteRow(5);
  final cell = tbl?.elementAt(4) as GuiTextField;
  print(cell.text);

  session.endTransaction();
  print("✅ [Script Actualizacion] Terminado");
  return true;
}
