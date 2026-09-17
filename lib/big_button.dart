import 'dart:io';
import 'package:baby_f_words/constants.dart';
import 'package:baby_f_words/managers/audio_cache_manager.dart';
import 'package:baby_f_words/models/slideshow.dart';
import 'package:baby_f_words/screens/slideshow/slideshow_view.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class BigButton extends StatefulWidget {
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
  });

  @override
  State<BigButton> createState() => _BigButtonState();
}

class _BigButtonState extends State<BigButton> {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTapDown: (_) => _onTapDown(),
          onTapUp: (_) => _onTapUp(),
          onTapCancel: () => _onTapUp(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            margin: EdgeInsets.only(top: _isPressed ? 10 : 0, bottom: _isPressed ? 0 : 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: widget.topRightColor ?? Colors.white,
              boxShadow: _isPressed
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 8),
                      ),
                    ],
              border: Border.all(
                color: Colors.white.withOpacity(0.6),
                width: 3,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Stack(
                children: [
                   // Background decorative element
                   Positioned(
                    top: -20,
                    right: -20,
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                  ),
                  
                  // Main Content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: widget.fileImagePath.isNotEmpty 
                              ? Image.network(widget.fileImagePath, fit: BoxFit.contain)
                              : const SizedBox(),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            widget.name ?? ' ',
                            style: spicyRice.copyWith(
                              fontSize: 18, 
                              color: widget.textColor ?? Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Loading Overlay
                  if (widget.isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.3),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: CircularProgressIndicator(
                                value: widget.progressValue,
                                color: Colors.white,
                                strokeWidth: 4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isPressed = false;

  void _onTapDown() {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp() async {
    setState(() {
      _isPressed = false;
    });
    // Delay to let the animation play
    await Future.delayed(const Duration(milliseconds: 100));
    _handlePress();
  }

  void _handlePress() async {
    if (widget.slideshow != null && !widget.isLoading) {
      if (widget.onTap != null) {
        widget.onTap!();
      }
      if (widget.soundPath.isNotEmpty) {
        final newPlayer = AudioPlayer();
        AudioCacheManager.instance.getLocalAudioPath(widget.soundPath).then((localPath) {
          Source? source;
          if (File(localPath).existsSync()) {
            source = DeviceFileSource(localPath);
          } else if (localPath.startsWith('http://') || localPath.startsWith('https://')) {
            source = UrlSource(localPath);
          } else if (widget.soundPath.startsWith('http://') || widget.soundPath.startsWith('https://')) {
            source = UrlSource(widget.soundPath);
          }
          if (source != null) {
            newPlayer.play(source, mode: PlayerMode.lowLatency);
          }
        });
      }
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SlideshowView(
              slideshow: widget.slideshow!,
            ),
          ),
        );
      }
    }
  }
}
