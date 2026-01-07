import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_theme.dart';

// =============================================================================
// GYM CARD - Enhanced with onLongPress, hover, and press animations
// =============================================================================

class GymCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final Border? border;
  final double? width;
  final double? height;
  final Gradient? gradient;
  final bool isLoading;
  final bool enableHover;

  const GymCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.border,
    this.width,
    this.height,
    this.gradient,
    this.isLoading = false,
    this.enableHover = true,
  });

  @override
  State<GymCard> createState() => _GymCardState();
}

class _GymCardState extends State<GymCard> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final scale = _isPressed ? 0.98 : (_isHovered ? 1.01 : 1.0);
    final bgColor = _isHovered
        ? AppColors.bgCardHover
        : (widget.backgroundColor ?? AppColors.bgCard);

    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress != null
          ? () {
              HapticFeedback.mediumImpact();
              widget.onLongPress!();
            }
          : null,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: MouseRegion(
        onEnter: widget.enableHover
            ? (_) => setState(() => _isHovered = true)
            : null,
        onExit: widget.enableHover
            ? (_) => setState(() => _isHovered = false)
            : null,
        child: AnimatedScale(
          scale: scale,
          duration: AppAnimations.fast,
          curve: AppAnimations.snappy,
          child: AnimatedContainer(
            duration: AppAnimations.cardHover,
            curve: AppAnimations.defaultCurve,
            width: widget.width,
            height: widget.height,
            margin: widget.margin,
            padding: widget.padding ?? Spacing.paddingCard,
            decoration: BoxDecoration(
              color: widget.gradient == null ? bgColor : null,
              gradient: widget.gradient,
              borderRadius: AppRadius.roundedLg,
              border: widget.border ??
                  Border.all(
                    color:
                        _isHovered ? AppColors.borderFocused : AppColors.border,
                    width: 1,
                  ),
              boxShadow: _isHovered ? AppShadows.lg : AppShadows.md,
            ),
            child: widget.isLoading ? _buildShimmer() : widget.child,
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return ShimmerEffect(
      child: Container(
        height: 60,
        decoration: const BoxDecoration(
          color: AppColors.bgCardHover,
          borderRadius: AppRadius.roundedMd,
        ),
      ),
    );
  }
}

// Shimmer Effect Helper
class ShimmerEffect extends StatefulWidget {
  final Widget child;
  const ShimmerEffect({super.key, required this.child});

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}
