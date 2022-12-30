import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

class FirebaseAuthManager {
  final logger = Logger();

  signInAnon() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      logger.i("Signed in with temporary account. $userCredential");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          logger.e("Anonymous auth hasn't been enabled for this project. Check firebase_auth_manager.dart");
          break;
        default:
          logger.e("Unknown error. Check firebase_auth_manager.dart");
      }
    }
  }
}
