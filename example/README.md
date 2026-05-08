# SAP GUI Scripting Example

Flutter Windows app demonstrating the `sap_gui_scripting` package.

## Prerequisites

- Windows OS with SAP GUI installed
- SAP GUI Scripting enabled (server + client side)
- `v4.dll` compiled and placed in the app's directory (see package README)

## Run

```bash
flutter pub get
flutter run -d windows
```

This example shows the `SapOrchestrator` session pool with parallel script execution via `Isolate.spawn`.
