import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'app_theme.dart';

class GymCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final Border? border;
  final double? width;

  const GymCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.border,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        margin: margin,
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: border ?? Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class NeonButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;
  final IconData? icon;
  final String? variant;
  final double? width;
  final double? height;
  final EdgeInsets? padding;

  const NeonButton({
    super.key,
    required this.title,
    required this.onPress,
    this.icon,
    this.variant = 'primary',
    this.width,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final bool isReallyPrimary = variant == 'primary';

    return SizedBox(
      width: width,
      height: height ?? 52,
      child: ElevatedButton(
        onPressed: () {
          Vibration.vibrate(duration: 10);
          onPress();
        },
        style: ElevatedButton.styleFrom(
          padding: padding,
          backgroundColor:
              isReallyPrimary ? AppColors.brandPrimary : Colors.transparent,
          foregroundColor:
              isReallyPrimary ? Colors.black : AppColors.textPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isReallyPrimary
                ? BorderSide.none
                : const BorderSide(color: AppColors.textSecondary),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class GymBadge extends StatelessWidget {
  final String text;
  final Color color;

  const GymBadge({
    super.key,
    required this.text,
    this.color = AppColors.brandPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class GymTypography extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? align;
  final Color? color;

  const GymTypography(
    this.text, {
    super.key,
    this.style,
    this.align,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: (style ?? const TextStyle()).copyWith(color: color),
    );
  }
}
