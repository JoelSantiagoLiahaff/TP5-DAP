// Opciones generadas por FlutterFire para conectar la aplicación con Firebase.
// En este proyecto se configuró la plataforma web; las demás requieren volver
// a ejecutar `flutterfire configure` seleccionando las plataformas necesarias.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  // Devuelve las credenciales correspondientes a la plataforma en ejecución.
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError(
          'Configure Firebase for Android with FlutterFire CLI.',
        );
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'Configure Firebase for iOS/macOS with FlutterFire CLI.',
        );
      default:
        throw UnsupportedError(
          'Configure Firebase for this platform with FlutterFire CLI.',
        );
    }
  }

  // Identificadores públicos de la aplicación web registrada en Firebase.
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCfTux0TlDtKktNj9aihbN9QUnMcZy4Qjg',
    appId: '1:942965655442:web:0d14f2ba15aa9120a2634b',
    messagingSenderId: '942965655442',
    projectId: 'tp5-5lc',
    authDomain: 'tp5-5lc.firebaseapp.com',
    databaseURL: 'https://tp5-5lc-default-rtdb.firebaseio.com',
    storageBucket: 'tp5-5lc.firebasestorage.app',
    measurementId: 'G-QXY7Y9BJBV',
  );
}
