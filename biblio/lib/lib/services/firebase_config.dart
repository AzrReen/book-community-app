import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseConfig {
  static Future<void> initialize() async {
    if (kIsWeb) {
      // Web configuration is already in index.html
      await Firebase.initializeApp();
    } else {
      // Mobile configuration
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyCpI1JSpL0UAW0vUrHWpGDlZeMXiQPx4As",
          appId: "1:567436199586:web:dd46aa000035a602ed79fb",
          messagingSenderId: "567436199586",
          projectId: "biblioo-445fe",
          storageBucket: "biblioo-445fe.firebasestorage.app",
          authDomain: "biblioo-445fe.firebaseapp.com",
        ),
      );
    }
  }
}