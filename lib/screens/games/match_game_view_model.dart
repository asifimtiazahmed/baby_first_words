import 'dart:async';

import 'package:baby_f_words/managers/admob.dart';
import 'package:baby_f_words/managers/game_audio_manager.dart';
import 'package:baby_f_words/models/items.dart';
import 'package:baby_f_words/models/slideshow.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MatchCard {
  final String id;
  final Item item;
  bool isFlipped;
  bool isMatched;

  MatchCard({
    required this.id,
    required this.item,
    this.isFlipped = false,
    this.isMatched = false,
  });
}

class MatchGameViewModel extends ChangeNotifier {
  final Slideshow slideshow;
  late final GameAudioManager _audioManager;
  
  List<MatchCard> cards = [];
  MatchCard? firstFlippedCard;
  
  bool isGameFinished = false;
  bool isProcessing = false;
  int gridSize = 0; // Total items, e.g. 4x4 = 16
  
  BannerAd? banner;

  MatchGameViewModel({required this.slideshow}) {
    _audioManager = GameAudioManager(slideshowName: slideshow.slideshowName ?? '');
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

  void initGame(int rows, int cols) {
    gridSize = rows * cols;
    int pairCount = gridSize ~/ 2;
    
    // Select items for pairs
    List<Item> gameItems = List.from(slideshow.items!);
    gameItems.shuffle();
    if (gameItems.length > pairCount) {
      gameItems = gameItems.take(pairCount).toList();
    } else {
      // If we don't have enough items, reuse them (duplicate) logic could be complex
      // For MVP assume slides have enough items (e.g. 10 items for 4x4 grid needs 8)
      // If not, we wrap around.
      while (gameItems.length < pairCount) {
         gameItems.addAll(List.from(slideshow.items!)); // Readd to fill
      }
      gameItems = gameItems.take(pairCount).toList();
    }

    cards = [];
    for (var item in gameItems) {
      // Create pair
      cards.add(MatchCard(id: "${item.name}_1", item: item));
      cards.add(MatchCard(id: "${item.name}_2", item: item));
    }
    cards.shuffle();
    
    isGameFinished = false;
    firstFlippedCard = null;
    isProcessing = false;
    notifyListeners();
  }

  Future<void> onCardTapped(MatchCard card) async {
    if (isProcessing || card.isFlipped || card.isMatched) return;

    // Flip card
    card.isFlipped = true;
    notifyListeners();
    
    // Play sound
    if (card.item.soundPath != null) {
      await _audioManager.playSound(card.item.soundPath!);
    }

    if (firstFlippedCard == null) {
      firstFlippedCard = card;
    } else {
      // Second card flipped
      isProcessing = true;
      notifyListeners();
      
      if (firstFlippedCard!.item.name == card.item.name) {
        // MATCH!
        _audioManager.playSuccessHarp();
        await Future.delayed(const Duration(milliseconds: 400));
        await _audioManager.playWellDone();

        firstFlippedCard!.isMatched = true;
        card.isMatched = true;
        firstFlippedCard = null;

        // Check win
        if (cards.every((c) => c.isMatched)) {
          isGameFinished = true;
        }
      } else {
        // NO MATCH
        _audioManager.playWrongSfx();
        await Future.delayed(const Duration(milliseconds: 600));
        await _audioManager.playTryAgain();

        // Flip back
        firstFlippedCard!.isFlipped = false;
        card.isFlipped = false;
        firstFlippedCard = null;
      }
      
      isProcessing = false;
      notifyListeners();
    }
  }

  void restartGame() {
    // Determine grid size from current cards length
    // We can just re-init with sqrt(cards.length) logic or store selected size.
    // For simplicity, let's reset to "not started" state or passing stored cols/rows?
    // User flow: End screen -> Play Again -> Same Grid Size?
    // Let's assume re-shuffle same size.
    if (cards.isNotEmpty) {
       // cards.length is total items. 
       // We can just call initGame with simplified logic or just reset state if we store config
       // Actually initGame reshuffles new items. Let's assume 4x4 for now or store it.
       // Better: Store current Rows/Cols in VM
       // But initGame takes rows/cols. 
       // Let's add stored config.
    }
    notifyListeners(); // View should handle re-init if cards cleared?
    // Actually, View will probably call initGame from UI selection.
    // Use isGameFinished = false and empty cards to show selection?
    cards.clear();
    isGameFinished = false;
    notifyListeners();
  }

  @override
  void dispose() {
    banner?.dispose();
    _audioManager.dispose();
    super.dispose();
  }
}
