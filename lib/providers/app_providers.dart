import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/Listas/datos.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Notifier para manejar la lista de instrumentos de la app.
// Permite crear, actualizar y eliminar elementos en el estado global.
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
          uso: 'Percusion',
          tipo: 'Acustico',
        ),
        Instrumentos(
          id: '2',
          nombre: 'Guitarra',
          descripcion:
              'Instrumento de cuerdas, que puede ser acustico o electrica, con o sin cuerdas',
          imagen:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjCxeLaxy_7yuwC7jtAyDypHcYqboJ6fvpeJmarmbYag&s=10',
          uso: 'Cuerdas',
          tipo: 'Acustico',
        ),
        Instrumentos(
          id: '3',
          nombre: 'Bajo',
          descripcion:
              'Instrumento de cuerdas electrico, caraacterizado por ser grave',
          imagen:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2ARsIjZRAialXWeNc6iHPYzaBnu7VbB3sw3DULnqypg&s=10',
          uso: 'Cuerdas',
          tipo: 'Electrico',
        ),
        Instrumentos(
          id: '4',
          nombre: 'Piano',
          descripcion:
              'Instrumento de teclas, que puede ser acustico o electrico, con o sin cuerdas',
          imagen:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTlTkyVVwjkoMts1mspuHx1JS8FFl_cTkEj_PtoLLVeg&s=10',
          uso: 'Teclas',
          tipo: 'Acustico',
        ),
        Instrumentos(
          id: '5',
          nombre: 'Saxofon',
          descripcion:
              'Instrumento de viento, caracterizado por ser de metal y usado principalmente en jazz',
          imagen:
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQgaXZc8wMiYQZuIYSacwt2zH-MICI9CFFfCDD_kKfnmw&s=10',
          uso: 'Viento',
          tipo: 'Acustico',
        ),
      ];

  void agregar(Instrumentos instrumento) {
    // Agrega un nuevo elemento al estado actual.
    state = [...state, instrumento];
  }

  void actualizar(Instrumentos instrumento) {
    // Reemplaza el instrumento con el mismo id para mantener la lista sincronizada.
    state = [
      for (final item in state)
        if (item.id == instrumento.id) instrumento else item,
    ];
  }

  void eliminar(String id) {
    // Elimina el instrumento según su identificador único.
    state = state.where((item) => item.id != id).toList();
  }
}

// Notifier para controlar la colección de usuarios registrados.
// También se encarga de guardar y recuperar los datos desde SharedPreferences.
class UsuariosNotifier extends Notifier<List<Datos>> {
  static const String _storageKey = 'usuarios_guardados';

  // Usuarios base disponibles por defecto en la app.
  static final List<Datos> _usuariosBase = [
    Datos(
      nombre: 'Admin',
      email: 'admin@app.com',
      password: '123456',
    ),
    Datos(
      nombre: 'Joel',
      email: 'joel@app.com',
      password: '2008',
    ),
    Datos(
      nombre: 'Santiago',
      email: 'santiago@app.com',
      password: 'contraseña',
    ),
  ];

  @override
  List<Datos> build() => [..._usuariosBase];

  Future<void> cargarUsuarios() async {
    // Recupera los usuarios que fueron guardados previamente en el dispositivo.
    final prefs = await SharedPreferences.getInstance();
    final usuariosGuardados = prefs.getStringList(_storageKey);

    if (usuariosGuardados == null || usuariosGuardados.isEmpty) {
      state = [..._usuariosBase];
      return;
    }

    final usuariosPersistidos = usuariosGuardados.map((usuarioJson) {
      final usuarioMap = jsonDecode(usuarioJson) as Map<String, dynamic>;
      return Datos(
        username: usuarioMap['username'] ?? usuarioMap['email'] ?? '',
        nombre: usuarioMap['nombre'] ?? '',
        email: usuarioMap['email'] ?? usuarioMap['username'] ?? '',
        password: usuarioMap['password'] as String,
      );
    }).toList();

    // Se mantiene a los usuarios base y se agregan los persistidos si no existen repetidos.
    state = [
      ..._usuariosBase,
      ...usuariosPersistidos.where(
        (usuario) => !_usuariosBase.any((base) => base.email == usuario.email),
      ),
    ];
  }

  Future<void> _guardarUsuarios() async {
    // Convierte la lista de usuarios a JSON para guardarla localmente.
    final prefs = await SharedPreferences.getInstance();
    final usuariosGuardados = state
        .map((usuario) => jsonEncode({
              'nombre': usuario.nombre,
              'email': usuario.email,
              'username': usuario.username,
              'password': usuario.password,
            }))
        .toList();

    await prefs.setStringList(_storageKey, usuariosGuardados);
  }

  Future<void> agregar(Datos usuario) async {
    // Evita duplicados por email y luego guarda el usuario actualizado.
    if (state.any((item) => item.email == usuario.email)) {
      return;
    }

    state = [...state, usuario];
    await _guardarUsuarios();
  }

  Future<void> actualizar(Datos usuario) async {
    // Actualiza los datos de un usuario existente manteniendo la misma identidad por email.
    state = [
      for (final item in state)
        if (item.email == usuario.email) usuario else item,
    ];
    await _guardarUsuarios();
  }

  Future<void> eliminar(String email) async {
    // Elimina al usuario por su email y persiste la lista resultante.
    state = state.where((item) => item.email != email).toList();
    await _guardarUsuarios();
  }
}

// Notifier de sesión para saber si hay un usuario autenticado.
class AuthNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void login() => state = true;

  void logout() => state = false;
}

final instrumentosProvider = NotifierProvider<InstrumentosNotifier, List<Instrumentos>>(() => InstrumentosNotifier());
final usuariosProvider = NotifierProvider<UsuariosNotifier, List<Datos>>(() => UsuariosNotifier());
final authProvider = NotifierProvider<AuthNotifier, bool>(() => AuthNotifier());
