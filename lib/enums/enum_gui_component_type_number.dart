enum GuiComponentType {
  // Basics and Connection (6)
  guiComponent(0, "GuiComponent"),
  guiVComponent(1, "GuiVComponent"),
  guiVContainer(2, "GuiVContainer"),
  guiApplication(10, "GuiApplication"),
  guiConnection(11, "GuiConnection"),
  guiSession(12, "GuiSession"),

  // Windows (4)
  guiFrameWindow(20, "GuiFrameWindow"),
  guiMainWindow(21, "GuiMainWindow"),
  guiModalWindow(22, "GuiModalWindow"),
  guiMessageWindow(23, "GuiMessageWindow"),

  // Entries and labels (6)
  guiLabel(30, "GuiLabel"),
  guiTextField(31, "GuiTextField"),
  guiCTextField(32, "GuiCTextField"),
  guiPasswordField(33, "GuiPasswordField"),
  guiComboBox(34, "GuiComboBox"),
  guiOkCodeField(35, "GuiOkCodeField"),

  // Action and state controls (4)
  guiButton(40, "GuiButton"),
  guiRadioButton(41, "GuiRadioButton"),
  guiCheckBox(42, "GuiCheckBox"),
  guiStatusPane(43, "GuiStatusPane"),

  // Containers and Shells (9)
  guiCustomControl(50, "GuiCustomControl"),
  guiContainerShell(51, "GuiContainerShell"),
  guiBox(62, "GuiBox"),
  guiContainer(70, "GuiContainer"),
  guiSimpleContainer(71, "GuiSimpleContainer"),
  guiScrollContainer(72, "GuiScrollContainer"),
  guiListContainer(73, "GuiListContainer"),
  guiUserArea(74, "GuiUserArea"),
  guiSplitterContainer(75, "GuiSplitterContainer"),

  // Tables and Columns/Rows (3)
  guiTableControl(80, "GuiTableControl"),
  guiTableColumn(81, "GuiTableColumn"),
  guiTableRow(82, "GuiTableRow"),

  // Tabs (2)
  guiTabStrip(90, "GuiTabStrip"),
  guiTab(91, "GuiTab"),

  // Bars (4)
  guiScrollbar(100, "GuiScrollbar"),
  guiToolbar(101, "GuiToolbar"),
  guiTitlebar(102, "GuiTitlebar"),
  guiStatusbar(103, "GuiStatusbar"),

  // Menus (2)
  guiMenu(110, "GuiMenu"),
  guiMenubar(111, "GuiMenubar"),

  // Collections and Advanced Shells (10)
  guiCollection(120, "GuiCollection"),
  guiSessionInfo(121, "GuiSessionInfo"),
  guiShell(122, "GuiShell"),
  guiGOSShell(123, "GuiGOSShell"),
  guiSplitterShell(124, "GuiSplitterShell"),
  guiDialogShell(125, "GuiDialogShell"),
  guiDockShell(126, "GuiDockShell"),
  guiComponentCollection(128, "GuiComponentCollection"),
  guiVHViewSwitch(129, "GuiVHViewSwitch"),
  guiStatusBarLink(130, "GuiStatusBarLink"),

  // Error / Unknown
  guiUnknown(-1, "Unknown");

  final int value;
  final String name;
  const GuiComponentType(this.value, this.name);

  static GuiComponentType fromInt(int val) {
    return GuiComponentType.values.firstWhere(
      (e) => e.value == val,
      orElse: () => GuiComponentType.guiUnknown,
    );
  }
}
