import 'package:flutter/material.dart';
import '../app_theme.dart';
import 'glass_card.dart'; // Phase 2.1.M1: Migrated from gym_card.dart

// =============================================================================
// DISPLAY WIDGETS: Typography, Divider, Avatar, ProgressBar, ListTile, EmptyState
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
    // Phase 2.1.M1: Migrated to GlassCard.frosted
    return GlassCard.frosted(
      padding: contentPadding ?? Spacing.paddingCard,
      accentColor: backgroundColor, // Use as accent for glow effect
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
