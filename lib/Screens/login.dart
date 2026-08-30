import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/providers/app_providers.dart';

class EntradaScreen extends ConsumerWidget {
  const EntradaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuariosValidos = ref.watch(usuariosProvider);
    final username = TextEditingController();
    final password = TextEditingController();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Usuario', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            TextField(
              controller: username,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            const Text('Contraseña', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                await ref.read(usuariosProvider.notifier).cargarUsuarios();

                final usuarioIngresado = username.text.trim();
                final passwordIngresada = password.text;

                if (usuarioIngresado.isEmpty || passwordIngresada.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, complete todos los campos'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                final validarUsuario = ref.read(usuariosProvider).any(
                  (usuario) =>
                      usuario.username == usuarioIngresado &&
                      usuario.password == passwordIngresada,
                );

                if (validarUsuario) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Bienvenido, $usuarioIngresado'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  username.clear();
                  password.clear();
                  context.go('/home');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Usuario o contraseña incorrecta'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  password.clear();
                }
              },
              child: const Text('Ingresar'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => context.push('/form'),
              icon: const Icon(Icons.person_add),
              label: const Text('Crear usuario'),
            ),
          ],
        ),
      ),
    );
  }
}
