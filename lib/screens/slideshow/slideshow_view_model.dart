import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:baby_f_words/managers/admob.dart';
import 'package:baby_f_words/managers/audio_cache_manager.dart';
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
  final AudioPlayer _player = AudioPlayer();

  SlideShowViewModel({this.slideshow}) {
    createBannerAd();
  }

  void toggleVolumeStatus() {
    volumeStatus = !volumeStatus;
    notifyListeners();
  }

  void createBannerAd() {
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
    if (volumeStatus && slideshow?.items != null && itemIndex < slideshow!.items!.length) {
      final rawPath = slideshow!.items![itemIndex].soundPath;
      if (rawPath != null && rawPath.isNotEmpty) {
        final localPath = await AudioCacheManager.instance.getLocalAudioPath(rawPath);
        Source? source;
        if (File(localPath).existsSync()) {
          source = DeviceFileSource(localPath);
        } else if (localPath.startsWith('http://') || localPath.startsWith('https://')) {
          source = UrlSource(localPath);
        } else if (rawPath.startsWith('http://') || rawPath.startsWith('https://')) {
          source = UrlSource(rawPath);
        }
        if (source != null) {
          await _player.stop();
          await _player.play(source, mode: PlayerMode.lowLatency);
        }
      }
    }
  }

  void precacheImages(BuildContext context) {
    if (slideshow?.items == null) return;
    for (var item in slideshow!.items!) {
      if (item.imagePath != null) {
        precacheImage(NetworkImage(item.imagePath!), context);
      }
    }
  }

  @override
  void dispose() {
    banner?.dispose();
    _player.dispose();
    super.dispose();
  }
}
