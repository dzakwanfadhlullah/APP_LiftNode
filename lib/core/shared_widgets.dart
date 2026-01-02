import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'app_theme.dart';

// =============================================================================
// PHASE 2.1: GYM CARD - Enhanced with onLongPress, hover, and press animations
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
    return _ShimmerEffect(
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

class _ShimmerEffect extends StatefulWidget {
  final Widget child;
  const _ShimmerEffect({required this.child});

  @override
  State<_ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<_ShimmerEffect>
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

// =============================================================================
// PHASE 2.2: NEON BUTTON - Enhanced with size variants and icon-only mode
// =============================================================================

enum ButtonSize { small, medium, large }

class NeonButton extends StatefulWidget {
  final String? title;
  final VoidCallback? onPress;
  final IconData? icon;
  final String variant;
  final ButtonSize size;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final bool isLoading;
  final bool isDisabled;
  final bool isIconOnly;

  const NeonButton({
    super.key,
    this.title,
    this.onPress,
    this.icon,
    this.variant = 'primary',
    this.size = ButtonSize.medium,
    this.width,
    this.height,
    this.padding,
    this.isLoading = false,
    this.isDisabled = false,
    this.isIconOnly = false,
  });

  // Named constructors for convenience
  const NeonButton.icon({
    super.key,
    required IconData this.icon,
    this.onPress,
    this.variant = 'ghost',
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
  })  : title = null,
        width = null,
        height = null,
        padding = null,
        isIconOnly = true;

  const NeonButton.small({
    super.key,
    required String this.title,
    this.onPress,
    this.icon,
    this.variant = 'primary',
    this.width,
    this.isLoading = false,
    this.isDisabled = false,
  })  : size = ButtonSize.small,
        height = null,
        padding = null,
        isIconOnly = false;

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> {
  bool _isPressed = false;

  double get _height {
    if (widget.height != null) return widget.height!;
    switch (widget.size) {
      case ButtonSize.small:
        return 36;
      case ButtonSize.medium:
        return 48;
      case ButtonSize.large:
        return 56;
    }
  }

  double get _iconSize {
    switch (widget.size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
    }
  }

  TextStyle get _textStyle {
    switch (widget.size) {
      case ButtonSize.small:
        return AppTypography.buttonSmall;
      case ButtonSize.medium:
        return AppTypography.button;
      case ButtonSize.large:
        return AppTypography.button;
    }
  }

  EdgeInsets get _padding {
    if (widget.padding != null) return widget.padding!;
    if (widget.isIconOnly) {
      return EdgeInsets.zero;
    }
    switch (widget.size) {
      case ButtonSize.small:
        return Spacing.paddingHorizontalMd;
      case ButtonSize.medium:
        return Spacing.paddingHorizontalLg;
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _getVariantConfig();
    final isEnabled =
        !widget.isDisabled && !widget.isLoading && widget.onPress != null;
    final scale = _isPressed ? 0.95 : 1.0;

    if (widget.isIconOnly) {
      return _buildIconButton(config, isEnabled, scale);
    }

    return AnimatedScale(
      scale: scale,
      duration: AppAnimations.buttonPress,
      curve: AppAnimations.snappy,
      child: SizedBox(
        width: widget.width,
        height: _height,
        child: AnimatedOpacity(
          duration: AppAnimations.fast,
          opacity: isEnabled ? 1.0 : 0.5,
          child: ElevatedButton(
            onPressed: isEnabled ? _handlePress : null,
            onLongPress: null,
            style: ElevatedButton.styleFrom(
              padding: _padding,
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
            child: GestureDetector(
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapUp: (_) => setState(() => _isPressed = false),
              onTapCancel: () => setState(() => _isPressed = false),
              child: widget.isLoading
                  ? _buildLoader(config)
                  : _buildContent(config),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(_ButtonConfig config, bool isEnabled, double scale) {
    return AnimatedScale(
      scale: scale,
      duration: AppAnimations.buttonPress,
      curve: AppAnimations.snappy,
      child: AnimatedOpacity(
        duration: AppAnimations.fast,
        opacity: isEnabled ? 1.0 : 0.5,
        child: Material(
          color: config.backgroundColor,
          borderRadius: AppRadius.roundedMd,
          child: InkWell(
            onTap: isEnabled ? _handlePress : null,
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            borderRadius: AppRadius.roundedMd,
            child: Container(
              width: _height,
              height: _height,
              decoration: BoxDecoration(
                borderRadius: AppRadius.roundedMd,
                border: config.borderSide != BorderSide.none
                    ? Border.fromBorderSide(config.borderSide)
                    : null,
              ),
              child: Center(
                child: widget.isLoading
                    ? SizedBox(
                        width: _iconSize,
                        height: _iconSize,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: config.foregroundColor,
                        ),
                      )
                    : Icon(widget.icon,
                        size: _iconSize, color: config.foregroundColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handlePress() {
    if (!kIsWeb) HapticFeedback.lightImpact();
    widget.onPress!();
  }

  Widget _buildLoader(_ButtonConfig config) {
    return SizedBox(
      width: _iconSize,
      height: _iconSize,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: config.foregroundColor,
      ),
    );
  }

  Widget _buildContent(_ButtonConfig config) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, size: _iconSize),
          if (widget.title != null) Spacing.hSm,
        ],
        if (widget.title != null) Text(widget.title!, style: _textStyle),
      ],
    );
  }

  _ButtonConfig _getVariantConfig() {
    switch (widget.variant) {
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
      case 'success':
        return _ButtonConfig(
          backgroundColor: AppColors.success,
          foregroundColor: AppColors.textInverse,
          borderSide: BorderSide.none,
        );
      case 'ghost':
        return _ButtonConfig(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.textSecondary,
          borderSide: BorderSide.none,
        );
      case 'info':
        return _ButtonConfig(
          backgroundColor: AppColors.info,
          foregroundColor: Colors.white,
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
// PHASE 2.3: GYM BADGE - Enhanced with variants (solid, outlined, subtle)
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
      return _PulsingBadge(child: badge);
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
// PHASE 2.4: NEW SHARED WIDGETS
// =============================================================================

// GYM TYPOGRAPHY
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

// GYM DIVIDER
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

// GYM AVATAR
class GymAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final Color? borderColor;
  final double borderWidth;
  final bool isOnline;

  const GymAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 48,
    this.borderColor,
    this.borderWidth = 2,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
                      fontSize: size * 0.35,
                    ),
                  ),
                )
              : null,
        ),
        if (isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.28,
              height: size * 0.28,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.bgMain, width: 2),
              ),
            ),
          ),
      ],
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

// GYM INPUT
class GymInput extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final int? maxLines;
  final FocusNode? focusNode;

  const GymInput({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(label!, style: AppTypography.labelMedium),
          Spacing.vXs,
        ],
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: onChanged,
          enabled: enabled,
          maxLines: maxLines,
          focusNode: focusNode,
          style:
              AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
            errorText: errorText,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 20, color: AppColors.textSecondary)
                : null,
            suffixIcon: suffixIcon != null
                ? GestureDetector(
                    onTap: onSuffixTap,
                    child: Icon(suffixIcon,
                        size: 20, color: AppColors.textSecondary),
                  )
                : null,
            filled: true,
            fillColor: AppColors.bgInput,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: Spacing.inputPadding,
            ),
            border: const OutlineInputBorder(
              borderRadius: AppRadius.roundedMd,
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: AppRadius.roundedMd,
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: AppRadius.roundedMd,
              borderSide: BorderSide(color: AppColors.brandPrimary, width: 2),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: AppRadius.roundedMd,
              borderSide: BorderSide(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }
}

// GYM PROGRESS BAR
class GymProgressBar extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;
  final Gradient? progressGradient;
  final bool showLabel;
  final String? label;

  const GymProgressBar({
    super.key,
    required this.value,
    this.height = 8,
    this.backgroundColor,
    this.progressColor,
    this.progressGradient,
    this.showLabel = false,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null) Text(label!, style: AppTypography.labelSmall),
              Text(
                '${(value * 100).toInt()}%',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          Spacing.vXs,
        ],
        Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.bgCard,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  AnimatedContainer(
                    duration: AppAnimations.normal,
                    curve: AppAnimations.smooth,
                    width: constraints.maxWidth * value.clamp(0.0, 1.0),
                    height: height,
                    decoration: BoxDecoration(
                      color: progressGradient == null
                          ? (progressColor ?? AppColors.brandPrimary)
                          : null,
                      gradient: progressGradient,
                      borderRadius: BorderRadius.circular(height / 2),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

// GYM LIST TILE
class GymListTile extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? backgroundColor;
  final EdgeInsets? contentPadding;

  const GymListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.backgroundColor,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return GymCard(
      padding: contentPadding ?? Spacing.paddingCard,
      backgroundColor: backgroundColor,
      onTap: onTap,
      onLongPress: onLongPress,
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            Spacing.hMd,
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: AppTypography.titleMedium),
                if (subtitle != null) ...[
                  Spacing.vXxs,
                  Text(
                    subtitle!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

// GYM SWITCH
class GymSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final String? label;

  const GymSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(label!, style: AppTypography.bodyMedium),
          Spacing.hMd,
        ],
        GestureDetector(
          onTap: onChanged != null ? () => onChanged!(!value) : null,
          child: AnimatedContainer(
            duration: AppAnimations.fast,
            width: 48,
            height: 28,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: value
                  ? (activeColor ?? AppColors.brandPrimary)
                  : AppColors.bgCardHover,
              borderRadius: BorderRadius.circular(14),
            ),
            child: AnimatedAlign(
              duration: AppAnimations.fast,
              curve: AppAnimations.snappy,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// GYM EMPTY STATE
class GymEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;

  const GymEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: Spacing.paddingScreen,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(Spacing.lg),
              decoration: const BoxDecoration(
                color: AppColors.bgCard,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: AppColors.textMuted),
            ),
            Spacing.vLg,
            Text(
              title,
              style: AppTypography.headlineSmall,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              Spacing.vSm,
              Text(
                subtitle!,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              Spacing.vLg,
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// PHASE 9.1: GLOBAL ERROR HANDLING & RESILIENCE
// =============================================================================

class GlobalErrorBoundary extends StatefulWidget {
  final Widget child;

  const GlobalErrorBoundary({super.key, required this.child});

  @override
  State<GlobalErrorBoundary> createState() => _GlobalErrorBoundaryState();
}

class _GlobalErrorBoundaryState extends State<GlobalErrorBoundary> {
  FlutterErrorDetails? _errorDetails;

  @override
  void initState() {
    super.initState();
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      setState(() {
        _errorDetails = details;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_errorDetails != null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: Scaffold(
          backgroundColor: const Color(0xFF09090B),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.triangleAlert,
                      size: 64, color: Color(0xFFEF4444)),
                  const SizedBox(height: 24),
                  const Text(
                    'Oops! Something went wrong',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'An unexpected error occurred. We\'ve been notified and are working on it.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 32),
                  NeonButton(
                    title: 'Restart App',
                    onPress: () {
                      setState(() {
                        _errorDetails = null;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: _errorDetails.toString()));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Error details copied to clipboard')),
                      );
                    },
                    child: Text(
                      'Copy Error Details',
                      style:
                          TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return widget.child;
  }
}
