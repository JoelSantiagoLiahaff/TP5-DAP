import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/Listas/datos.dart';
import 'package:myapp/providers/app_providers.dart';

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
  late final TextEditingController _usuarioController;
  late final TextEditingController _passwordController;
  bool _isInstrumentForm = true;

  @override
  void initState() {
    super.initState();
    final extra = widget.initialValue;
    if (extra is Instrumentos) {
      _isInstrumentForm = true;
      _nombreController = TextEditingController(text: extra.nombre);
      _descripcionController = TextEditingController(text: extra.descripcion);
      _imagenController = TextEditingController(text: extra.imagen);
      _usuarioController = TextEditingController();
      _passwordController = TextEditingController();
    } else if (extra is Datos) {
      _isInstrumentForm = false;
      _nombreController = TextEditingController();
      _descripcionController = TextEditingController();
      _imagenController = TextEditingController();
      _usuarioController = TextEditingController(text: extra.username);
      _passwordController = TextEditingController(text: extra.password);
    } else {
      _nombreController = TextEditingController();
      _descripcionController = TextEditingController();
      _imagenController = TextEditingController();
      _usuarioController = TextEditingController();
      _passwordController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _imagenController.dispose();
    _usuarioController.dispose();
    _passwordController.dispose();
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
                  ],
                )
              else
                Column(
                  children: [
                    TextFormField(
                      controller: _usuarioController,
                      decoration: const InputDecoration(labelText: 'Usuario'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Campo obligatorio' : null,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Contraseña'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Campo obligatorio' : null,
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_isInstrumentForm || isEditingInstrument) {
                      final instrumento = Instrumentos(
                        id: (extra is Instrumentos ? extra.id : DateTime.now().millisecondsSinceEpoch.toString()),
                        nombre: _nombreController.text.trim(),
                        descripcion: _descripcionController.text.trim(),
                        imagen: _imagenController.text.trim(),
                      );

                      if (extra is Instrumentos) {
                        ref.read(instrumentosProvider.notifier).actualizar(instrumento);
                      } else {
                        ref.read(instrumentosProvider.notifier).agregar(instrumento);
                      }
                    } else {
                      final usuario = Datos(
                        username: _usuarioController.text.trim(),
                        password: _passwordController.text.trim(),
                      );

                      if (extra is Datos) {
                        await ref.read(usuariosProvider.notifier).actualizar(usuario);
                      } else {
                        await ref.read(usuariosProvider.notifier).agregar(usuario);
                      }
                    }
                    context.pop();
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
