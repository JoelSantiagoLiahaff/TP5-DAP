# flutter_application_1

Aplicacion Flutter con Firebase Authentication, Cloud Firestore y Riverpod.

## Configuracion Firebase

1. Cree un proyecto en Firebase Console.
2. Active Authentication con el proveedor Email/Password.
3. Cree una base Cloud Firestore en modo de pruebas o con reglas que permitan al usuario autenticado leer y escribir la coleccion `instrumentos`.
4. Instale FlutterFire CLI si no esta disponible:

   `dart pub global activate flutterfire_cli`

5. Desde la raiz del proyecto, configure las plataformas:

   `flutterfire configure`

Este ultimo comando crea `lib/firebase_options.dart` y la configuracion nativa del proyecto.

## Ejecucion

`flutter pub get`

`flutter run`

Los instrumentos se guardan en la coleccion `instrumentos` de Cloud Firestore. La
sesion se mantiene con Firebase Authentication y el estado se administra con
Riverpod.
