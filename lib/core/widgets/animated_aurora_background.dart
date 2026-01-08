import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../app_theme.dart';

class AnimatedAuroraBackground extends StatefulWidget {
  final Widget? child;
  const AnimatedAuroraBackground({super.key, this.child});

  @override
  State<AnimatedAuroraBackground> createState() =>
      _AnimatedAuroraBackgroundState();
}

class _AnimatedAuroraBackgroundState extends State<AnimatedAuroraBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      body: Stack(
        children: [
          // Aurora Orbs
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Stack(
                children: [
                  _AuroraOrb(
                    size: 400,
                    color: AppColors.brandPrimary.withValues(alpha: 0.15),
                    offsetX:
                        0.2 + 0.1 * math.sin(_controller.value * 2 * math.pi),
                    offsetY:
                        0.1 + 0.05 * math.cos(_controller.value * 2 * math.pi),
                    blur: 100,
                  ),
                  _AuroraOrb(
                    size: 350,
                    color: AppColors.brandSecondary.withValues(alpha: 0.1),
                    offsetX:
                        0.7 + 0.1 * math.cos(_controller.value * 2 * math.pi),
                    offsetY:
                        0.3 + 0.08 * math.sin(_controller.value * 2 * math.pi),
                    blur: 120,
                  ),
                  _AuroraOrb(
                    size: 450,
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.1),
                    offsetX: 0.4 +
                        0.15 * math.sin(_controller.value * 1.5 * math.pi),
                    offsetY:
                        0.8 + 0.1 * math.cos(_controller.value * 1.5 * math.pi),
                    blur: 140,
                  ),
                ],
              );
            },
          ),

          // Subtle Noise/Texture (Optional, using a semi-transparent filter for premium feel)
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.05),
            ),
          ),

          if (widget.child != null) widget.child!,
        ],
      ),
    );
  }
}

class _AuroraOrb extends StatelessWidget {
  final double size;
  final Color color;
  final double offsetX;
  final double offsetY;
  final double blur;

  const _AuroraOrb({
    required this.size,
    required this.color,
    required this.offsetX,
    required this.offsetY,
    required this.blur,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      left: offsetX * screenWidth - size / 2,
      top: offsetY * screenHeight - size / 2,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: BackdropFilter(
          filter: ColorFilter.mode(
            Colors.transparent,
            BlendMode.multiply,
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color,
                  blurRadius: blur,
                  spreadRadius: size / 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
