// Modelo de datos para un usuario registrado en la app.
// Guarda la información necesaria para autenticación y control de sesion.
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

  // Comparación de igualdad personalizada para poder verificar usuarios en tests y provider.
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
}

// Datos iniciales cargados al arrancar la app.
final instrumentos = [
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
