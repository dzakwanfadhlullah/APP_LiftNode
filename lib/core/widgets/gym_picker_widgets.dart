import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../app_theme.dart';

// =============================================================================
// PICKER WIDGETS: DatePicker, TimePicker, Slider
// =============================================================================

// GYM DATE PICKER
class GymDatePicker extends StatelessWidget {
  final DateTime? value;
  final ValueChanged<DateTime>? onChanged;
  final String? label;
  final String? hint;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool disabled;

  const GymDatePicker({
    super.key,
    this.value,
    this.onChanged,
    this.label,
    this.hint,
    this.firstDate,
    this.lastDate,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = value != null
        ? DateFormat('MMM d, yyyy').format(value!)
        : hint ?? 'Select date...';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(label!, style: AppTypography.labelMedium),
          Spacing.vXs,
        ],
        GestureDetector(
          onTap: !disabled ? () => _showDatePicker(context) : null,
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
                Icon(
                  LucideIcons.calendar,
                  size: 18,
                  color: disabled
                      ? AppColors.textDisabled
                      : AppColors.textSecondary,
                ),
                Spacing.hSm,
                Expanded(
                  child: Text(
                    displayText,
                    style: AppTypography.bodyMedium.copyWith(
                      color: value != null
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

  Future<void> _showDatePicker(BuildContext context) async {
    if (!kIsWeb) HapticFeedback.lightImpact();

    final result = await showDatePicker(
      context: context,
      initialDate: value ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.brandPrimary,
              onPrimary: AppColors.onPrimary,
              surface: AppColors.bgCard,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (result != null) {
      onChanged?.call(result);
    }
  }
}

// GYM TIME PICKER
class GymTimePicker extends StatelessWidget {
  final TimeOfDay? value;
  final ValueChanged<TimeOfDay>? onChanged;
  final String? label;
  final String? hint;
  final bool disabled;

  const GymTimePicker({
    super.key,
    this.value,
    this.onChanged,
    this.label,
    this.hint,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final displayText =
        value != null ? value!.format(context) : hint ?? 'Select time...';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(label!, style: AppTypography.labelMedium),
          Spacing.vXs,
        ],
        GestureDetector(
          onTap: !disabled ? () => _showTimePicker(context) : null,
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
                Icon(
                  LucideIcons.clock,
                  size: 18,
                  color: disabled
                      ? AppColors.textDisabled
                      : AppColors.textSecondary,
                ),
                Spacing.hSm,
                Expanded(
                  child: Text(
                    displayText,
                    style: AppTypography.bodyMedium.copyWith(
                      color: value != null
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

  Future<void> _showTimePicker(BuildContext context) async {
    if (!kIsWeb) HapticFeedback.lightImpact();

    final result = await showTimePicker(
      context: context,
      initialTime: value ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.brandPrimary,
              onPrimary: AppColors.onPrimary,
              surface: AppColors.bgCard,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (result != null) {
      onChanged?.call(result);
    }
  }
}

// GYM SLIDER
class GymSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final String? label;
  final double min;
  final double max;
  final int? divisions;
  final bool showValue;
  final String Function(double)? valueFormatter;
  final Color? activeColor;

  const GymSlider({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.min = 0,
    this.max = 100,
    this.divisions,
    this.showValue = true,
    this.valueFormatter,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = activeColor ?? AppColors.brandPrimary;
    final formattedValue =
        valueFormatter?.call(value) ?? value.toStringAsFixed(0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || showValue)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null) Text(label!, style: AppTypography.labelMedium),
              if (showValue)
                Text(
                  formattedValue,
                  style: AppTypography.bodyMedium.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        if (label != null || showValue) Spacing.vSm,
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            inactiveTrackColor: AppColors.bgCardHover,
            thumbColor: color,
            overlayColor: color.withValues(alpha: 0.2),
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

// GYM RANGE SLIDER
class GymRangeSlider extends StatelessWidget {
  final RangeValues values;
  final ValueChanged<RangeValues>? onChanged;
  final String? label;
  final double min;
  final double max;
  final int? divisions;
  final bool showValues;
  final String Function(double)? valueFormatter;
  final Color? activeColor;

  const GymRangeSlider({
    super.key,
    required this.values,
    this.onChanged,
    this.label,
    this.min = 0,
    this.max = 100,
    this.divisions,
    this.showValues = true,
    this.valueFormatter,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = activeColor ?? AppColors.brandPrimary;
    final startFormatted =
        valueFormatter?.call(values.start) ?? values.start.toStringAsFixed(0);
    final endFormatted =
        valueFormatter?.call(values.end) ?? values.end.toStringAsFixed(0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || showValues)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (label != null) Text(label!, style: AppTypography.labelMedium),
              if (showValues)
                Text(
                  '$startFormatted - $endFormatted',
                  style: AppTypography.bodyMedium.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        if (label != null || showValues) Spacing.vSm,
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            inactiveTrackColor: AppColors.bgCardHover,
            thumbColor: color,
            overlayColor: color.withValues(alpha: 0.2),
            trackHeight: 6,
            rangeThumbShape:
                const RoundRangeSliderThumbShape(enabledThumbRadius: 10),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
          ),
          child: RangeSlider(
            values: RangeValues(
              values.start.clamp(min, max),
              values.end.clamp(min, max),
            ),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
