import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class SparkleParticle {
  final Offset origin;
  final double angle;
  final double speed;
  final double size;
  final Color color;
  final int points; // 4 or 5 pointed star, or circle
  final double rotationSpeed;

  double x;
  double y;
  double currentSize;
  double opacity;
  double rotation;
  double progress = 0.0; // 0.0 to 1.0

  SparkleParticle({
    required this.origin,
    required this.angle,
    required this.speed,
    required this.size,
    required this.color,
    required this.points,
    required this.rotationSpeed,
  })  : x = origin.dx,
        y = origin.dy,
        currentSize = size,
        opacity = 1.0,
        rotation = math.Random().nextDouble() * math.pi * 2;

  void update(double dt) {
    progress += dt * 1.6; // ~0.6s lifespan
    if (progress > 1.0) progress = 1.0;

    final distance = speed * math.sin(progress * math.pi / 2);
    x = origin.dx + math.cos(angle) * distance;
    y = origin.dy + math.sin(angle) * distance;

    rotation += rotationSpeed * dt;

    // Fade out towards the end
    if (progress < 0.2) {
      opacity = progress / 0.2;
    } else {
      opacity = (1.0 - progress) / 0.8;
    }

    // Shrink slightly as it fades
    currentSize = size * (1.0 - progress * 0.4);
  }
}

class SparkleOverlay extends StatefulWidget {
  final Widget child;

  const SparkleOverlay({super.key, required this.child});

  @override
  State<SparkleOverlay> createState() => _SparkleOverlayState();
}

class _SparkleOverlayState extends State<SparkleOverlay> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  final List<SparkleParticle> _particles = [];
  final math.Random _random = math.Random();
  Duration _lastTime = Duration.zero;

  static const List<Color> _goldColors = [
    Color(0xFFFFE57F), // Light Gold
    Color(0xFFFFD700), // Pure Gold
    Color(0xFFFFC107), // Amber Gold
    Color(0xFFFFB300), // Deep Gold
    Color(0xFFFFFFFF), // Radiant White
  ];

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    if (_lastTime == Duration.zero) {
      _lastTime = elapsed;
      return;
    }

    final dt = (elapsed - _lastTime).inMicroseconds / 1000000.0;
    _lastTime = elapsed;

    if (_particles.isNotEmpty) {
      setState(() {
        for (var i = _particles.length - 1; i >= 0; i--) {
          _particles[i].update(dt);
          if (_particles[i].progress >= 1.0) {
            _particles.removeAt(i);
          }
        }
      });
    }
  }

  void _addSparkles(Offset position) {
    const particleCount = 14;
    for (int i = 0; i < particleCount; i++) {
      final angle = _random.nextDouble() * math.pi * 2;
      final speed = 30.0 + _random.nextDouble() * 70.0;
      final size = 8.0 + _random.nextDouble() * 14.0;
      final color = _goldColors[_random.nextInt(_goldColors.length)];
      final points = _random.nextBool() ? 4 : 5;
      final rotationSpeed = (_random.nextDouble() - 0.5) * 6.0;

      _particles.add(
        SparkleParticle(
          origin: position,
          angle: angle,
          speed: speed,
          size: size,
          color: color,
          points: points,
          rotationSpeed: rotationSpeed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (event) {
        _addSparkles(event.position);
      },
      child: Stack(
        children: [
          widget.child,
          if (_particles.isNotEmpty)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: SparklePainter(particles: List.from(_particles)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class SparklePainter extends CustomPainter {
  final List<SparkleParticle> particles;

  SparklePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      if (particle.opacity <= 0) continue;

      final paint = Paint()
        ..color = particle.color.withValues(alpha: particle.opacity)
        ..style = PaintingStyle.fill;

      // Outer glow paint
      final glowPaint = Paint()
        ..color = const Color(0xFFFFD700).withValues(alpha: particle.opacity * 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

      canvas.save();
      canvas.translate(particle.x, particle.y);
      canvas.rotate(particle.rotation);

      // Draw soft glow circle behind star
      canvas.drawCircle(Offset.zero, particle.currentSize * 0.8, glowPaint);

      // Draw Star Path
      final path = _createStarPath(particle.currentSize, particle.points);
      canvas.drawPath(path, paint);

      canvas.restore();
    }
  }

  Path _createStarPath(double radius, int points) {
    final path = Path();
    final innerRadius = radius * 0.4;
    final angleStep = math.pi / points;

    for (int i = 0; i < points * 2; i++) {
      final r = (i.isEven) ? radius : innerRadius;
      final angle = i * angleStep - math.pi / 2;
      final x = r * math.cos(angle);
      final y = r * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant SparklePainter oldDelegate) => true;
}
