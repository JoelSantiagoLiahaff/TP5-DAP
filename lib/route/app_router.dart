import 'package:go_router/go_router.dart';
import 'package:myapp/Listas/datos.dart';
import 'package:myapp/Screens/detallado.dart';
import 'package:myapp/Screens/form_screen.dart';
import 'package:myapp/Screens/home_screen.dart';
import 'package:myapp/Screens/login.dart';

// Configuración central de navegación de la aplicación.
// Define las rutas principales y qué pantalla se muestra en cada una.
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
        // Se recibe el instrumento seleccionado como dato extra para mostrar su detalle.
        instrumento: state.extra as Instrumentos,
      ),
    ),
    GoRoute(
      path: '/form',
      // La pantalla de formulario se reutiliza para crear o editar datos.
      builder: (context, state) => FormScreen(initialValue: state.extra ?? 'usuario'),
    ),
  ],
);