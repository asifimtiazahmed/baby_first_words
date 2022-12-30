import 'package:audioplayers/audioplayers.dart';
import 'package:baby_f_words/managers/admob.dart';
import 'package:baby_f_words/models/slideshow.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SlideShowViewModel with ChangeNotifier {
  bool volumeStatus = true;
  ScrollController scrollController = ScrollController();
  double gridIconSize = 100;
  Slideshow? slideshow;
  int itemIndex = 0;
  BannerAd? banner;

  SlideShowViewModel({this.slideshow}) {
    createBannerAd();
  }

  toggleVolumeStatus() {
    volumeStatus = !volumeStatus;
    notifyListeners();
  }

  createBannerAd() {
    banner = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: AdMobService().getBannerAdId(),
        listener: AdMobService.bannerListener,
        request: const AdRequest())
      ..load();
  }

  void prevCallback() async {
    if (itemIndex != 0 && itemIndex > 0) {
      itemIndex--;
      notifyListeners();
      await playSound();
      return;
      // scrollController.animateTo(scrollController.offset - gridIconSize,
      //     curve: Curves.linear, duration: const Duration(milliseconds: 500));
    }
    if (itemIndex == 0) {
      itemIndex = slideshow!.items!.length - 1;
      notifyListeners();
      await playSound();
      return;
    }

    //this will prevent it from offsetting after the first image
  }

  void nextCallback() async {
    if (itemIndex >= 0 && itemIndex < slideshow!.items!.length - 1) {
      itemIndex++;
      notifyListeners();
      await playSound();
      return;
    }
    if (itemIndex == slideshow!.items!.length - 1) {
      itemIndex = 0;
      notifyListeners();
      await playSound();
      return;
    }
  }

  Future<void> playSound() async {
    AudioPlayer player = AudioPlayer();
    if (volumeStatus) {
      await player.play(UrlSource(slideshow!.items![itemIndex].soundPath!), mode: PlayerMode.lowLatency);
    }
  }
}
