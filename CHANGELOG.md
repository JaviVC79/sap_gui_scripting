## 0.0.1

- Initial release.
- Native C++/COM bridge via FFI with STA dispatcher for thread-safe SAP GUI access.
- `SapOrchestrator` session pool with per-script `Isolate.spawn` execution.
- `SapObject` and `SapApi` low-level FFI wrappers for all SAP GUI Scripting properties and methods.
- Full set of typed SAP GUI component wrappers (71 classes): GuiSession, GuiApplication,
  GuiMainWindow, GuiButton, GuiTextField, GuiTableControl, GuiTree, GuiToolbar, etc.
- `runScriptSafely` / `useSapSession` helpers for safe script execution in isolates.
- `GuiComponentType` enum mapping all SAP GUI component type numbers.
- `ISapApi` and `ISapObject` interfaces for mocking and testing.
- 360+ unit tests covering core FFI bridge and all GUI component wrappers.
