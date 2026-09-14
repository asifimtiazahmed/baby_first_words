import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

class FirebaseAuthManager {
  final logger = Logger();

  signInAnon() async {
    try {
      final userC = FirebaseAuth.instance.currentUser;
      if (userC?.uid != null) {
        debugPrint('user ID exist, ${userC?.uid}');
        return; //returns is already user registered
      }

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
