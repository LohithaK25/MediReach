import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseConfig {
  static Future<FirebaseApp> initializeFirebase() async {
    if (kIsWeb) {
      return await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyC2S3YVYOw4qkqd8nw4RL-H3lDTgApYWO8",
          authDomain: "medireach-53050.firebaseapp.com",
          projectId: "medireach-53050",
          storageBucket: "medireach-53050.firebasestorage.app",
          messagingSenderId: "747220995902",
          appId: "1:747220995902:web:26eeecd27265364298e66f",
          measurementId: "G-WP72LSXS62"
        ),
      );
    } else {
      return await Firebase.initializeApp();
    }
  }
}
