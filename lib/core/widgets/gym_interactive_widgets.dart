import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../app_theme.dart';

// =============================================================================
// INTERACTIVE FORM COMPONENTS: RadioGroup, Checkbox, Dropdown
// =============================================================================

// GYM RADIO GROUP
class GymRadioGroup<T> extends StatelessWidget {
  final List<GymRadioOption<T>> options;
  final T? value;
  final ValueChanged<T>? onChanged;
  final String? label;
  final Axis direction;

  const GymRadioGroup({
    super.key,
    required this.options,
    this.value,
    this.onChanged,
    this.label,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(label!, style: AppTypography.labelMedium),
          Spacing.vSm,
        ],
        direction == Axis.vertical
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: options.map((opt) => _buildOption(opt)).toList(),
              )
            : Wrap(
                spacing: Spacing.md,
                runSpacing: Spacing.sm,
                children: options.map((opt) => _buildOption(opt)).toList(),
              ),
      ],
    );
  }

  Widget _buildOption(GymRadioOption<T> option) {
    final isSelected = value == option.value;
    return GestureDetector(
      onTap: onChanged != null && !option.disabled
          ? () {
              if (!kIsWeb) HapticFeedback.selectionClick();
              onChanged!(option.value);
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: AppAnimations.fast,
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.brandPrimary
                      : option.disabled
                          ? AppColors.textDisabled
                          : AppColors.border,
                  width: 2,
                ),
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: AppAnimations.fast,
                  width: isSelected ? 10 : 0,
                  height: isSelected ? 10 : 0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? AppColors.brandPrimary
                        : Colors.transparent,
                  ),
                ),
              ),
            ),
            Spacing.hSm,
            Text(
              option.label,
              style: AppTypography.bodyMedium.copyWith(
                color: option.disabled
                    ? AppColors.textDisabled
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GymRadioOption<T> {
  final T value;
  final String label;
  final bool disabled;

  const GymRadioOption({
    required this.value,
    required this.label,
    this.disabled = false,
  });
}

// GYM CHECKBOX
class GymCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final String? sublabel;
  final bool disabled;
  final Color? activeColor;

  const GymCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.sublabel,
    this.disabled = false,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = activeColor ?? AppColors.brandPrimary;

    return GestureDetector(
      onTap: !disabled && onChanged != null
          ? () {
              if (!kIsWeb) HapticFeedback.selectionClick();
              onChanged!(!value);
            }
          : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: AppAnimations.fast,
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: value ? color : Colors.transparent,
              borderRadius: AppRadius.roundedXs,
              border: Border.all(
                color: value
                    ? color
                    : disabled
                        ? AppColors.textDisabled
                        : AppColors.border,
                width: 2,
              ),
            ),
            child: value
                ? const Icon(
                    LucideIcons.check,
                    size: 14,
                    color: Colors.white,
                  )
                : null,
          ),
          if (label != null) ...[
            Spacing.hSm,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label!,
                    style: AppTypography.bodyMedium.copyWith(
                      color: disabled
                          ? AppColors.textDisabled
                          : AppColors.textPrimary,
                    ),
                  ),
                  if (sublabel != null)
                    Text(
                      sublabel!,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// GYM DROPDOWN
class GymDropdown<T> extends StatelessWidget {
  final List<GymDropdownItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final String? hint;
  final bool disabled;

  const GymDropdown({
    super.key,
    required this.items,
    this.value,
    this.onChanged,
    this.label,
    this.hint,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final selectedItem = items.where((i) => i.value == value).firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(label!, style: AppTypography.labelMedium),
          Spacing.vXs,
        ],
        GestureDetector(
          onTap: !disabled ? () => _showDropdownSheet(context) : null,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.md,
              vertical: Spacing.inputPadding,
            ),
            decoration: BoxDecoration(
              color: AppColors.bgInput,
              borderRadius: AppRadius.roundedMd,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedItem?.label ?? hint ?? 'Select...',
                    style: AppTypography.bodyMedium.copyWith(
                      color: selectedItem != null
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                    ),
                  ),
                ),
                Icon(
                  LucideIcons.chevronDown,
                  size: 18,
                  color: disabled
                      ? AppColors.textDisabled
                      : AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDropdownSheet(BuildContext context) {
    if (!kIsWeb) HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Container(
        padding: Spacing.paddingCard,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.border,
                borderRadius: AppRadius.roundedFull,
              ),
            ),
            Spacing.vLg,
            if (label != null) ...[
              Text(label!, style: AppTypography.headlineSmall),
              Spacing.vLg,
            ],
            ...items.map((item) {
              final isSelected = item.value == value;
              return GestureDetector(
                onTap: () {
                  if (!kIsWeb) HapticFeedback.selectionClick();
                  onChanged?.call(item.value);
                  Navigator.pop(ctx);
                },
                child: Container(
                  width: double.infinity,
                  padding: Spacing.paddingCard,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.brandPrimary.withValues(alpha: 0.1)
                        : AppColors.bgCardHover,
                    borderRadius: AppRadius.roundedMd,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.brandPrimary
                          : AppColors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      if (item.icon != null) ...[
                        Icon(item.icon,
                            size: 20, color: AppColors.textSecondary),
                        Spacing.hMd,
                      ],
                      Expanded(
                        child: Text(
                          item.label,
                          style: AppTypography.bodyMedium.copyWith(
                            color: isSelected
                                ? AppColors.brandPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          LucideIcons.check,
                          size: 18,
                          color: AppColors.brandPrimary,
                        ),
                    ],
                  ),
                ),
              );
            }),
            Spacing.vMd,
          ],
        ),
      ),
    );
  }
}

class GymDropdownItem<T> {
  final T value;
  final String label;
  final IconData? icon;

  const GymDropdownItem({
    required this.value,
    required this.label,
    this.icon,
  });
}
