import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/Listas/datos.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InstrumentosNotifier extends Notifier<List<Instrumentos>> {
  @override
  List<Instrumentos> build() => [
        Instrumentos(
          id: '1',
          nombre: 'Bateria',
          descripcion:
              'Instrumento de percucion compuesto por varios instrumentos, platillos, bombos, etc',
          imagen:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR1XVKK4R0tCQ_cnUDJ2fbgHFHejVIyFy5hyrJpjWCLzA&s=10',
        ),
        Instrumentos(
          id: '2',
          nombre: 'Guitarra',
          descripcion:
              'Instrumento de cuerdas, que puede ser acustico o electrica, con o sin cuerdas',
          imagen:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjCxeLaxy_7yuwC7jtAyDypHcYqboJ6fvpeJmarmbYag&s=10',
        ),
        Instrumentos(
          id: '3',
          nombre: 'Bajo',
          descripcion:
              'Instrumento de cuerdas electrico, caraacterizado por ser grave',
          imagen:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2ARsIjZRAialXWeNc6iHPYzaBnu7VbB3sw3DULnqypg&s=10',
        ),
        Instrumentos(
          id: '4',
          nombre: 'Piano',
          descripcion:
              'Instrumento de teclas, que puede ser acustico o electrico, con o sin cuerdas',
          imagen:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTlTkyVVwjkoMts1mspuHx1JS8FFl_cTkEj_PtoLLVeg&s=10',
        ),
        Instrumentos(
          id: '5',
          nombre: 'Saxofon',
          descripcion:
              'Instrumento de viento, caracterizado por ser de metal y usado principalmente en jazz',
          imagen:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgaXZc8wMiYQZuIYSacwt2zH-MICI9CFFfCDD_kKfnmw&s=10',
        ),
      ];

  void agregar(Instrumentos instrumento) {
    state = [...state, instrumento];
  }

  void actualizar(Instrumentos instrumento) {
    state = [
      for (final item in state)
        if (item.id == instrumento.id) instrumento else item,
    ];
  }

  void eliminar(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}

class UsuariosNotifier extends Notifier<List<Datos>> {
  static const String _storageKey = 'usuarios_guardados';

  static final List<Datos> _usuariosBase = [
    Datos(username: 'admin', password: '123456'),
    Datos(username: 'Joel', password: '2008'),
    Datos(username: 'Santiago', password: 'contraseña'),
  ];

  @override
  List<Datos> build() => [..._usuariosBase];

  Future<void> cargarUsuarios() async {
    final prefs = await SharedPreferences.getInstance();
    final usuariosGuardados = prefs.getStringList(_storageKey);

    if (usuariosGuardados == null || usuariosGuardados.isEmpty) {
      state = [..._usuariosBase];
      return;
    }

    final usuariosPersistidos = usuariosGuardados.map((usuarioJson) {
      final usuarioMap = jsonDecode(usuarioJson) as Map<String, dynamic>;
      return Datos(
        username: usuarioMap['username'] as String,
        password: usuarioMap['password'] as String,
      );
    }).toList();

    state = [
      ..._usuariosBase,
      ...usuariosPersistidos.where(
        (usuario) => !_usuariosBase.any((base) => base.username == usuario.username),
      ),
    ];
  }

  Future<void> _guardarUsuarios() async {
    final prefs = await SharedPreferences.getInstance();
    final usuariosGuardados = state
        .map((usuario) => jsonEncode({
              'username': usuario.username,
              'password': usuario.password,
            }))
        .toList();

    await prefs.setStringList(_storageKey, usuariosGuardados);
  }

  Future<void> agregar(Datos usuario) async {
    if (state.any((item) => item.username == usuario.username)) {
      return;
    }

    state = [...state, usuario];
    await _guardarUsuarios();
  }

  Future<void> actualizar(Datos usuario) async {
    state = [
      for (final item in state)
        if (item.username == usuario.username) usuario else item,
    ];
    await _guardarUsuarios();
  }

  Future<void> eliminar(String username) async {
    state = state.where((item) => item.username != username).toList();
    await _guardarUsuarios();
  }
}

final instrumentosProvider = NotifierProvider<InstrumentosNotifier, List<Instrumentos>>(() => InstrumentosNotifier());
final usuariosProvider = NotifierProvider<UsuariosNotifier, List<Datos>>(() => UsuariosNotifier());
