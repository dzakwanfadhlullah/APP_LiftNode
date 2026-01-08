import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// =============================================================================
// 1. BOUNCE ON TAP - Scale bounce feedback wrapper
// =============================================================================

class BounceOnTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double scaleFactor;
  final Duration duration;
  final bool enableHaptic;

  const BounceOnTap({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.scaleFactor = 0.95,
    this.duration = const Duration(milliseconds: 100),
    this.enableHaptic = true,
  });

  @override
  State<BounceOnTap> createState() => _BounceOnTapState();
}

class _BounceOnTapState extends State<BounceOnTap>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: widget.scaleFactor).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  void _onTap() {
    if (widget.enableHaptic && !kIsWeb) {
      HapticFeedback.lightImpact();
    }
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap != null ? _onTap : null,
      onLongPress: widget.onLongPress,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

// =============================================================================
// 2. WIGGLE ON ERROR - Shake animation for validation
// =============================================================================

class WiggleOnError extends StatefulWidget {
  final Widget child;
  final bool shouldWiggle;
  final Duration duration;
  final double intensity;
  final VoidCallback? onWiggleComplete;

  const WiggleOnError({
    super.key,
    required this.child,
    required this.shouldWiggle,
    this.duration = const Duration(milliseconds: 400),
    this.intensity = 10.0,
    this.onWiggleComplete,
  });

  @override
  State<WiggleOnError> createState() => _WiggleOnErrorState();
}

class _WiggleOnErrorState extends State<WiggleOnError>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _wiggleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _wiggleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticIn),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        widget.onWiggleComplete?.call();
      }
    });
  }

  @override
  void didUpdateWidget(covariant WiggleOnError oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldWiggle && !oldWidget.shouldWiggle) {
      if (!kIsWeb) HapticFeedback.mediumImpact();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getWiggleOffset(double value) {
    // Create a shake pattern using sine wave
    return math.sin(value * math.pi * 4) * widget.intensity * (1 - value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _wiggleAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_getWiggleOffset(_wiggleAnimation.value), 0),
          child: widget.child,
        );
      },
    );
  }
}

// =============================================================================
// 3. PRESS EFFECT - Visual press feedback with color overlay
// =============================================================================

class PressEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color overlayColor;
  final double overlayOpacity;
  final BorderRadius? borderRadius;

  const PressEffect({
    super.key,
    required this.child,
    this.onTap,
    this.overlayColor = Colors.white,
    this.overlayOpacity = 0.1,
    this.borderRadius,
  });

  @override
  State<PressEffect> createState() => _PressEffectState();
}

class _PressEffectState extends State<PressEffect> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        if (!kIsWeb) HapticFeedback.selectionClick();
        widget.onTap?.call();
      },
      child: Stack(
        children: [
          widget.child,
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: _isPressed ? widget.overlayOpacity : 0.0,
              duration: const Duration(milliseconds: 100),
              child: Container(
                decoration: BoxDecoration(
                  color: widget.overlayColor,
                  borderRadius: widget.borderRadius,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// 4. LONG PRESS PROGRESS - Visual feedback for long press actions
// =============================================================================

class LongPressProgress extends StatefulWidget {
  final Widget child;
  final VoidCallback onComplete;
  final Duration holdDuration;
  final Color progressColor;
  final double strokeWidth;

  const LongPressProgress({
    super.key,
    required this.child,
    required this.onComplete,
    this.holdDuration = const Duration(milliseconds: 1000),
    this.progressColor = const Color(0xFFB6F09C),
    this.strokeWidth = 3.0,
  });

  @override
  State<LongPressProgress> createState() => _LongPressProgressState();
}

class _LongPressProgressState extends State<LongPressProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHolding = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.holdDuration,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!kIsWeb) HapticFeedback.heavyImpact();
        widget.onComplete();
        _controller.reset();
        setState(() => _isHolding = false);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onLongPressStart(LongPressStartDetails details) {
    setState(() => _isHolding = true);
    _controller.forward();
  }

  void _onLongPressEnd(LongPressEndDetails details) {
    _controller.reset();
    setState(() => _isHolding = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: _onLongPressStart,
      onLongPressEnd: _onLongPressEnd,
      onLongPressCancel: () {
        _controller.reset();
        setState(() => _isHolding = false);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          widget.child,
          if (_isHolding)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _CircularProgressPainter(
                      progress: _controller.value,
                      color: widget.progressColor,
                      strokeWidth: widget.strokeWidth,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) / 2) - strokeWidth;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
