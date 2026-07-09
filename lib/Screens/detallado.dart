import 'package:flutter/material.dart';
import 'package:myapp/Listas/datos.dart';

class DetalladoScreen extends StatelessWidget {
  final Instrumentos instrumento;

  const DetalladoScreen({
    super.key,
    required this.instrumento,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(instrumento.nombre),
      ),
      body: Center(
        child: Column(
          children: [
            Image.network(
              instrumento.imagen,
              width: 300,
              height: 300,
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
          ],
        ),
      ),
    );
  }
}