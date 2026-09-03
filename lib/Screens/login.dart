import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/providers/app_providers.dart';

class EntradaScreen extends ConsumerWidget {
  const EntradaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuariosValidos = ref.watch(usuariosProvider);
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Email', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            const Text('Contraseña', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                await ref.read(usuariosProvider.notifier).cargarUsuarios();

                final emailIngresado = emailController.text.trim();
                final passwordIngresada = passwordController.text;

                if (emailIngresado.isEmpty || passwordIngresada.isEmpty) {
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
                      usuario.email == emailIngresado &&
                      usuario.password == passwordIngresada,
                );

                if (validarUsuario) {
                  ref.read(authProvider.notifier).login();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Bienvenido, $emailIngresado'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  emailController.clear();
                  passwordController.clear();
                  context.go('/home');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Email o contraseña incorrectos'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  passwordController.clear();
                }
              },
              child: const Text('Ingresar'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => context.push('/form', extra: 'usuario'),
              icon: const Icon(Icons.person_add),
              label: const Text('Crear usuario'),
            ),
          ],
        ),
      ),
    );
  }
}
