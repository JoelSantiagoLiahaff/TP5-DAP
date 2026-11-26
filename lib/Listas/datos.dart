// Modelo de datos para un usuario registrado en la app.
// Modelo heredado del formulario; las contraseñas las gestiona Firebase Auth.
class Datos {
  String nombre;
  String email;
  String username;
  String password;

  Datos({
    String? username,
    String? nombre,
    String? email,
    required String password,
  })  : nombre = nombre ?? '',
        email = email ?? '',
        username = username ?? nombre ?? email ?? '',
        password = password;

  // Permite comparar instancias por su contenido en pruebas y colecciones.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Datos &&
        other.nombre == nombre &&
        other.email == email &&
        other.username == username &&
        other.password == password;
  }

  @override
  int get hashCode => Object.hash(nombre, email, username, password);
}

// Modelo del instrumento mostrado en la app.
// Incluye la información principal para listar, editar y ver cada elemento.
class Instrumentos {
  String id;
  String nombre;
  String descripcion;
  String imagen;
  String uso;
  String tipo;

  Instrumentos({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.imagen,
    required this.uso,
    required this.tipo,
  });

  factory Instrumentos.fromFirestore(String id, Map<String, dynamic> data) {
    // El ID se obtiene del documento y los demás campos de sus datos.
    return Instrumentos(
      id: id,
      nombre: data['nombre'] as String? ?? '',
      descripcion: data['descripcion'] as String? ?? '',
      imagen: data['imagen'] as String? ?? '',
      uso: data['uso'] as String? ?? '',
      tipo: data['tipo'] as String? ?? '',
    );
  }

  // Firestore genera el ID del documento; por eso no se incluye aquí.
  Map<String, dynamic> toFirestore() => {
        'nombre': nombre,
        'descripcion': descripcion,
        'imagen': imagen,
        'uso': uso,
        'tipo': tipo,
      };
}