import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../app_theme.dart';

// =============================================================================
// 1. PULSE GLOW - Breathing glow effect
// =============================================================================

class PulseGlow extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final double minGlow;
  final double maxGlow;
  final Duration duration;

  const PulseGlow({
    super.key,
    required this.child,
    this.glowColor = AppColors.brandPrimary,
    this.minGlow = 0.0,
    this.maxGlow = 12.0,
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<PulseGlow> createState() => _PulseGlowState();
}

class _PulseGlowState extends State<PulseGlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: widget.minGlow,
      end: widget.maxGlow,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withValues(alpha: 0.4),
                blurRadius: _glowAnimation.value,
                spreadRadius: _glowAnimation.value / 4,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}

// =============================================================================
// 2. SHIMMER SWEEP - Diagonal light sweep effect
// =============================================================================

class ShimmerSweep extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color shimmerColor;
  final double shimmerWidth;
  final bool enabled;

  const ShimmerSweep({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.shimmerColor = Colors.white,
    this.shimmerWidth = 100.0,
    this.enabled = true,
  });

  @override
  State<ShimmerSweep> createState() => _ShimmerSweepState();
}

class _ShimmerSweepState extends State<ShimmerSweep>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant ShimmerSweep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !oldWidget.enabled) {
      _controller.repeat();
    } else if (!widget.enabled && oldWidget.enabled) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            final position =
                _controller.value * (bounds.width + widget.shimmerWidth * 2) -
                    widget.shimmerWidth;
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.transparent,
                widget.shimmerColor.withValues(alpha: 0.15),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
              transform: _SlidingGradientTransform(position / bounds.width),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform(this.slidePercent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

// =============================================================================
// 3. FLOATING MOTION - Subtle up/down bob animation
// =============================================================================

class FloatingMotion extends StatefulWidget {
  final Widget child;
  final double amplitude;
  final Duration duration;
  final Curve curve;

  const FloatingMotion({
    super.key,
    required this.child,
    this.amplitude = 8.0,
    this.duration = const Duration(milliseconds: 2000),
    this.curve = Curves.easeInOut,
  });

  @override
  State<FloatingMotion> createState() => _FloatingMotionState();
}

class _FloatingMotionState extends State<FloatingMotion>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: -widget.amplitude,
      end: widget.amplitude,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: widget.child,
        );
      },
    );
  }
}

// =============================================================================
// 4. ROTATING GLOW - Rotating glow ring around widget
// =============================================================================

class RotatingGlow extends StatefulWidget {
  final Widget child;
  final double size;
  final List<Color> colors;
  final Duration duration;
  final double strokeWidth;

  const RotatingGlow({
    super.key,
    required this.child,
    this.size = 60,
    this.colors = const [
      AppColors.brandPrimary,
      AppColors.brandSecondary,
      AppColors.brandTertiary,
      AppColors.brandPrimary,
    ],
    this.duration = const Duration(seconds: 3),
    this.strokeWidth = 3.0,
  });

  @override
  State<RotatingGlow> createState() => _RotatingGlowState();
}

class _RotatingGlowState extends State<RotatingGlow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * math.pi,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(colors: widget.colors),
                  ),
                ),
              );
            },
          ),
          Container(
            width: widget.size - widget.strokeWidth * 2,
            height: widget.size - widget.strokeWidth * 2,
            decoration: const BoxDecoration(
              color: AppColors.bgMain,
              shape: BoxShape.circle,
            ),
            child: Center(child: widget.child),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// 5. BREATHING SCALE - Subtle scale animation for ambient feel
// =============================================================================

class BreathingScale extends StatefulWidget {
  final Widget child;
  final double minScale;
  final double maxScale;
  final Duration duration;

  const BreathingScale({
    super.key,
    required this.child,
    this.minScale = 0.98,
    this.maxScale = 1.02,
    this.duration = const Duration(milliseconds: 2000),
  });

  @override
  State<BreathingScale> createState() => _BreathingScaleState();
}

class _BreathingScaleState extends State<BreathingScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: widget.child,
    );
  }
}
