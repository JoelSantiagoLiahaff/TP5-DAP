import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/providers/app_providers.dart';

// Formulario de ingreso: Firebase Authentication valida email y contraseña.
class EntradaScreen extends ConsumerWidget {
  const EntradaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
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
                  final email = emailController.text.trim();
                  final password = passwordController.text;
                  // Evita enviar credenciales incompletas a Firebase.
                  if (email.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor, complete todos los campos'),
                      ),
                    );
                    return;
                  }
                  try {
                    await iniciarSesion(email: email, password: password);
                    if (context.mounted) context.go('/home');
                  } catch (_) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Email o contraseña incorrectos'),
                        ),
                      );
                    }
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
      ),
    );
  }
}
