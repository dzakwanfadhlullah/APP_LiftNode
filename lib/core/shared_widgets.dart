import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'app_theme.dart';

// =============================================================================
// GYM CARD - Premium card component with design tokens
// =============================================================================

class GymCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final Border? border;
  final double? width;
  final Gradient? gradient;
  final bool isLoading;

  const GymCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.border,
    this.width,
    this.gradient,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppAnimations.cardHover,
        curve: AppAnimations.defaultCurve,
        width: width,
        margin: margin,
        padding: padding ?? Spacing.paddingCard,
        decoration: BoxDecoration(
          color:
              gradient == null ? (backgroundColor ?? AppColors.bgCard) : null,
          gradient: gradient,
          borderRadius: AppRadius.roundedLg,
          border: border ?? Border.all(color: AppColors.border, width: 1),
          boxShadow: AppShadows.md,
        ),
        child: isLoading ? _buildShimmer() : child,
      ),
    );
  }

  Widget _buildShimmer() {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: AppColors.bgCardHover,
        borderRadius: AppRadius.roundedMd,
      ),
    );
  }
}

// =============================================================================
// NEON BUTTON - Primary action button with variants
// =============================================================================

class NeonButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPress;
  final IconData? icon;
  final String variant; // primary, secondary, danger, warning, ghost
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final bool isLoading;
  final bool isDisabled;

  const NeonButton({
    super.key,
    required this.title,
    this.onPress,
    this.icon,
    this.variant = 'primary',
    this.width,
    this.height,
    this.padding,
    this.isLoading = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getVariantConfig();
    final isEnabled = !isDisabled && !isLoading && onPress != null;

    return SizedBox(
      width: width,
      height: height ?? 52,
      child: AnimatedOpacity(
        duration: AppAnimations.fast,
        opacity: isEnabled ? 1.0 : 0.5,
        child: ElevatedButton(
          onPressed: isEnabled
              ? () {
                  Vibration.vibrate(duration: 10);
                  onPress!();
                }
              : null,
          style: ElevatedButton.styleFrom(
            padding: padding ?? Spacing.paddingHorizontalLg,
            backgroundColor: config.backgroundColor,
            foregroundColor: config.foregroundColor,
            disabledBackgroundColor:
                config.backgroundColor.withValues(alpha: 0.5),
            disabledForegroundColor:
                config.foregroundColor.withValues(alpha: 0.5),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.roundedMd,
              side: config.borderSide,
            ),
          ),
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: config.foregroundColor,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 20),
                      Spacing.hSm,
                    ],
                    Text(title, style: AppTypography.button),
                  ],
                ),
        ),
      ),
    );
  }

  _ButtonConfig _getVariantConfig() {
    switch (variant) {
      case 'secondary':
        return _ButtonConfig(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.textPrimary,
          borderSide: const BorderSide(color: AppColors.border),
        );
      case 'danger':
        return _ButtonConfig(
          backgroundColor: AppColors.error,
          foregroundColor: Colors.white,
          borderSide: BorderSide.none,
        );
      case 'warning':
        return _ButtonConfig(
          backgroundColor: AppColors.warning,
          foregroundColor: AppColors.textInverse,
          borderSide: BorderSide.none,
        );
      case 'ghost':
        return _ButtonConfig(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.textSecondary,
          borderSide: BorderSide.none,
        );
      case 'primary':
      default:
        return _ButtonConfig(
          backgroundColor: AppColors.brandPrimary,
          foregroundColor: AppColors.onPrimary,
          borderSide: BorderSide.none,
        );
    }
  }
}

class _ButtonConfig {
  final Color backgroundColor;
  final Color foregroundColor;
  final BorderSide borderSide;

  _ButtonConfig({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderSide,
  });
}

// =============================================================================
// GYM BADGE - Status indicator with icon support
// =============================================================================

class GymBadge extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;
  final bool pulse;

  const GymBadge({
    super.key,
    required this.text,
    this.color = AppColors.brandPrimary,
    this.icon,
    this.pulse = false,
  });

  @override
  Widget build(BuildContext context) {
    final badge = Container(
      padding: Spacing.paddingBadge,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: AppRadius.roundedXs,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: color),
            Spacing.hXxs,
          ],
          Text(
            text,
            style: AppTypography.overline.copyWith(color: color),
          ),
        ],
      ),
    );

    if (pulse) {
      return _PulsingBadge(child: badge);
    }
    return badge;
  }
}

class _PulsingBadge extends StatefulWidget {
  final Widget child;
  const _PulsingBadge({required this.child});

  @override
  State<_PulsingBadge> createState() => _PulsingBadgeState();
}

class _PulsingBadgeState extends State<_PulsingBadge>
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

// =============================================================================
// GYM TYPOGRAPHY - Standardized text component
// =============================================================================

class GymTypography extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? align;
  final Color? color;
  final int? maxLines;
  final TextOverflow? overflow;

  const GymTypography(
    this.text, {
    super.key,
    this.style,
    this.align,
    this.color,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
      style: (style ?? AppTypography.bodyMedium).copyWith(color: color),
    );
  }
}

// =============================================================================
// GYM DIVIDER - Customizable divider
// =============================================================================

class GymDivider extends StatelessWidget {
  final double? thickness;
  final Color? color;
  final double? indent;
  final double? endIndent;
  final double? height;

  const GymDivider({
    super.key,
    this.thickness,
    this.color,
    this.indent,
    this.endIndent,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: thickness ?? 1,
      color: color ?? AppColors.border,
      indent: indent ?? 0,
      endIndent: endIndent ?? 0,
      height: height ?? Spacing.md,
    );
  }
}

// =============================================================================
// GYM AVATAR - User avatar with loading and placeholder states
// =============================================================================

class GymAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final Color? borderColor;
  final double borderWidth;

  const GymAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 48,
    this.borderColor,
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.bgCard,
        border: Border.all(
          color: borderColor ?? AppColors.border,
          width: borderWidth,
        ),
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: imageUrl == null
          ? Center(
              child: Text(
                _getInitials(),
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            )
          : null,
    );
  }

  String _getInitials() {
    if (name == null || name!.isEmpty) return '?';
    final parts = name!.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}
