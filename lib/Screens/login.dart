import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/Listas/datos.dart';

class EntradaScreen extends StatefulWidget {
  const EntradaScreen({super.key});

  @override
  State<EntradaScreen> createState() => _EntradaScreenState();
}

class _EntradaScreenState extends State<EntradaScreen> {
  final List<Datos> usuariosValidos = [
    Datos(username: 'admin', password: '123456'),
    Datos(username: 'Joel', password: '2008'),
    Datos(username: 'Santiago', password: 'contraseña'),
  ];

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {
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
      
                final validarUsuario = usuariosValidos.firstWhere(
                  (usuario) => usuario.username == usuarioIngresado && usuario.password == passwordIngresada,
                  orElse: () => Datos(username: '', password: ''),
                ).username.isNotEmpty;

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
          ],
        ),
      ),
    );
  }
}
