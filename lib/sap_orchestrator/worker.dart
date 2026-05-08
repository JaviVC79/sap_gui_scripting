// Architecture: per-script Isolate.spawn via SapOrchestrator.runScript().
//
// The orchestrator manages a session pool. Each script runs in its own
// Dart isolate spawned with Isolate.spawn. The isolate receives the
// COM root handle shared via the static ComStaDispatcher in v4.dll.
//
// Within the isolate, scripts use runScriptSafely() / useSapSession()
// from script_runner.dart to access the SAP session.
//
// No persistent worker — one isolate per script invocation.
