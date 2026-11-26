import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/Listas/datos.dart';

// Expone los cambios de sesión emitidos por Firebase Authentication.
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Escucha Firestore para reflejar en pantalla altas, cambios y bajas al instante.
final instrumentosStreamProvider = StreamProvider<List<Instrumentos>>((ref) {
  return FirebaseFirestore.instance
      .collection('instrumentos')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Instrumentos.fromFirestore(
                doc.id,
                doc.data(),
              ))
          .toList());
});

// Agrupa las escrituras de Firestore y publica sus estados de carga o error.
class InstrumentosNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  CollectionReference<Map<String, dynamic>> get _collection =>
      FirebaseFirestore.instance.collection('instrumentos');

  // Crea un documento y deja que el stream actualice el listado.
  Future<void> agregar(Instrumentos instrumento) async {
    state = const AsyncLoading();
    try {
      await _collection.add(instrumento.toFirestore());
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  // Actualiza el documento existente, conservando su identificador.
  Future<void> actualizar(Instrumentos instrumento) async {
    state = const AsyncLoading();
    try {
      await _collection.doc(instrumento.id).update(instrumento.toFirestore());
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }

  // Elimina el documento; el stream notifica el cambio al listado.
  Future<void> eliminar(String id) async {
    state = const AsyncLoading();
    try {
      await _collection.doc(id).delete();
      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}

// Estado de las operaciones de escritura sobre instrumentos.
final instrumentosProvider =
    NotifierProvider<InstrumentosNotifier, AsyncValue<void>>(
  InstrumentosNotifier.new,
);

// Firebase Authentication gestiona la contraseña; el nombre se asocia al perfil.
Future<void> registrarUsuario({
  required String nombre,
  required String email,
  required String password,
}) async {
  final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: email,
    password: password,
  );
  await credential.user?.updateDisplayName(nombre);
  await credential.user?.reload();
}

// Delega la validación de credenciales y la sesión a Firebase Authentication.
Future<void> iniciarSesion({
  required String email,
  required String password,
}) async {
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
}

// Finaliza la sesión actual en Firebase Authentication.
Future<void> cerrarSesion() async {
  await FirebaseAuth.instance.signOut();
}

// Conservado para compatibilidad con formularios anteriores; no almacena claves.
final usuariosProvider = Provider<List<Datos>>((ref) => const []);
