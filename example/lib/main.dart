import 'package:flutter/material.dart';
import 'package:sap_gui_scripting/sap_gui_scripting.dart';
import 'package:sap_scripting_app_exemple/scripts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final orchestrator = SapOrchestrator();
  orchestrator.initialize(maxSessions: 4);
  runApp(MyApp(orchestrator: orchestrator));
}

class MyApp extends StatelessWidget {
  final SapOrchestrator orchestrator;
  const MyApp({super.key, required this.orchestrator});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAP GUI Scripting Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(title: 'SAP GUI Scripting Demo', orchestrator: orchestrator),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final SapOrchestrator orchestrator;
  const MyHomePage({
    super.key,
    required this.title,
    required this.orchestrator,
  });
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _running1 = false;
  bool _running2 = false;
  bool _running3 = false;
  bool _initialized = false;
  String? _error;
  bool _retrying = false;

  @override
  void initState() {
    super.initState();
    _checkInit();
  }

  void _checkInit() {
    if (widget.orchestrator.isInitialized) {
      setState(() {
        _initialized = true;
        _error = null;
      });
    } else if (widget.orchestrator.isInitializing) {
      Future.delayed(const Duration(milliseconds: 300), _checkInit);
    } else {
      setState(() {
        _error = widget.orchestrator.lastError ?? 'Unknown error';
      });
    }
  }

  Future<void> _retry() async {
    setState(() {
      _retrying = true;
      _error = null;
    });
    final ok = await widget.orchestrator.initialize(maxSessions: 4);
    setState(() {
      _retrying = false;
      if (ok) {
        _initialized = true;
      } else {
        _error = widget.orchestrator.lastError ?? 'Unknown error';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (!_initialized) {
      return _buildLoadingOrError();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Free sessions: ${widget.orchestrator.freeSessionCount}'),
        const SizedBox(height: 20),
        _buildButton(
          label: 'run script 1',
          running: _running1,
          onRun: () => _runScript<String>(script1, (v) => _running1 = v),
        ),
        _buildButton(
          label: 'run script 2',
          running: _running2,
          onRun: () => _runScript<bool>(script2, (v) => _running2 = v),
        ),
        _buildButton(
          label: 'run script 3',
          running: _running3,
          onRun: () => _runScript<bool>(script3, (v) => _running3 = v),
        ),
      ],
    );
  }

  Widget _buildLoadingOrError() {
    if (_retrying || widget.orchestrator.isInitializing) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            _retrying ? 'Reconnecting to SAP...' : 'Connecting to SAP...',
          ),
          const SizedBox(height: 8),
          Text(
            'Free sessions: ${widget.orchestrator.freeSessionCount}',
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.cloud_off, size: 64, color: Colors.red),
        const SizedBox(height: 16),
        const Text('SAP not available', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        Text(_error ?? '', style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: _retry,
          icon: const Icon(Icons.refresh),
          label: const Text('Retry'),
        ),
      ],
    );
  }

  Widget _buildButton({
    required String label,
    required bool running,
    required Future<void> Function() onRun,
  }) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all<Color>(Colors.blue),
      ),
      onPressed: running ? null : onRun,
      child: Text(label),
    );
  }

  Future<void> _runScript<T>(
    void Function(Map<String, dynamic>) entryPoint,
    void Function(bool) setRunning,
  ) async {
    setState(() => setRunning(true));
    try {
      final result = await widget.orchestrator.runScript<T>(entryPoint, null);
      print('Script result: $result');
    } catch (e) {
      print('Script error: $e');
    } finally {
      setState(() => setRunning(false));
    }
  }
}
