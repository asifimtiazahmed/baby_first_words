import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class LoadAssets extends StatelessWidget {
  final double progress;
  final double totalMB;
  final double currentMB;
  final String zipFileName;
  final int zipTotal;
  final int zipCurrent;

  LoadAssets(this.progress, this.totalMB, this.currentMB, this.zipCurrent, this.zipFileName, this.zipTotal);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LiquidCustomProgressIndicator(
              direction: Axis.vertical,
              value: this.progress,
              valueColor: AlwaysStoppedAnimation(Colors.red),
              shapePath: _buildHeartPath(),
              center: Text(
                "${(this.progress * 100).toStringAsFixed(0)}%",
                style: TextStyle(
                  color: Colors.lightGreenAccent,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
              child: Text(
                'Downloading assets\n first time only...\n ${currentMB.toStringAsFixed(0)}MB out of ${totalMB.toStringAsFixed(0)}MB',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            (zipTotal != null)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text(
                          'Extracting Files...',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '${zipFileName ?? ''}',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.green,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                        child: LiquidCustomProgressIndicator(
                          value: (zipTotal == 0) ? 0 : (zipCurrent / zipTotal), // Defaults to 0.5.
                          //Defaults to the current Theme's accentColor.
                          valueColor: AlwaysStoppedAnimation(Colors.blue),
                          backgroundColor: Colors.lightGreen,
                          direction: Axis
                              .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                          shapePath: _buildBoatPath(),
                          center: (zipTotal == 0)
                              ? Text('')
                              : Text(
                                  "${((zipCurrent / zipTotal) * 100).toStringAsFixed(0)}%",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      )
                    ],
                  )
                : Text(''),
          ],
        ),
      ),
    );
  }

  Path _buildHeartPath() {
    return Path()
      ..moveTo(55, 15)
      ..cubicTo(55, 12, 50, 0, 30, 0)
      ..cubicTo(0, 0, 0, 37.5, 0, 37.5)
      ..cubicTo(0, 55, 20, 77, 55, 95)
      ..cubicTo(90, 77, 110, 55, 110, 37.5)
      ..cubicTo(110, 37.5, 110, 0, 80, 0)
      ..cubicTo(65, 0, 55, 12, 55, 15)
      ..close();
  }

  Path _buildBoatPath() {
    return Path()
      ..moveTo(15, 120)
      ..lineTo(0, 85)
      ..lineTo(50, 85)
      ..lineTo(50, 0)
      ..lineTo(105, 80)
      ..lineTo(60, 80)
      ..lineTo(60, 85)
      ..lineTo(120, 85)
      ..lineTo(105, 120)
      ..close();
  }
}
