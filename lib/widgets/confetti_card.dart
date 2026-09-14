import 'package:baby_f_words/widgets/animated_scale_card.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ConfettiCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool isCorrect;

  const ConfettiCard({
    super.key,
    required this.child,
    required this.onTap,
    this.isCorrect = false,
  });

  @override
  State<ConfettiCard> createState() => _ConfettiCardState();
}

class _ConfettiCardState extends State<ConfettiCard> {
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    super.initState();
    _controllerCenter = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.isCorrect) {
      _controllerCenter.play();
    }
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedScaleCard(
          onTap: _handleTap,
          child: widget.child,
        ),
        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: _controllerCenter,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ],
            createParticlePath: drawStar,
          ),
        ),
      ],
    );
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (3.1415926535897932 / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * math.cos(step), halfWidth + externalRadius * math.sin(step));
      path.lineTo(halfWidth + internalRadius * math.cos(step + halfDegreesPerStep), halfWidth + internalRadius * math.sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
    // Actually simpler to just not provide custom path for generic confetti, but users love stars.
    // Let's use the example star path from package docs often used.
  }
}


