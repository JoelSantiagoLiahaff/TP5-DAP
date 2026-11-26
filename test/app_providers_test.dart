import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/Listas/datos.dart';

void main() {
  test('serializa un instrumento para Firestore', () {
    final instrumento = Instrumentos(
      id: 'instrumento-1',
      nombre: 'Guitarra',
      descripcion: 'Instrumento de cuerdas',
      imagen: 'https://example.com/guitarra.png',
      uso: 'Cuerdas',
      tipo: 'Acustico',
    );

    expect(instrumento.toFirestore(), {
      'nombre': 'Guitarra',
      'descripcion': 'Instrumento de cuerdas',
      'imagen': 'https://example.com/guitarra.png',
      'uso': 'Cuerdas',
      'tipo': 'Acustico',
    });
  });

  test('restaura un instrumento desde un documento de Firestore', () {
    final instrumento = Instrumentos.fromFirestore('doc-1', {
      'nombre': 'Piano',
      'descripcion': 'Instrumento de teclas',
      'imagen': 'https://example.com/piano.png',
      'uso': 'Teclas',
      'tipo': 'Acustico',
    });

    expect(instrumento.id, 'doc-1');
    expect(instrumento.nombre, 'Piano');
    expect(instrumento.tipo, 'Acustico');
  });
}
