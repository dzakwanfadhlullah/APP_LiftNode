import 'package:flutter/material.dart';
import '../app_theme.dart';

// =============================================================================
// FORM WIDGETS: GymInput, GymSwitch
// =============================================================================

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
