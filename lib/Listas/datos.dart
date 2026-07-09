class Datos {
  String username;
  String password;

  Datos({required this.username, required this.password});
}

class Instrumentos {
  String id;
  String nombre;
  String descripcion;
  String imagen;

  Instrumentos({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.imagen,
  });
}

final instrumentos = [
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
