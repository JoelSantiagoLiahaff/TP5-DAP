import 'package:go_router/go_router.dart';
import 'package:myapp/Listas/datos.dart';
import 'package:myapp/Screens/detallado.dart';
import 'package:myapp/Screens/form_screen.dart';
import 'package:myapp/Screens/home_screen.dart';
import 'package:myapp/Screens/login.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
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
        instrumento: state.extra as Instrumentos,
      ),
    ),
    GoRoute(
      path: '/form',
      builder: (context, state) => FormScreen(initialValue: state.extra),
    ),
  ],
);