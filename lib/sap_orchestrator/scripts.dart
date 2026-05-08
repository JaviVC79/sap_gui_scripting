// Scripts are defined by the app developer, not in the package.
// See the example app at sap_scripting_app_exemple/lib/scripts.dart
// for reference implementations.
//
// Script entry points must be top-level or static functions matching
// `void Function(Map<String, dynamic>)`. They receive a map with
// rootHandle, sessionId, args, and replyTo.
//
// Inside the entry point, call runScriptSafely<T>() from script_runner.dart:
//
// ```dart
// void getCustomerName(Map<String, dynamic> msg) async {
//   await runScriptSafely<String>(msg, (session, args) async {
//     session.startTransaction("XD03");
//     // ... automation logic ...
//     session.endTransaction();
//     return "Acme Corp";
//   });
// }
// ```
//
// Then run from the orchestrator:
// ```dart
// final result = await orchestrator.runScript<String>(getCustomerName, null);
// ```
