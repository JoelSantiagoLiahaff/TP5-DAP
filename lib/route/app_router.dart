import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/Listas/datos.dart';
import 'package:myapp/Screens/detallado.dart';
import 'package:myapp/Screens/form_screen.dart';
import 'package:myapp/Screens/home_screen.dart';
import 'package:myapp/Screens/login.dart';

// Notifica a GoRouter cuando cambia la sesión para volver a evaluar el acceso.
class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(Stream<User?> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<User?> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final _authRefreshNotifier =
    _AuthRefreshNotifier(FirebaseAuth.instance.authStateChanges());

// Configura las rutas y restringe las pantallas privadas a usuarios autenticados.
final appRouter = GoRouter(
  initialLocation: '/login',
  refreshListenable:
      _authRefreshNotifier,
  redirect: (context, state) {
    final loggedIn = FirebaseAuth.instance.currentUser != null;
    // Sin sesión solo se permiten el ingreso y el formulario de registro.
    if (!loggedIn && state.matchedLocation != '/login' &&
        state.matchedLocation != '/form') {
      return '/login';
    }
    if (loggedIn && (state.matchedLocation == '/login')) {
      return '/home';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const EntradaScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/detalle',
      builder: (context, state) => DetalladoScreen(
        // El listado entrega el instrumento seleccionado como dato de la ruta.
        instrumento: state.extra as Instrumentos,
      ),
    ),
    GoRoute(
      path: '/form',
      // Se reutiliza el formulario para registrar usuarios y editar/crear instrumentos.
      builder: (context, state) => FormScreen(initialValue: state.extra ?? 'usuario'),
    ),
  ],
);