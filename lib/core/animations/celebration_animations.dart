import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../app_theme.dart';

// =============================================================================
// 1. CONFETTI EXPLOSION - For achievements
// =============================================================================

class ConfettiExplosion extends StatefulWidget {
  final bool trigger;
  final int particleCount;
  final Duration duration;
  final List<Color> colors;

  const ConfettiExplosion({
    super.key,
    required this.trigger,
    this.particleCount = 50,
    this.duration = const Duration(milliseconds: 2000),
    this.colors = const [
      AppColors.brandPrimary,
      AppColors.brandSecondary,
      AppColors.brandTertiary,
      Color(0xFFF97316), // Orange
      Color(0xFFFACC15), // Yellow
    ],
  });

  @override
  State<ConfettiExplosion> createState() => _ConfettiExplosionState();
}

class _ConfettiExplosionState extends State<ConfettiExplosion>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<_ConfettiParticle> _particles = [];
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _particles = []);
      }
    });
  }

  @override
  void didUpdateWidget(covariant ConfettiExplosion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) {
      _generateParticles();
      _controller.forward(from: 0);
    }
  }

  void _generateParticles() {
    _particles = List.generate(widget.particleCount, (index) {
      return _ConfettiParticle(
        color: widget.colors[_random.nextInt(widget.colors.length)],
        angle: _random.nextDouble() * 2 * math.pi,
        velocity: 150 + _random.nextDouble() * 200,
        rotationSpeed: _random.nextDouble() * 6 - 3,
        size: 6 + _random.nextDouble() * 8,
        shape: _ConfettiShape
            .values[_random.nextInt(_ConfettiShape.values.length)],
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_particles.isEmpty) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ConfettiPainter(
            particles: _particles,
            progress: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

enum _ConfettiShape { square, circle, triangle }

class _ConfettiParticle {
  final Color color;
  final double angle;
  final double velocity;
  final double rotationSpeed;
  final double size;
  final _ConfettiShape shape;

  _ConfettiParticle({
    required this.color,
    required this.angle,
    required this.velocity,
    required this.rotationSpeed,
    required this.size,
    required this.shape,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final gravity = 500.0;

    for (final particle in particles) {
      final time = progress * 2; // Normalize time
      final dx = math.cos(particle.angle) * particle.velocity * time;
      final dy = math.sin(particle.angle) * particle.velocity * time +
          0.5 * gravity * time * time;

      final position = center + Offset(dx, dy);
      final opacity = (1 - progress).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = particle.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(position.dx, position.dy);
      canvas.rotate(particle.rotationSpeed * progress * math.pi * 2);

      switch (particle.shape) {
        case _ConfettiShape.square:
          canvas.drawRect(
            Rect.fromCenter(
                center: Offset.zero,
                width: particle.size,
                height: particle.size),
            paint,
          );
        case _ConfettiShape.circle:
          canvas.drawCircle(Offset.zero, particle.size / 2, paint);
        case _ConfettiShape.triangle:
          final path = Path()
            ..moveTo(0, -particle.size / 2)
            ..lineTo(-particle.size / 2, particle.size / 2)
            ..lineTo(particle.size / 2, particle.size / 2)
            ..close();
          canvas.drawPath(path, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// =============================================================================
// 2. CHECKMARK DRAW - Animated checkmark for completion
// =============================================================================

class CheckmarkDraw extends StatefulWidget {
  final bool show;
  final double size;
  final Color color;
  final double strokeWidth;
  final Duration duration;
  final VoidCallback? onComplete;

  const CheckmarkDraw({
    super.key,
    required this.show,
    this.size = 48,
    this.color = AppColors.brandPrimary,
    this.strokeWidth = 4.0,
    this.duration = const Duration(milliseconds: 400),
    this.onComplete,
  });

  @override
  State<CheckmarkDraw> createState() => _CheckmarkDrawState();
}

class _CheckmarkDrawState extends State<CheckmarkDraw>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    if (widget.show) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant CheckmarkDraw oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show && !oldWidget.show) {
      _controller.forward(from: 0);
    } else if (!widget.show && oldWidget.show) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _CheckmarkPainter(
              progress: _controller.value,
              color: widget.color,
              strokeWidth: widget.strokeWidth,
            ),
          );
        },
      ),
    );
  }
}

class _CheckmarkPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _CheckmarkPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Checkmark path points (normalized 0-1)
    final start = Offset(size.width * 0.2, size.height * 0.5);
    final mid = Offset(size.width * 0.4, size.height * 0.7);
    final end = Offset(size.width * 0.8, size.height * 0.3);

    final path = Path();

    if (progress <= 0.5) {
      // Draw first stroke (start to mid)
      final t = progress * 2;
      final currentPoint = Offset.lerp(start, mid, t)!;
      path.moveTo(start.dx, start.dy);
      path.lineTo(currentPoint.dx, currentPoint.dy);
    } else {
      // Draw complete first stroke and partial second stroke
      path.moveTo(start.dx, start.dy);
      path.lineTo(mid.dx, mid.dy);

      final t = (progress - 0.5) * 2;
      final currentPoint = Offset.lerp(mid, end, t)!;
      path.lineTo(currentPoint.dx, currentPoint.dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// =============================================================================
// 3. STAR BURST - For PRs and special achievements
// =============================================================================

class StarBurst extends StatefulWidget {
  final bool trigger;
  final double size;
  final Color color;
  final int rayCount;
  final Duration duration;

  const StarBurst({
    super.key,
    required this.trigger,
    this.size = 100,
    this.color = AppColors.warning,
    this.rayCount = 8,
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  State<StarBurst> createState() => _StarBurstState();
}

class _StarBurstState extends State<StarBurst>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
  }

  @override
  void didUpdateWidget(covariant StarBurst oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _StarBurstPainter(
              progress: _controller.value,
              color: widget.color,
              rayCount: widget.rayCount,
            ),
          );
        },
      ),
    );
  }
}

class _StarBurstPainter extends CustomPainter {
  final double progress;
  final Color color;
  final int rayCount;

  _StarBurstPainter({
    required this.progress,
    required this.color,
    required this.rayCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    // Burst out then fade
    final scale = Curves.easeOutCubic.transform(math.min(progress * 2, 1.0));
    final opacity = progress < 0.5 ? 1.0 : (1 - (progress - 0.5) * 2);

    final paint = Paint()
      ..color = color.withValues(alpha: opacity.clamp(0.0, 1.0))
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < rayCount; i++) {
      final angle = (i / rayCount) * 2 * math.pi;
      final innerRadius = maxRadius * 0.3 * scale;
      final outerRadius = maxRadius * scale;

      final startPoint = Offset(
        center.dx + math.cos(angle) * innerRadius,
        center.dy + math.sin(angle) * innerRadius,
      );
      final endPoint = Offset(
        center.dx + math.cos(angle) * outerRadius,
        center.dy + math.sin(angle) * outerRadius,
      );

      canvas.drawLine(startPoint, endPoint, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StarBurstPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// =============================================================================
// 4. SUCCESS RIPPLE - Growing circle for success feedback
// =============================================================================

class SuccessRipple extends StatefulWidget {
  final bool trigger;
  final double maxSize;
  final Color color;
  final Duration duration;

  const SuccessRipple({
    super.key,
    required this.trigger,
    this.maxSize = 200,
    this.color = AppColors.brandPrimary,
    this.duration = const Duration(milliseconds: 600),
  });

  @override
  State<SuccessRipple> createState() => _SuccessRippleState();
}

class _SuccessRippleState extends State<SuccessRipple>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
  }

  @override
  void didUpdateWidget(covariant SuccessRipple oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = Curves.easeOut.transform(_controller.value);
        final opacity = 1 - _controller.value;

        return Container(
          width: widget.maxSize * scale,
          height: widget.maxSize * scale,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.color.withValues(alpha: opacity),
              width: 3,
            ),
          ),
        );
      },
    );
  }
}
