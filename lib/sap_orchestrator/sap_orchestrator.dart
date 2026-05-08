import 'dart:async';
import 'dart:isolate';

import 'package:sap_gui_scripting/gui_classes/gui_application.dart';
import 'package:sap_gui_scripting/methods/sap_api.dart';
import 'package:sap_gui_scripting/methods/sap_object.dart';

/// SAP GUI Scripting session pool + per-script [Isolate.spawn] executor.
///
/// Connects to SAP once and manages sessions. Scripts run in their own
/// Dart isolate, using the DLL's shared COM dispatcher (v4.dll with
/// static [ComStaDispatcher]).
///
/// ```dart
/// final orchestrator = SapOrchestrator();
///
/// // Fire-and-forget: the widget reacts to isInitialized / isInitializing
/// orchestrator.initialize(maxSessions: 12);
///
/// // myScript is a top-level function in your app:
/// // void myScript(Map<String, dynamic> msg) async {
/// //   await runScriptSafely<String>(msg, (session, args) async {
/// //     return "result";
/// //   });
/// // }
///
/// // Wait for initialization before running scripts:
/// if (orchestrator.isInitialized) {
///   final result = await orchestrator.runScript<String>(myScript, "XD03");
/// }
/// ```
class SapOrchestrator {
  static final SapOrchestrator _instance = SapOrchestrator._internal();
  factory SapOrchestrator() => _instance;
  SapOrchestrator._internal();

  int _maxSessions = 6;

  /// Max number of SAP sessions managed by the pool.
  /// Set via [initialize]. Session 0 is reserved, worker sessions
  /// are indices 1..maxSessions-1.
  int get maxSessions => _maxSessions;

  /// Max number of callers allowed to wait for a free session.
  /// Further calls to [runScript] throw immediately.
  int maxWaiting = 20;

  final Set<int> _freeSessions = {};
  final Set<int> _busySessions = {};
  int _waitingCount = 0;
  bool _initialized = false;
  bool _initializing = false;
  GuiApplication? _app;
  int _rootHandle = 0;
  String? _lastError;

  bool get isInitialized => _initialized;
  bool get isInitializing => _initializing;
  int get freeSessionCount => _freeSessions.length;
  String? get lastError => _lastError;

  /// Connect to SAP and create session pool.
  ///
  /// [maxSessions] sets the total number of SAP sessions (default 6).
  /// Session 0 is reserved; scripts use indices 1..maxSessions-1.
  ///
  /// Returns `true` on success, `false` on failure.
  /// On failure, check [lastError] for the reason.
  Future<bool> initialize({int maxSessions = 6}) async {
    if (_initialized) return true;
    if (_initializing) return false;
    _maxSessions = maxSessions;
    _initializing = true;
    _lastError = null;
    try {
      final api = SapApi();
      api.initialize();

      final root = SapObject.connect(api);
      if (root == null) {
        _lastError = 'Failed to connect to SAP (Sap_Connect returned 0)';
        return false;
      }

      _rootHandle = root.handle;

      _app = GuiApplication(root);
      if (_app!.connections.count == 0) {
        _lastError = 'No SAP connections available';
        return false;
      }

      final connection = _app!.connections.item(0);
      int currentCount = connection.children.count;

      for (currentCount; currentCount < maxSessions; currentCount++) {
        connection.children.item(0).createSession();
        await Future.delayed(const Duration(seconds: 4));
      }

      // Session 0 reserved, worker sessions 1..maxSessions-1
      for (int i = 1; i < maxSessions; i++) {
        _freeSessions.add(i);
      }

      _initialized = true;
      return true;
    } catch (e) {
      _lastError = 'Unexpected error: $e';
      return false;
    } finally {
      _initializing = false;
    }
  }

  /// Spawn [entryPoint] in a new isolate with [args].
  ///
  /// [entryPoint] must be a top-level or static function matching
  /// `void Function(Map<String, dynamic>)`. It receives:
  /// - `rootHandle`: pre-connected COM root handle
  /// - `sessionId`: assigned SAP session index
  /// - `args`: user-provided [args]
  /// - `replyTo`: [SendPort] to send the result/error back
  ///
  /// Inside [entryPoint], call [runScriptSafely]:
  /// ```dart
  /// void myScript(Map<String, dynamic> msg) async {
  ///   await runScriptSafely<String>(msg, (session, args) async {
  ///     session.startTransaction("XD03");
  ///     return "done";
  ///   });
  /// }
  /// ```
  ///
  /// Throws if the orchestrator is not initialized, if too many callers
  /// are already waiting ([maxWaiting]), or if the script fails.
  Future<T> runScript<T>(
    void Function(Map<String, dynamic>) entryPoint,
    dynamic args,
  ) async {
    if (!_initialized) {
      throw Exception('Orchestrator not initialized');
    }

    final sessionId = await _acquireSession();

    try {
      final receivePort = ReceivePort();

      final msg = <String, dynamic>{
        'rootHandle': _rootHandle,
        'sessionId': sessionId,
        'args': args,
        'replyTo': receivePort.sendPort,
      };

      Isolate.spawn(entryPoint, msg);

      final result = await receivePort.first;
      receivePort.close();

      if (result is Exception) {
        throw result;
      }

      return result as T;
    } catch (e) {
      rethrow;
    } finally {
      _releaseSession(sessionId);
    }
  }

  Future<int> _acquireSession() async {
    if (_waitingCount >= maxWaiting) {
      throw Exception(
        'Too many scripts waiting for a free session '
        '(limit: $maxWaiting). Try again later.',
      );
    }
    _waitingCount++;
    try {
      while (_freeSessions.isEmpty) {
        await Future.delayed(const Duration(milliseconds: 200));
      }
      final id = _freeSessions.first;
      _freeSessions.remove(id);
      _busySessions.add(id);
      return id;
    } finally {
      _waitingCount--;
    }
  }

  void _releaseSession(int id) {
    _busySessions.remove(id);
    _freeSessions.add(id);
  }
}
