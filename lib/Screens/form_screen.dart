import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/Listas/datos.dart';
import 'package:myapp/providers/app_providers.dart';

// Formulario compartido: crea cuentas o agrega y modifica instrumentos.
class FormScreen extends ConsumerStatefulWidget {
  final Object? initialValue;

  const FormScreen({super.key, this.initialValue});

  @override
  ConsumerState<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends ConsumerState<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreController;
  late final TextEditingController _descripcionController;
  late final TextEditingController _imagenController;
  late final TextEditingController _usoController;
  late final TextEditingController _tipoController;
  late final TextEditingController _nombreUsuarioController;
  late final TextEditingController _emailUsuarioController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  bool _isInstrumentForm = true;

  // Convierte los códigos técnicos de Firebase en mensajes comprensibles.
  String _registroError(FirebaseAuthException error) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'Ya existe una cuenta con ese email';
      case 'invalid-email':
        return 'El email no tiene un formato válido';
      case 'weak-password':
        return 'La contraseña es demasiado débil';
      case 'network-request-failed':
        return 'No hay conexión con Firebase';
      default:
        return 'No se pudo crear la cuenta';
    }
  }

  @override
  void initState() {
    super.initState();
    final extra = widget.initialValue;
    // Los datos recibidos por la ruta determinan el modo y los valores iniciales.
    if (extra == 'usuario') {
      _isInstrumentForm = false;
      _nombreController = TextEditingController();
      _descripcionController = TextEditingController();
      _imagenController = TextEditingController();
      _usoController = TextEditingController();
      _tipoController = TextEditingController();
      _nombreUsuarioController = TextEditingController();
      _emailUsuarioController = TextEditingController();
      _passwordController = TextEditingController();
      _confirmPasswordController = TextEditingController();
    } else if (extra is Instrumentos) {
      _isInstrumentForm = true;
      _nombreController = TextEditingController(text: extra.nombre);
      _descripcionController = TextEditingController(text: extra.descripcion);
      _imagenController = TextEditingController(text: extra.imagen);
      _usoController = TextEditingController(text: extra.uso);
      _tipoController = TextEditingController(text: extra.tipo);
      _nombreUsuarioController = TextEditingController();
      _emailUsuarioController = TextEditingController();
      _passwordController = TextEditingController();
      _confirmPasswordController = TextEditingController();
    } else if (extra is Datos) {
      _isInstrumentForm = false;
      _nombreController = TextEditingController();
      _descripcionController = TextEditingController();
      _imagenController = TextEditingController();
      _usoController = TextEditingController();
      _tipoController = TextEditingController();
      _nombreUsuarioController = TextEditingController(text: extra.nombre);
      _emailUsuarioController = TextEditingController(text: extra.email);
      _passwordController = TextEditingController(text: extra.password);
      _confirmPasswordController = TextEditingController(text: extra.password);
    } else {
      _nombreController = TextEditingController();
      _descripcionController = TextEditingController();
      _imagenController = TextEditingController();
      _usoController = TextEditingController();
      _tipoController = TextEditingController();
      _nombreUsuarioController = TextEditingController();
      _emailUsuarioController = TextEditingController();
      _passwordController = TextEditingController();
      _confirmPasswordController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _imagenController.dispose();
    _usoController.dispose();
    _tipoController.dispose();
    _nombreUsuarioController.dispose();
    _emailUsuarioController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final extra = widget.initialValue;
    final isEditingInstrument = extra is Instrumentos;
    final isEditingUser = extra is Datos;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditingInstrument
            ? 'Editar instrumento'
            : isEditingUser
                ? 'Editar usuario'
                : 'Crear nuevo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (!isEditingUser)
                SwitchListTile(
                  title: const Text('Formulario de instrumento'),
                  value: _isInstrumentForm,
                  onChanged: (value) {
                    setState(() {
                      _isInstrumentForm = value;
                    });
                  },
                ),
              if (_isInstrumentForm && !isEditingUser)
                Column(
                  children: [
                    TextFormField(
                      controller: _nombreController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Campo obligatorio' : null,
                    ),
                    TextFormField(
                      controller: _descripcionController,
                      decoration: const InputDecoration(labelText: 'Descripción'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Campo obligatorio' : null,
                    ),
                    TextFormField(
                      controller: _imagenController,
                      decoration: const InputDecoration(labelText: 'URL de imagen'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Campo obligatorio' : null,
                    ),
                    TextFormField(
                      controller: _usoController,
                      decoration: const InputDecoration(labelText: 'Uso'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Campo obligatorio' : null,
                    ),
                    TextFormField(
                      controller: _tipoController,
                      decoration: const InputDecoration(labelText: 'Tipo'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Campo obligatorio' : null,
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    TextFormField(
                      controller: _nombreUsuarioController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      validator: (value) =>
                          value == null || value.trim().isEmpty ? 'Campo obligatorio' : null,
                    ),
                    TextFormField(
                      controller: _emailUsuarioController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Campo obligatorio';
                        }
                        final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                        if (!emailRegex.hasMatch(value.trim())) {
                          return 'Email inválido';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Contraseña'),
                      validator: (value) =>
                          value == null || value.length < 6 ? 'Mínimo 6 caracteres' : null,
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Confirmar contraseña'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obligatorio';
                        }
                        if (value != _passwordController.text) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // No se envían datos hasta que todos los validadores sean correctos.
                  if (_formKey.currentState!.validate()) {
                    if (_isInstrumentForm || isEditingInstrument) {
                      final instrumento = Instrumentos(
                        // Al editar se conserva el ID; al crear, Firestore asigna uno.
                        id: (extra is Instrumentos ? extra.id : DateTime.now().millisecondsSinceEpoch.toString()),
                        nombre: _nombreController.text.trim(),
                        descripcion: _descripcionController.text.trim(),
                        imagen: _imagenController.text.trim(),
                        uso: _usoController.text.trim(),
                        tipo: _tipoController.text.trim(),
                      );

                      try {
                        if (extra is Instrumentos) {
                          await ref
                              .read(instrumentosProvider.notifier)
                              .actualizar(instrumento);
                        } else {
                          await ref
                              .read(instrumentosProvider.notifier)
                              .agregar(instrumento);
                        }
                      } catch (_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No se pudo guardar el instrumento'),
                            ),
                          );
                        }
                        return;
                      }
                    } else {
                      try {
                        await registrarUsuario(
                          nombre: _nombreUsuarioController.text.trim(),
                          email: _emailUsuarioController.text.trim(),
                          password: _passwordController.text,
                        );
                      } on FirebaseAuthException catch (error) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(_registroError(error)),
                            ),
                          );
                        }
                        return;
                      }
                    }
                    if (context.mounted) context.pop();
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
