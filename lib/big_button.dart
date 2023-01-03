import 'package:baby_f_words/constants.dart';
import 'package:baby_f_words/models/slideshow.dart';
import 'package:baby_f_words/random_color_generator.dart';
import 'package:baby_f_words/screens/slideshow/slideshow_view.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class BigButton extends StatelessWidget {
  final String fileImagePath;
  final String soundPath;
  final Source? soundSource;
  final Slideshow? slideshow;
  final String? name;
  final Color? topRightColor;
  final Color? bottomLeftColor;
  final Color? textColor;

  ///ProgressValue is used for the loader
  final double? progressValue;

  ///If you want to show a progress indication that the slideshow is still loading, note this as yes
  final bool isLoading;
  final Function? onTap;
  //final double? volume;

  const BigButton({
    super.key,
    required this.soundPath,
    required this.fileImagePath,
    required this.isLoading,
    this.slideshow,
    this.name,
    this.progressValue,
    this.topRightColor,
    this.bottomLeftColor,
    this.textColor,
    this.soundSource,
    this.onTap,
    // this.volume,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white, boxShadow: [
            if (topRightColor == null && bottomLeftColor == null)
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            if (topRightColor != null)
              BoxShadow(
                color: topRightColor!,
                spreadRadius: 4,
                blurRadius: 7,
                offset: const Offset(3, -2), // changes position of shadow
              ),
            if (bottomLeftColor != null)
              BoxShadow(
                color: bottomLeftColor!,
                spreadRadius: 4,
                blurRadius: 7,
                offset: const Offset(-2, 3), // changes position of shadow
              ),
          ]),
          child: TextButton(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      constraints: const BoxConstraints.expand(),
                      decoration: BoxDecoration(
                        image: DecorationImage(image: NetworkImage(fileImagePath), fit: BoxFit.scaleDown),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      name ?? ' ',
                      style: spicyRice.copyWith(fontSize: 20, color: textColor ?? UniqueColorGenerator.getColor()),
                    ),
                  ),
                ],
              ),
              onPressed: () async {
                if (slideshow != null && !isLoading) {
                  if (onTap != null) {
                    onTap!();
                  }
                  final newPlayer = AudioPlayer();
                  await newPlayer
                      .play(
                        UrlSource(soundPath),
                        mode: PlayerMode.lowLatency,
                      )
                      .whenComplete(() => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SlideshowView(
                                slideshow: slideshow!,
                              ),
                            ),
                          ));

                  await newPlayer.setReleaseMode(ReleaseMode.release);
                  //await player.seek(const Duration(milliseconds: 0));

                }
              }),
        ),
        if (isLoading)
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.4),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: SizedBox(
                        height: 70,
                        width: 70,
                        child: CircularProgressIndicator(
                          color: Colors.green,
                          backgroundColor: Colors.lime.withOpacity(0.5),
                          value: progressValue ?? 0.0,
                          strokeWidth: 10,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('Loading...', style: spicyRice.copyWith(fontSize: 20.0)),
                  ),
                ],
              )),
      ],
    );
  }
}
