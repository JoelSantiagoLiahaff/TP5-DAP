import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/providers/app_providers.dart';

// Muestra en tiempo real los instrumentos de Firestore para el usuario autenticado.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instrumentos = ref.watch(instrumentosStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Instrumentos'),
        actions: [
          IconButton(
            onPressed: () => context.push('/form'),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () async {
              await cerrarSesion();
              if (context.mounted) context.go('/login');
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: instrumentos.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        // Los errores de lectura se muestran en pantalla en lugar de ocultarse.
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (items) => items.isEmpty
            ? const Center(child: Text('No hay instrumentos registrados'))
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final instrumento = items[index];
                  return Card(
                    child: ListTile(
                      title: Text(instrumento.nombre),
                      subtitle: Text(instrumento.uso),
                      leading: Image.network(
                        instrumento.imagen,
                        width: 50,
                        height: 75,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            const Icon(Icons.broken_image),
                      ),
                      onTap: () =>
                          context.push('/detalle', extra: instrumento),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
