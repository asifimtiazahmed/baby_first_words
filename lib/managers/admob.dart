import 'dart:io';
import 'package:baby_f_words/managers/app_config.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static final BannerAdListener bannerListener = BannerAdListener(
      onAdLoaded: (ad) => debugPrint('Ad loaded'),
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
        debugPrint('Ad failed to load $error');
      },
      onAdOpened: (ad) => debugPrint('Ad opened'),
      onAdClosed: (ad) => debugPrint('Ad closed'));

  String getAdmobAppId() {
    if (Platform.isIOS) {
      return 'need-to-set-this-key';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-9426901076429008~3745125156'; //Verified on google play store app ID
      //https://apps.admob.com/v2/apps/3745125156/adunits/list?pli=1
    }
    return 'Not iOS';
  }

  String getBannerAdId() {
    if (Platform.isIOS) {
      return AppConfig().flavour == AppFlavor.dev
          ? 'ca-app-pub-3940256099942544/2934735716'
          : //Test App
          'ca-app-pub-9426901076429008~6973923729'; //Prod
    } else if (Platform.isAndroid) {
      //return 'ca-app-pub-9426901076429008/4863013129'; //Change this key for production release
      return AppConfig().flavour == AppFlavor.dev
          ? 'ca-app-pub-3940256099942544/6300978111' // Test app admob
          : 'ca-app-pub-9426901076429008/4863013129';
    }
    return 'platform not supported';
  }
}
