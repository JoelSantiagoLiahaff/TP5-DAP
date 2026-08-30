import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/Listas/datos.dart';
import 'package:myapp/providers/app_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('agrega y elimina instrumentos desde el provider', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final nuevoInstrumento = Instrumentos(
      id: '6',
      nombre: 'Triángulo',
      descripcion: 'Instrumento de percusión',
      imagen: 'https://example.com/triangulo.png',
    );

    container.read(instrumentosProvider.notifier).agregar(nuevoInstrumento);

    expect(container.read(instrumentosProvider), contains(nuevoInstrumento));

    container.read(instrumentosProvider.notifier).eliminar(nuevoInstrumento.id);

    expect(container.read(instrumentosProvider), isNot(contains(nuevoInstrumento)));
  });

  test('agrega y elimina usuarios desde el provider', () async {
    SharedPreferences.setMockInitialValues({});

    final container = ProviderContainer();
    addTearDown(container.dispose);

    final nuevoUsuario = Datos(username: 'nuevo', password: '1234');

    await container.read(usuariosProvider.notifier).agregar(nuevoUsuario);

    expect(container.read(usuariosProvider), contains(nuevoUsuario));

    await container.read(usuariosProvider.notifier).eliminar(nuevoUsuario.username);

    expect(container.read(usuariosProvider), isNot(contains(nuevoUsuario)));
  });

  test('guarda usuarios en almacenamiento persistente', () async {
    SharedPreferences.setMockInitialValues({});

    final container = ProviderContainer();
    addTearDown(container.dispose);

    final nuevoUsuario = Datos(username: 'persistido', password: '4321');

    await container.read(usuariosProvider.notifier).agregar(nuevoUsuario);

    final prefs = await SharedPreferences.getInstance();
    final listaGuardada = prefs.getStringList('usuarios_guardados');

    expect(listaGuardada, isNotNull);
    expect(
      listaGuardada!.any((usuarioJson) => usuarioJson.contains('persistido')),
      isTrue,
    );
    expect(container.read(usuariosProvider), contains(nuevoUsuario));
  });

  test('carga usuarios guardados desde almacenamiento', () async {
    SharedPreferences.setMockInitialValues({
      'usuarios_guardados': [
        '{"username":"guardado","password":"9999"}',
        '{"username":"admin","password":"123456"}',
      ],
    });

    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container.read(usuariosProvider.notifier).cargarUsuarios();

    expect(
      container.read(usuariosProvider),
      contains(Datos(username: 'guardado', password: '9999')),
    );
  });
}
