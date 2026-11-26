import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/Listas/datos.dart';
import 'package:myapp/providers/app_providers.dart';

// Presenta el instrumento seleccionado y permite modificarlo o eliminarlo.
class DetalladoScreen extends ConsumerWidget {
  final Instrumentos instrumento;

  const DetalladoScreen({
    super.key,
    required this.instrumento,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Usa la versión más reciente recibida de Firestore, no una copia desactualizada.
    final lista = ref.watch(instrumentosStreamProvider);
    final instrumentoActual = lista.when(
      data: (items) {
        for (final item in items) {
          if (item.id == instrumento.id) return item;
        }
        return instrumento;
      },
      loading: () => instrumento,
      error: (_, _) => instrumento,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(instrumentoActual.nombre),
      ),
      body: Center(
        child: Column(
          children: [
            Image.network(
              instrumento.imagen,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const Icon(Icons.broken_image),
            ),
            const SizedBox(height: 20),
            Text(
              instrumentoActual.nombre,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                instrumentoActual.descripcion,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Uso: ${instrumentoActual.uso}',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Tipo: ${instrumentoActual.tipo}',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    context.push('/form', extra: instrumentoActual);
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Modificar'),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      await ref
                          .read(instrumentosProvider.notifier)
                          .eliminar(instrumentoActual.id);
                      if (context.mounted) context.pop();
                    } catch (_) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No se pudo eliminar el elemento'),
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Eliminar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}