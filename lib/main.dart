import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/route/app_router.dart';

// Punto de entrada de la aplicación.
// Se inicializa Riverpod para que todos los providers queden disponibles en la app.
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

// Componente raíz de la aplicación.
// MaterialApp.router permite usar navegación declarativa con GoRouter.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: appRouter);
  }
}