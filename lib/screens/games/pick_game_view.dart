import 'package:baby_f_words/app_theme.dart';
import 'package:baby_f_words/managers/assets.dart';
import 'package:baby_f_words/models/slideshow.dart';
import 'package:baby_f_words/screens/games/pick_game_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:baby_f_words/widgets/animated_scale_card.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class PickGameView extends StatelessWidget {
  final Slideshow slideshow;

  const PickGameView({super.key, required this.slideshow});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PickGameViewModel(slideshow: slideshow),
      child: Consumer<PickGameViewModel>(
        builder: (context, vm, _) => Scaffold(
          backgroundColor: AppColors.creamyWhite,
          appBar: AppBar(
            title: Text(
              "Pick the Correct ${slideshow.slideshowName}",
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
                    child: vm.isGameFinished ? _buildGameFinished(context, vm) : _buildGameContent(context, vm),
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
              if (vm.isProcessing && !vm.isGameFinished)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(color: Colors.transparent),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameContent(BuildContext context, PickGameViewModel vm) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (vm.isProcessing && vm.correctItem != null) // Simplistic "Well Done" check visual
          // Actually, logic is in VM. We can show confetti if processing correct?
          // VM doesn't expose "isCorrect" state easily, but we can just show rainbow if waiting for next level?
          // Simplification: VM handles delays. Here we just show grid.
          const SizedBox.shrink(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: vm.currentOptions.map((item) {
                return AnimatedScaleCard(
                  key: ValueKey(item.name),
                  onTap: () => vm.onItemTapped(item),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: CachedNetworkImage(
                        imageUrl: item.imagePath!,
                        fit: BoxFit.contain,
                        placeholder: (context, url) => Lottie.asset(Assets.fruitLoader),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGameFinished(BuildContext context, PickGameViewModel vm) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(Assets.rainbow, height: 200),
          Text(
            "Game Over!",
            style: AppTextStyles.display.copyWith(fontSize: 40),
          ),
          const SizedBox(height: 40),
          _actionButton(
            label: "Play Again",
            color: AppColors.candyPink,
            onPressed: vm.restartGame,
            icon: Icons.refresh,
          ),
          const SizedBox(height: 20),
          _actionButton(
            label: "Back",
            color: AppColors.skyBlue,
            onPressed: () => Navigator.pop(context),
            icon: Icons.arrow_back,
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
      {required String label, required Color color, required VoidCallback onPressed, required IconData icon}) {
    // Bouncing animation could be added here with an AnimationController if needed.
    // For now, standard button with shadow style.
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 200,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              offset: const Offset(0, 4),
              blurRadius: 6,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 10),
            Text(
              label,
              style: AppTextStyles.buttonText.copyWith(fontSize: 22, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
