import 'dart:io';

import 'package:baby_f_words/managers/app_config.dart';
import 'package:baby_f_words/managers/data_manager.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  final DataManager dataManager = GetIt.I<DataManager>();

  static final BannerAdListener bannerListener = BannerAdListener(
      onAdLoaded: (ad) => debugPrint('Ad loaded'),
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
        debugPrint('Ad failed to load $error');
      },
      onAdOpened: (ad) => debugPrint('Ad opened'),
      onAdClosed: (ad) => debugPrint('Ad closed'));

  /// Call this method before loading any ads in your app
  Future<void> initAdMob() async {
    final RequestConfiguration requestConfiguration = RequestConfiguration(
      tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
      maxAdContentRating: MaxAdContentRating.g,
    );

    // Apply the child-directed configuration globally
    await MobileAds.instance.updateRequestConfiguration(requestConfiguration);

    // Initialize the Google Mobile Ads SDK
    await MobileAds.instance.initialize();
  }

  String getAdmobAppId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-9426901076429008~6973923729';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-9426901076429008~3745125156'; // Verified on google play store app ID
    }
    return 'Not iOS';
  }

  String getBannerAdId() {
    if (Platform.isIOS) {
      return dataManager.flavor == AppFlavor.dev
          ? 'ca-app-pub-3940256099942544/2934735716' // TEST
          : 'ca-app-pub-9426901076429008/4236327164'; // Prod
    } else if (Platform.isAndroid) {
      return dataManager.flavor == AppFlavor.dev
          ? 'ca-app-pub-3940256099942544/6300978111' // Test app admob
          : 'ca-app-pub-9426901076429008/4863013129'; // Android Prod
    }
    return 'platform not supported';
  }
}
