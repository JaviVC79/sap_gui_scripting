import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart' as path;

DynamicLibrary loadSapBridgeDll() {
  if (!Platform.isWindows) {
    throw UnsupportedError(
      'SAP GUI Scripting only works on Windows.',
    );
  }

  final pathsToTry = <String>[];

  // 1. Same directory as the executable (works for both dart run and Flutter release builds)
  final exePath = Platform.resolvedExecutable;
  final exeDir = path.dirname(exePath);
  pathsToTry.add(path.join(exeDir, 'v4.dll'));

  // 2. Flutter debug/development: DLL next to the Dart entry point
  //    In Flutter Windows apps, Platform.script points to the kernel dill or source
  final scriptDir = path.dirname(Platform.script.toFilePath());
  pathsToTry.add(path.join(scriptDir, 'v4.dll'));
  pathsToTry.add(path.join(scriptDir, 'lib', 'SAP_dll', 'v4.dll'));

  // 3. Current working directory (for dart run from project root)
  final cwd = Directory.current.path;
  pathsToTry.add(path.join(cwd, 'v4.dll'));
  pathsToTry.add(path.join(cwd, 'lib', 'SAP_dll', 'v4.dll'));

  // 4. Flutter Windows build tree: executable is at
  //    build/windows/x64/runner/Debug/app.exe
  //    Navigate up 5 levels to reach the project root
  final exeDirName = path.basename(exeDir);
  if (exeDirName == 'Debug' || exeDirName == 'Release' || exeDirName == 'Profile') {
    var current = exeDir;
    for (int i = 0; i < 5; i++) {
      current = path.dirname(current);
    }
    final projectRoot = current;
    pathsToTry.add(path.join(projectRoot, 'v4.dll'));
    pathsToTry.add(path.join(projectRoot, 'lib', 'SAP_dll', 'v4.dll'));

    // Also try the build/ directory itself (some setups copy DLL there)
    final buildDir = path.dirname(path.dirname(path.dirname(path.dirname(exeDir))));
    pathsToTry.add(path.join(buildDir, 'v4.dll'));
  }

  // Deduplicate
  final tried = <String>{};
  for (final p in pathsToTry) {
    final normalized = path.normalize(p);
    if (tried.contains(normalized)) continue;
    tried.add(normalized);

    if (File(normalized).existsSync()) {
      return DynamicLibrary.open(normalized);
    }
  }

  throw ArgumentError(
    'v4.dll was not found. Searched locations:\n'
    '${tried.map((p) => '- $p').join('\n')}\n\n'
    'Copy v4.dll to one of these directories or add it to the system PATH.',
  );
}
