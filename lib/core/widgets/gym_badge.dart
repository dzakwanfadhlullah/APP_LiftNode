import 'package:flutter/material.dart';
import '../app_theme.dart';

// =============================================================================
// GYM BADGE - Enhanced with variants (solid, outlined, subtle)
// =============================================================================

enum BadgeVariant { solid, outlined, subtle }

class GymBadge extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;
  final bool pulse;
  final BadgeVariant variant;

  const GymBadge({
    super.key,
    required this.text,
    this.color = AppColors.brandPrimary,
    this.icon,
    this.pulse = false,
    this.variant = BadgeVariant.subtle,
  });

  const GymBadge.solid({
    super.key,
    required this.text,
    this.color = AppColors.brandPrimary,
    this.icon,
    this.pulse = false,
  }) : variant = BadgeVariant.solid;

  const GymBadge.outlined({
    super.key,
    required this.text,
    this.color = AppColors.brandPrimary,
    this.icon,
    this.pulse = false,
  }) : variant = BadgeVariant.outlined;

  @override
  Widget build(BuildContext context) {
    final badge = Container(
      padding: Spacing.paddingBadge,
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: AppRadius.roundedXs,
        border: variant == BadgeVariant.outlined
            ? Border.all(color: color, width: 1)
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: _getTextColor()),
            Spacing.hXxs,
          ],
          Text(
            text,
            style: AppTypography.overline.copyWith(color: _getTextColor()),
          ),
        ],
      ),
    );

    if (pulse) {
      return PulsingBadge(child: badge);
    }
    return badge;
  }

  Color _getBackgroundColor() {
    switch (variant) {
      case BadgeVariant.solid:
        return color;
      case BadgeVariant.outlined:
        return Colors.transparent;
      case BadgeVariant.subtle:
        return color.withValues(alpha: 0.2);
    }
  }

  Color _getTextColor() {
    switch (variant) {
      case BadgeVariant.solid:
        return Colors.white;
      case BadgeVariant.outlined:
        return color;
      case BadgeVariant.subtle:
        return color;
    }
  }
}

class PulsingBadge extends StatefulWidget {
  final Widget child;
  const PulsingBadge({super.key, required this.child});

  @override
  State<PulsingBadge> createState() => _PulsingBadgeState();
}

class _PulsingBadgeState extends State<PulsingBadge>
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
    _animation = Tween<double>(begin: 0.7, end: 1.0).animate(
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
    return FadeTransition(opacity: _animation, child: widget.child);
  }
}
