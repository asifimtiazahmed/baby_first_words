import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:baby_f_words/managers/file_handler.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'data_manager.dart';
import 'firebase_auth_manager.dart';
import 'firebase_options.dart';

enum AppFlavor { dev, prod }

class AppConfig {
  final AppFlavor flavour = AppFlavor.dev;

  static Future<void> init(AppFlavor flavor) async {
    WidgetsFlutterBinding.ensureInitialized();
    if (Platform.isAndroid) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
    //TO Set the iPhone's speakers to say the sound externally instead of the earpiece
    AudioContext audioContext = AudioContext(
      iOS: AudioContextIOS(
        // defaultToSpeaker: true,
        category: AVAudioSessionCategory.playback,
        options: const {AVAudioSessionOptions.mixWithOthers},
      ),
      android: AudioContextAndroid(
        isSpeakerphoneOn: true,
        stayAwake: true,
        contentType: AndroidContentType.music,
        usageType: AndroidUsageType.assistanceSonification,
        audioFocus: AndroidAudioFocus.gain,
      ),
    );
    AudioPlayer.global.setAudioContext(audioContext);

    final appFlavor = flavor;
    await Firebase.initializeApp(name: 'baby-first-words', options: getFirebaseOptions()).whenComplete(() {
      MobileAds.instance.initialize();
      GetIt.I.registerSingleton(DataManager());
      GetIt.I.registerSingleton(FirebaseAuthManager());
      final authManager = GetIt.I<FirebaseAuthManager>();
      GetIt.I.registerSingleton(FileHandler.instance);
      authManager.signInAnon();
      instantiateAppCheck();
      //Setting AppFlavour
      GetIt.I<DataManager>().flavor = appFlavor;
    });
  }

  static Future<void> instantiateAppCheck() async {
    await FirebaseAppCheck.instance.activate(
      providerWeb: ReCaptchaV3Provider('recaptcha-v3-site-key'),
      // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
      // your preferred provider. Choose from:
      // 1. debug provider
      // 2. safety net provider
      // 3. play integrity provider
      providerAndroid: kDebugMode ? AndroidDebugProvider() : AndroidPlayIntegrityProvider(),
      providerApple: kDebugMode ? AppleDebugProvider() : AppleDeviceCheckProvider(),
    );
  }
}
