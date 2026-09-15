import 'package:baby_f_words/app_theme.dart';
import 'package:baby_f_words/managers/assets.dart';
import 'package:baby_f_words/models/slideshow.dart';
import 'package:baby_f_words/random_color_generator.dart';
import 'package:baby_f_words/screens/games/match_game_view.dart';
import 'package:baby_f_words/screens/games/pick_game_view.dart';
import 'package:baby_f_words/screens/slideshow/slideshow_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SlideshowView extends StatelessWidget {
  final Slideshow? slideshow;
  const SlideshowView({super.key, this.slideshow});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (_) => SlideShowViewModel(slideshow: slideshow),
      builder: (context, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            Provider.of<SlideShowViewModel>(context, listen: false).precacheImages(context);
          }
        });
        return Consumer<SlideShowViewModel>(
          builder: (context, vm, _) => Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Baby First Words',
                  style: AppTextStyles.header.copyWith(letterSpacing: 1.2, fontSize: 25, color: Colors.black87),
                ),
                ElevatedButton(child: volume(vm.volumeStatus), onPressed: () => vm.toggleVolumeStatus()),
              ],
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      width: size.width * 0.95,
                      height: size.width * 0.95,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              vm.slideshow!.slideshowName ?? '',
                              style: AppTextStyles.header.copyWith(fontSize: 32, letterSpacing: 1.2),
                            ),
                            Text(
                              vm.slideshow!.items?[vm.itemIndex].name?.toUpperCase() ?? '',
                              style: AppTextStyles.header.copyWith(
                                fontSize: 32,
                                letterSpacing: 1.2,
                                color: UniqueColorGenerator.getColor(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ), // Name of Library + Current Name
                  Expanded(
                    flex: 2,
                    child: Stack(alignment: AlignmentDirectional.topCenter, children: [
                      GestureDetector(
                        onHorizontalDragEnd: (details) {
                          if (details.primaryVelocity! > 0) {
                            vm.prevCallback();
                          }
                          if (details.primaryVelocity! < 0) {
                            vm.nextCallback();
                          }
                        },
                        //Image.network(vm.slideshow!.items![vm.itemIndex].imagePath!)
                        onTap: () => vm.playSound(),
                        child: CachedNetworkImage(
                          imageUrl: vm.slideshow!.items![vm.itemIndex].imagePath!,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                  Lottie.asset(Assets.fruitLoader),
                                  Text('Loading...', style: AppTextStyles.header)
                                ])),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${vm.itemIndex + 1}/ ${vm.slideshow!.items!.length}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            backgroundColor: Color(0x66FFFFFF),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        //NEXT AND PREVIOUS BUTTONS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                                child: ClipPath(
                                  clipper: ArrowClipper(70, 90, Edge.LEFT),
                                  child: Container(
                                    height: 120,
                                    width: 150, //this is the size I specified for each of the carousal pictures,
                                    color: AppColors.sunnyYellow,
                                    child: Center(
                                      child: Text(
                                        "Previous",
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.header.copyWith(fontSize: 25, color: Colors.black54),
                                      ),
                                    ),
                                  ),
                                ),
                                onLongPress: () {
                                  Duration delay = const Duration(seconds: 2);
                                  Future.delayed((delay), () {
                                    vm.prevCallback();
                                  });
                                },
                                onPressed: () {
                                  vm.prevCallback();
                                }),
                            TextButton(
                                child: ClipPath(
                                  clipper: ArrowClipper(70, 90, Edge.RIGHT),
                                  child: Container(
                                    height: 120,
                                    width: 150,
                                    color: AppColors.grassGreen,
                                    child: Center(
                                      child: Text(
                                        "Next",
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.header.copyWith(fontSize: 25, color: Colors.black54),
                                      ),
                                    ),
                                  ),
                                ),
                                onLongPress: () {
                                  Duration delay = const Duration(seconds: 2);
                                  Future.delayed((delay), () {
                                    vm.nextCallback();
                                  });
                                },
                                onPressed: () {
                                  vm.nextCallback();
                                }),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Game Buttons
                        Row(children: [
                          // Play Pick the Correct
                          Expanded(
                            child: _gameButton(
                              context,
                              label: "Play Pick the Correct\n${vm.slideshow?.slideshowName ?? ''}",
                              color: AppColors.candyPink,
                              onPressed: () {
                                if (vm.slideshow != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PickGameView(slideshow: vm.slideshow!),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 20),
                          // Play Match the Words
                          Expanded(
                            child: _gameButton(
                              context,
                              label: "Play Match the\n${vm.slideshow?.slideshowName ?? ''}",
                              color: AppColors.skyBlue,
                              onPressed: () {
                                if (vm.slideshow != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MatchGameView(slideshow: vm.slideshow!),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ]),

                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Expanded(
                  //   flex: 4,
                  //   child: Padding(
                  //     padding: const EdgeInsets.fromLTRB(0, 10, 2, 10),
                  //     child: GridView.count(
                  //       controller: vm.scrollController,
                  //       crossAxisCount: 1,
                  //       childAspectRatio: 1,
                  //       scrollDirection: Axis.horizontal,
                  //       mainAxisSpacing: 10,
                  //       children: createButtons(),
                  //       addRepaintBoundaries: true,
                  //     ),
                  //   ),
                  // ), //List Slider
                  // const SizedBox(height: 100.0),
                ],
              ),
            ),
          ),
          bottomNavigationBar: vm.banner == null
              ? const SizedBox()
              : Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  height: 52.0,
                  child: AdWidget(
                    ad: vm.banner!,
                  ),
                ),
        ),
      );
    });
  }

  Widget volume(bool status) {
    if (status) {
      return const Icon(Icons.volume_up);
    } else {
      return const Icon(Icons.volume_off);
    }
  }

  Widget _gameButton(BuildContext context,
      {required String label, required Color color, required VoidCallback onPressed}) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            offset: const Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: AppTextStyles.header.copyWith(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
