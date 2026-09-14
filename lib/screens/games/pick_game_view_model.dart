import 'package:baby_f_words/managers/admob.dart';
import 'package:baby_f_words/managers/game_audio_manager.dart';
import 'package:baby_f_words/models/items.dart';
import 'package:baby_f_words/models/slideshow.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class PickGameViewModel extends ChangeNotifier {
  final Slideshow slideshow;
  late final GameAudioManager _audioManager;

  List<Item> currentOptions = [];
  Item? correctItem;
  int currentIndex = 0;
  bool isGameFinished = false;
  bool isProcessing = false;

  BannerAd? banner;

  PickGameViewModel({required this.slideshow}) {
    _audioManager = GameAudioManager(slideshowName: slideshow.slideshowName ?? '');
    _initGame();
    createBannerAd();
  }

  void createBannerAd() {
    banner = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: AdMobService().getBannerAdId(),
        listener: AdMobService.bannerListener,
        request: const AdRequest())
      ..load();
  }

  void _initGame() {
    currentIndex = 0;
    isGameFinished = false;
    slideshow.items!.shuffle(); // Shuffle main list to randomize order
    _loadLevel();
  }

  void _loadLevel() {
    if (currentIndex >= slideshow.items!.length) {
      isGameFinished = true;
      notifyListeners();
      return;
    }

    correctItem = slideshow.items![currentIndex];

    // Pick 2 distractors
    List<Item> potentialDistractors = List.from(slideshow.items!)..removeWhere((item) => item == correctItem);
    potentialDistractors.shuffle();

    currentOptions = [correctItem!, ...potentialDistractors.take(2)];
    currentOptions.shuffle(); // Shuffle options so correct answer isn't always first

    notifyListeners();
    _playPrompt();
  }

  Future<void> _playPrompt() async {
    await _audioManager.playFindThe();
    await Future.delayed(const Duration(milliseconds: 1500)); // Wait for "Find the..."
    if (correctItem?.soundPath != null) {
      await _audioManager.playSound(correctItem!.soundPath!);
    }
  }

  Future<void> onItemTapped(Item selectedItem) async {
    if (isProcessing) return;
    isProcessing = true;
    notifyListeners();

    if (selectedItem == correctItem) {
      // Correct
      if (selectedItem.soundPath != null) {
        await _audioManager.playSound(selectedItem.soundPath!);
      }
      await Future.delayed(const Duration(milliseconds: 1000));
      await _audioManager.playSuccessHarp();
      await _audioManager.playWellDone();
      // Wait for celebration
      await Future.delayed(const Duration(seconds: 2));

      currentIndex++;
      _loadLevel();
    } else {
      // Incorrect
      if (selectedItem.soundPath != null) {
        await _audioManager.playSound(selectedItem.soundPath!);
      }
      await Future.delayed(const Duration(milliseconds: 1000));
      await _audioManager.playTryAgain();
    }

    isProcessing = false;
    notifyListeners();
  }

  void restartGame() {
    _initGame();
  }

  @override
  void dispose() {
    banner?.dispose();
    _audioManager.dispose();
    super.dispose();
  }
}
