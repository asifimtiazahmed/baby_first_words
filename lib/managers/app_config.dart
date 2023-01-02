import 'package:baby_f_words/managers/file_handler.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'data_manager.dart';
import 'firebase_auth_manager.dart';

enum AppFlavor { dev, prod }

class AppConfig {
  final AppFlavor flavour = AppFlavor.dev;

  static Future<void> init(AppFlavor flavor) async {
    WidgetsFlutterBinding.ensureInitialized();
    if (Platform.isAndroid) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
    final appFlavor = flavor;
    await Firebase.initializeApp(
      name: 'baby-first-words',
      options: getFirebaseOptions(),
    ).whenComplete(() {
      MobileAds.instance.initialize();
      GetIt.I.registerSingleton(DataManager());
      GetIt.I.registerSingleton(FirebaseAuthManager());
      final authManager = GetIt.I<FirebaseAuthManager>();
      GetIt.I.registerSingleton(FileHandler.instance);
      authManager.signInAnon();
      instantiateAppCheck();
    });
  }

  static instantiateAppCheck() async {
    await FirebaseAppCheck.instance.activate(
      webRecaptchaSiteKey: 'recaptcha-v3-site-key',
      // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
      // your preferred provider. Choose from:
      // 1. debug provider
      // 2. safety net provider
      // 3. play integrity provider
      androidProvider: AndroidProvider.debug,
    );
  }

  static FirebaseOptions getFirebaseOptions() {
    if (Platform.isAndroid) {
      debugPrint('Platform Android:');
      return const FirebaseOptions(
          apiKey: 'AIzaSyAH00desxSSlf1JLPAQ2CM1MfFhun-gkq4',
          appId: '1:552182376999:android:a1699a094af709b387fc02',
          messagingSenderId: '552182376999',
          projectId: 'baby-first-words');
    } else if (Platform.isIOS) {
      debugPrint('Platform iOS:');
      return const FirebaseOptions(
          apiKey: 'AIzaSyBFdGjMalkM3RusoE6xsBPBecTiB304Jls',
          appId: '1:552182376999:ios:f9a721267735460987fc02',
          messagingSenderId: '552182376999',
          storageBucket: 'baby-first-words.appspot.com',
          iosClientId: '552182376999-8oufte41p4f2oevkvht5runps9c3aoso.apps.googleusercontent.com',
          projectId: 'baby-first-words');
    } else {
      debugPrint('Un supported platform for firebase options');
      return const FirebaseOptions(
          apiKey: 'AIzaSyAH00desxSSlf1JLPAQ2CM1MfFhun-gkq4',
          appId: '1:552182376999:android:a1699a094af709b387fc02',
          messagingSenderId: '552182376999',
          projectId: 'baby-first-words');
    }
  }
}
