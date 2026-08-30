import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/providers/app_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instrumentos = ref.watch(instrumentosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Instrumentos'),
        actions: [
          IconButton(
            onPressed: () => context.push('/form'),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () => context.go('/login'),
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: instrumentos.length,
        itemBuilder: (context, index) {
          final instrumento = instrumentos[index];
          return Card(
            child: ListTile(
              title: Text(instrumento.nombre),
              leading: Image.network(
                instrumento.imagen,
                width: 50,
                height: 75,
                fit: BoxFit.cover,
              ),
              onTap: () => context.push('/detalle', extra: instrumento),
            ),
          );
        },
      ),
    );
  }
}
