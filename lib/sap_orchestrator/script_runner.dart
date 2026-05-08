import 'dart:isolate';

import 'package:sap_gui_scripting/gui_classes/gui_application.dart';
import 'package:sap_gui_scripting/gui_classes/gui_session.dart';
import 'package:sap_gui_scripting/methods/sap_api.dart';
import 'package:sap_gui_scripting/methods/sap_object.dart';

/// Safe entrypoint wrapper. Always sends a response back to the orchestrator.
///
/// The [msg] map is provided by [SapOrchestrator._launch] and contains:
/// - `rootHandle`: pre-connected COM root handle (no need to call connect)
/// - `sessionId`: assigned SAP session index
/// - `args`: user-provided arguments
/// - `replyTo`: [SendPort] to send the result/error
///
/// ```dart
/// Future<void> getCustomerName(Map<String, dynamic> msg) async {
///   await runScriptSafely<String>(msg, (session, args) async {
///     session.startTransaction("XD03");
///     // ... automation logic ...
///     session.endTransaction();
///     return "result";
///   });
/// }
/// ```
Future<void> runScriptSafely<T>(
  Map<String, dynamic> msg,
  Future<T> Function(GuiSession session, dynamic args) fn,
) async {
  SendPort? replyTo;
  try {
    replyTo = msg['replyTo'] as SendPort;
    final rootHandle = msg['rootHandle'] as int;
    final sessionId = msg['sessionId'] as int;
    final args = msg['args'];

    final result = await useSapSession<T>(rootHandle, sessionId, (session) async {
      return await fn(session, args);
    });

    replyTo.send(result);
  } catch (e) {
    if (replyTo != null) {
      replyTo.send(Exception('$e'));
    }
  }
}

/// Use the pre-connected SAP root [rootHandle] to access session [sessionIndex]
/// and run [fn] with it. Does NOT call SapObject.connect() — reuses the
/// main isolate's COM connection.
Future<T> useSapSession<T>(
  int rootHandle,
  int sessionIndex,
  Future<T> Function(GuiSession) fn,
) async {
  final api = SapApi();
  api.initialize();

  final root = SapObject(rootHandle, api, owned: false);
  if (root.isInvalid) {
    throw Exception('Invalid root handle: $rootHandle');
  }

  final app = GuiApplication(root);
  if (app.connections.count == 0) {
    throw Exception('[Isolate] no SAP connections');
  }

  final connection = app.connections.item(0);
  final count = connection.children.count;

  if (count <= sessionIndex) {
    throw Exception('Session $sessionIndex not found (have $count)');
  }

  final session = connection.children.item(sessionIndex);
  return await fn(session);
}
