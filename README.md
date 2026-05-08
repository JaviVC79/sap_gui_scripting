## ENGLISH

sap_gui_scripting
True Multi-threaded SAP GUI Automation for Dart.

This package provides a high-performance bridge between Dart and the SAP GUI Scripting API on Windows. Unlike traditional implementations, this driver utilizes a C++ core with STA (Single-Threaded Apartment) architecture, allowing for the simultaneous and parallel execution of multiple scripts across different SAP sessions without blocking the main thread.

## Features

🚀 True Multi-threading: Execute scripts in parallel using Dart Isolates.

🧠 SapOrchestrator: Intelligent session management (Session Pooling). Automatically creates and reuses SAP modes/sessions.

🛠 Intuitive API: Familiar methods for SAP developers (findCTextField, startTransaction, findButton, etc.).

🏗 Robust Architecture: C++ core that safely manages the COM lifecycle.

⏱ Efficiency: Designed for bulk extraction tasks or complex Robotic Process Automation (RPA).

## Getting started

Prerequisites
To use this package, ensure the following:

Windows OS: SAP GUI Scripting is only available on Windows.

SAP GUI Installed: The SAP Logon application must be installed on the machine.

Scripting Enabled:

Server-side (RZ11): sapgui/user_scripting must be set to TRUE.

Client-side: SAP GUI Options -> Accessibility & Scripting -> Scripting -> "Enable Scripting" must be checked.

Installation
Add the dependency to your pubspec.yaml:

YAML
dependencies:
  sap_gui_scripting: ^1.0.0

Compiling the DLL
Compile the Native Core
For the package to function, you must compile the included C++ engine. Ensure you have Microsoft Visual C++ (MSVC) installed (included with Visual Studio).

Run the following command in your project root (or wherever the .cpp files reside):

Bash
cl /LD v4.cpp /EHsc /std:c++17 ole32.lib oleaut32.lib /out:v4.dll

Configure the Path
Ensure the generated DLL (v4.dll) is in the same folder as your Dart executable or added to the system PATH.

## Usage

1. The Script (Worker)
Define your automation logic inside a top-level entry point.
The entry point receives a message map and calls `runScriptSafely<T>()` with your business logic.
Note: Always return to the main menu using session.endTransaction() so the session can be reused, or start your scripts with session.startTransaction("TRANSACTION_CODE").

Dart
import 'package:sap_gui_scripting/sap_orchestrator/script_runner.dart';

void getCustomerName(Map<String, dynamic> msg) async {
  await runScriptSafely<String>(msg, (session, args) async {
    session.startTransaction("XD03");
    session.findCTextField("wnd[0]/usr/ctxtRF02D-KUNNR")?.text = args.toString();
    session.findButton("wnd[0]/tbar[0]/btn[0]")?.press();
    
    String? name = session.findTextField("wnd[0]/usr/subSUBTAB:SAPLXD04:0101/txtKNA1-NAME1")?.text;
    
    session.endTransaction(); // Cleanup for the next process
    return name ?? "Not found";
  });
}
2. The Orchestrator (Main)
Manage parallel execution with ease.

Dart
void main() async {
  final orchestrator = SapOrchestrator();
  await orchestrator.initialize(); // Connects to SAP and takes control of Session 0

  // Launch multiple tasks without worrying about threads or sessions
  final f1 = orchestrator.runScript<String>(getCustomerName, "10025");
  final f2 = orchestrator.runScript<String>(getCustomerName, "10026");

  final results = await Future.wait([f1, f2]);
  print("Results: $results");
}

## Additional information

Internal Architecture
The package operates under a three-layer model to ensure Dart does not freeze during long SAP operations:

Dart Layer (Orchestrator): Session pool (1-5) managed with acquire/release. Each `runScript()` spawns a Dart isolate via `Isolate.spawn()` and passes the COM root handle + session ID through a message map. Awaits results via `ReceivePort`.

Isolation Layer (Isolates): Each script runs in its own Isolate. The entry point (top-level `void Function(Map<String, dynamic>)`) calls `runScriptSafely<T>()` which wraps the pre-connected COM handle and executes the user's business logic.

Native Layer (C++/COM): A single shared `static ComStaDispatcher` in v4.dll provides one STA thread for the entire process. All isolates share the same DLL instance and COM object map (`g_objects`), enabling true parallel access to SAP sessions without COM reinitialization per isolate.

Contributions
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

Bug Reports
If you encounter unexpected behavior, please create a report in the GitHub repository.

Legal Disclaimer
This package is not affiliated, associated, authorized, or officially endorsed by SAP SE.


## ESPAÑOL


sap_gui_scripting
True Multi-threaded SAP GUI Automation for Dart.

Este paquete proporciona un puente de alto rendimiento entre Dart y la API de SAP GUI Scripting en Windows. A diferencia de las implementaciones tradicionales, este driver utiliza un núcleo en C++ con arquitectura STA (Single-Threaded Apartment), lo que permite ejecutar múltiples scripts en diferentes sesiones de SAP de forma simultánea y paralela sin bloquear el hilo principal.

## Features

Características (Features)
🚀 Multihilo Real: Ejecuta scripts en paralelo usando Isolates de Dart.

🧠 SapOrchestrator: Gestión inteligente de sesiones (Session Pooling). Crea y reutiliza modos de SAP automáticamente.

🛠 API Intuitiva: Métodos familiares para desarrolladores de SAP (findCTextField, startTransaction, findButton, etc.).

🏗 Arquitectura Robusta: Núcleo en C++ que gestiona el ciclo de vida de COM de forma segura.

⏱ Eficiencia: Diseñado para tareas de extracción masiva o automatización de procesos complejos (RPA).

## Getting started

📋 Requisitos Previos (Prerequisites)
Para utilizar este paquete, debes asegurarte de que:

Windows OS: SAP GUI Scripting solo está disponible en Windows.

SAP GUI instalado: La aplicación SAP logon debe estar instalada en la máquina.

Scripting habilitado: * En el servidor (RZ11): sapgui/user_scripting debe ser TRUE.

En el cliente: Opciones de SAP GUI -> Accesibilidad y Scripting -> Scripting -> "Habilitar Scripting" activado.

🚀 Instalación (Getting Started)
Añade la dependencia a tu pubspec.yaml:

YAML
dependencies:
  sap_gui_scripting: ^1.0.0

🛠 Compilación del dll
1. Compilar el núcleo nativo
Para que el paquete funcione, debes compilar el motor C++ incluido. Asegúrate de tener instalado Microsoft Visual C++ (MSVC) (incluido en Visual Studio).

Ejecuta el siguiente comando en la raíz de tu proyecto (o donde residan los archivos .cpp):

Bash
cl /LD v4.cpp /EHsc /std:c++17 ole32.lib oleaut32.lib /out:v4.dll

2. Configurar el Path
Asegúrate de que la DLL generada (v4.dll) esté en la misma carpeta que tu ejecutable de Dart o añadida al PATH del sistema.

## Usage

💡 Uso (Usage)
1. El Script (Worker)
Define tu lógica de automatización dentro de un entry point de nivel superior.
El entry point recibe un mapa de mensaje y llama a `runScriptSafely<T>()` con tu lógica de negocio.
Recuerda volver siempre al menú principal con session.endTransaction() para que la sesión pueda ser reutilizada, 
o iniciar tus scripts con session.startTransaction("NOMBRE_TRANSACCION")

Dart
import 'package:sap_gui_scripting/sap_orchestrator/script_runner.dart';

void obtenerNombreCliente(Map<String, dynamic> msg) async {
  await runScriptSafely<String>(msg, (session, args) async {
    session.startTransaction("XD03");
    session.findCTextField("wnd[0]/usr/ctxtRF02D-KUNNR")?.text = args.toString();
    session.findButton("wnd[0]/tbar[0]/btn[0]")?.press();
    
    String? nombre = session.findTextField("wnd[0]/usr/subSUBTAB:SAPLXD04:0101/txtKNA1-NAME1")?.text;
    
    session.endTransaction(); // Limpieza para el siguiente proceso
    return nombre ?? "No encontrado";
  });
}
2. El Orquestador (Main)
Gestiona la ejecución paralela de forma sencilla.

Dart
void main() async {
  final orchestrator = SapOrchestrator();
  await orchestrator.initialize(); // Conecta con SAP y toma el control de la Sesión 0

  // Lanza múltiples tareas sin preocuparte por los hilos o sesiones
  final f1 = orchestrator.runScript<String>(obtenerNombreCliente, "10025");
  final f2 = orchestrator.runScript<String>(obtenerNombreCliente, "10026");

  final resultados = await Future.wait([f1, f2]);
  print("Resultados: $resultados");
}

## Additional information

🏗 Arquitectura (Internal Architecture)
El paquete opera bajo un modelo de tres capas para garantizar que Dart no se congele durante operaciones largas de SAP:

Capa Dart (Orchestrator): Pool de sesiones (1-5) gestionado con acquire/release. Cada `runScript()` lanza un isolate Dart vía `Isolate.spawn()` pasando el handle COM raíz + el ID de sesión mediante un mapa. Espera resultados vía `ReceivePort`.

Capa de Aislamiento (Isolates): Cada script corre en su propio Isolate. El entry point (`void Function(Map<String, dynamic>)` de nivel superior) llama a `runScriptSafely<T>()` que envuelve el handle COM pre-conectado y ejecuta la lógica de negocio del usuario.

Capa Nativa (C++/COM): Un único `static ComStaDispatcher` compartido en v4.dll provee un solo hilo STA para todo el proceso. Todos los isolates comparten la misma instancia de DLL y el mapa de objetos COM (`g_objects`), permitiendo acceso paralelo real a las sesiones SAP sin reinicializar COM por cada isolate.



🛠 Información Adicional
Contribuciones: ¡Las pull requests son bienvenidas! Para cambios mayores, por favor abre un issue primero para discutir lo que te gustaría cambiar.

Reporte de errores: Si encuentras un comportamiento inesperado, por favor crea un reporte en el repositorio de GitHub.

Aviso Legal: Este paquete no está afiliado, asociado, autorizado ni respaldado oficialmente por SAP SE.
