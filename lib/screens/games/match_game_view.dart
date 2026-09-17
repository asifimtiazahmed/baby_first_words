import 'dart:math';

import 'package:baby_f_words/app_theme.dart';
import 'package:baby_f_words/managers/assets.dart';
import 'package:baby_f_words/models/slideshow.dart';
import 'package:baby_f_words/screens/games/match_game_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class MatchGameView extends StatelessWidget {
  final Slideshow slideshow;

  const MatchGameView({super.key, required this.slideshow});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MatchGameViewModel(slideshow: slideshow),
      child: Consumer<MatchGameViewModel>(
        builder: (context, vm, _) => Scaffold(
          backgroundColor: AppColors.creamyWhite,
          appBar: AppBar(
            title: Text(
              "Match the ${slideshow.slideshowName}",
              style: AppTextStyles.header.copyWith(fontSize: 24),
            ),
            backgroundColor: AppColors.creamyWhite,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black87),
          ),
          body: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: vm.cards.isEmpty
                        ? _buildSelectionScreen(context, vm)
                        : (vm.isGameFinished ? _buildGameFinished(context, vm) : _buildGameGrid(context, vm)),
                  ),
                  if (vm.banner != null)
                    Container(
                      alignment: Alignment.bottomCenter,
                      width: double.infinity,
                      height: 52,
                      child: AdWidget(ad: vm.banner!),
                    ),
                ],
              ),
              if (vm.isProcessing && !vm.isGameFinished && vm.cards.isNotEmpty)
                Positioned.fill(child: Container(color: Colors.transparent)), // Block input
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionScreen(BuildContext context, MatchGameViewModel vm) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Select Grid Size",
            style: AppTextStyles.display.copyWith(fontSize: 30),
          ),
          const SizedBox(height: 30),
          _gridButton(context, "4 x 4", () => vm.initGame(4, 4), AppColors.sunnyYellow),
          const SizedBox(height: 20),
          _gridButton(context, "4 x 5", () => vm.initGame(4, 5), AppColors.grassGreen), // 20 cards
          const SizedBox(height: 20),
          _gridButton(context, "6 x 6", () => vm.initGame(6, 6), AppColors.skyBlue),
          // 12x12 is likely too big for mobile items to be visible/clickable
        ],
      ),
    );
  }

  Widget _gridButton(BuildContext context, String label, VoidCallback onPressed, Color color) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20), boxShadow: [
          BoxShadow(color: Colors.black26, offset: const Offset(0, 4), blurRadius: 4),
        ]),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.header.copyWith(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildGameGrid(BuildContext context, MatchGameViewModel vm) {
    // Determine crossAxisCount based on card count
    // 16 -> 4, 20 -> 4, 36 -> 6
    int cols = sqrt(vm.cards.length).floor();
    if (vm.cards.length == 20) cols = 4; // 4x5

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: cols,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.8,
        children: vm.cards.map((card) {
          return GestureDetector(
            onTap: () => vm.onCardTapped(card),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: card.isFlipped || card.isMatched ? 180 : 0),
              duration: const Duration(milliseconds: 300),
              builder: (context, val, __) {
                final isFront = val < 90;
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(val * pi / 180),
                  child: isFront
                      ? _buildCardBack()
                      : Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..rotateY(pi), // Mirror image back
                          child: _buildCardFront(card, vm),
                        ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.softPurple,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: const Center(
        child: Icon(Icons.question_mark, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildCardFront(MatchCard card, MatchGameViewModel vm) {
    if (card.isMatched) {
      // Disappear or show different state?
      // User said: "if they match, they disappear".
      // Keeping invisible container to maintain grid layout.
      return Container(
        decoration: BoxDecoration(
          color: Colors.black12.withValues(alpha: 0.05), // Almost invisible placeholder
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.softPurple, width: 2),
      ),
      child: CachedNetworkImage(
        imageUrl: card.item.imagePath!,
        fit: BoxFit.contain,
        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, err) => const Icon(Icons.error),
      ),
    );
  }

  Widget _buildGameFinished(BuildContext context, MatchGameViewModel vm) {
    // Same end screen styles as PickGame
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(Assets.rainbow, height: 200),
          Text(
            "Well Done!",
            style: AppTextStyles.display.copyWith(fontSize: 40),
          ),
          const SizedBox(height: 40),
          _gridButton(context, "Play Again", vm.restartGame, AppColors.candyPink),
          const SizedBox(height: 20),
          _gridButton(context, "Back", () => Navigator.pop(context), AppColors.skyBlue),
        ],
      ),
    );
  }
}
