import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/route/app_router.dart';
import 'firebase_options.dart';

// Punto de entrada de la aplicación.
// Se inicializa Riverpod para que todos los providers queden disponibles en la app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Object? initializationError;
  try {
    // Firebase debe estar disponible antes de crear providers que lo consulten.
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error) {
    initializationError = error;
  }

  runApp(
    ProviderScope(
      child: initializationError == null
          ? const MyApp()
          : FirebaseSetupErrorApp(error: initializationError),
    ),
  );
}

// Evita una pantalla en blanco y muestra el motivo si falla la configuración.
class FirebaseSetupErrorApp extends StatelessWidget {
  final Object error;

  const FirebaseSetupErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.cloud_off, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    'Falta configurar Firebase para esta plataforma',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'En la terminal, desde la carpeta del proyecto, ejecuta '
                    '`flutterfire configure` y selecciona Web. Luego vuelve a '
                    'iniciar la aplicación.',
                  ),
                  const SizedBox(height: 16),
                  SelectableText('Detalle: $error'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Provee Riverpod y la navegación declarativa configurada con GoRouter.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: appRouter);
  }
}