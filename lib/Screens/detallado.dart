import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/Listas/datos.dart';
import 'package:myapp/providers/app_providers.dart';

class DetalladoScreen extends ConsumerWidget {
  final Instrumentos instrumento;

  const DetalladoScreen({
    super.key,
    required this.instrumento,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(instrumento.nombre),
      ),
      body: Center(
        child: Column(
          children: [
            Image.network(
              instrumento.imagen,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Text(
              instrumento.nombre,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                instrumento.descripcion,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Uso: ${instrumento.uso}',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Tipo: ${instrumento.tipo}',
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
                    context.push('/form', extra: instrumento);
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Modificar'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(instrumentosProvider.notifier).eliminar(instrumento.id);
                    context.pop();
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