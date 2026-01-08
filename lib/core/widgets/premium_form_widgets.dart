import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../app_theme.dart';
import '../animations/animations.dart';

// =============================================================================
// PHASE 4.2: PREMIUM FORM WIDGETS
// =============================================================================

// =============================================================================
// 1. GLASS TEXT FIELD - Premium text input with floating label
// =============================================================================

class GlassTextField extends StatefulWidget {
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
  final VoidCallback? onEditingComplete;
  final bool enabled;
  final int maxLines;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign textAlign;
  final bool autofocus;

  const GlassTextField({
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
    this.onEditingComplete,
    this.enabled = true,
    this.maxLines = 1,
    this.focusNode,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
  });

  @override
  State<GlassTextField> createState() => _GlassTextFieldState();
}

class _GlassTextFieldState extends State<GlassTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _shouldWiggle = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant GlassTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger wiggle on new error
    if (widget.errorText != null && oldWidget.errorText == null) {
      setState(() => _shouldWiggle = true);
    }
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;
    final borderColor = hasError
        ? AppColors.error
        : _isFocused
            ? AppColors.brandPrimary
            : AppColors.border;

    return WiggleOnError(
      shouldWiggle: _shouldWiggle,
      onWiggleComplete: () => setState(() => _shouldWiggle = false),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null) ...[
            AnimatedDefaultTextStyle(
              duration: AppAnimations.fast,
              style: AppTypography.labelMedium.copyWith(
                color: hasError
                    ? AppColors.error
                    : _isFocused
                        ? AppColors.brandPrimary
                        : AppColors.textSecondary,
              ),
              child: Text(widget.label!),
            ),
            Spacing.vXs,
          ],
          AnimatedContainer(
            duration: AppAnimations.fast,
            decoration: BoxDecoration(
              borderRadius: AppRadius.roundedMd,
              boxShadow: _isFocused && !hasError
                  ? [
                      BoxShadow(
                        color: AppColors.brandPrimary.withValues(alpha: 0.2),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ]
                  : hasError
                      ? [
                          BoxShadow(
                            color: AppColors.error.withValues(alpha: 0.2),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ]
                      : [],
            ),
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              keyboardType: widget.keyboardType,
              obscureText: widget.obscureText,
              onChanged: widget.onChanged,
              onEditingComplete: widget.onEditingComplete,
              enabled: widget.enabled,
              maxLines: widget.maxLines,
              inputFormatters: widget.inputFormatters,
              textAlign: widget.textAlign,
              autofocus: widget.autofocus,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textMuted,
                ),
                errorText: null, // We handle error display separately
                prefixIcon: widget.prefixIcon != null
                    ? Icon(
                        widget.prefixIcon,
                        size: 20,
                        color: _isFocused
                            ? AppColors.brandPrimary
                            : AppColors.textSecondary,
                      )
                    : null,
                suffixIcon: widget.suffixIcon != null
                    ? GestureDetector(
                        onTap: widget.onSuffixTap,
                        child: Icon(
                          widget.suffixIcon,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                      )
                    : null,
                filled: true,
                fillColor: AppColors.bgInput,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md,
                  vertical: Spacing.inputPadding,
                ),
                border: OutlineInputBorder(
                  borderRadius: AppRadius.roundedMd,
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppRadius.roundedMd,
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppRadius.roundedMd,
                  borderSide: BorderSide(color: borderColor, width: 2),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: AppRadius.roundedMd,
                  borderSide: BorderSide(
                      color: AppColors.border.withValues(alpha: 0.5)),
                ),
              ),
            ),
          ),
          if (widget.errorText != null) ...[
            Spacing.vXxs,
            FadeSlideIn(
              direction: SlideDirection.down,
              offset: 8,
              duration: const Duration(milliseconds: 200),
              child: Row(
                children: [
                  Icon(LucideIcons.circleAlert,
                      size: 14, color: AppColors.error),
                  Spacing.hXxs,
                  Text(
                    widget.errorText!,
                    style:
                        AppTypography.caption.copyWith(color: AppColors.error),
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

// =============================================================================
// 2. PREMIUM NUMBER INPUT - Stepper with haptic feedback
// =============================================================================

class PremiumNumberInput extends StatefulWidget {
  final int value;
  final int min;
  final int max;
  final int step;
  final ValueChanged<int> onChanged;
  final String? label;
  final String? unit;
  final double width;

  const PremiumNumberInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 999,
    this.step = 1,
    this.label,
    this.unit,
    this.width = 140,
  });

  @override
  State<PremiumNumberInput> createState() => _PremiumNumberInputState();
}

class _PremiumNumberInputState extends State<PremiumNumberInput>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  int _displayValue = 0;

  @override
  void initState() {
    super.initState();
    _displayValue = widget.value;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(covariant PremiumNumberInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _animateValueChange();
    }
  }

  void _animateValueChange() {
    setState(() => _displayValue = widget.value);
    _animController.forward().then((_) => _animController.reverse());
  }

  void _increment() {
    if (widget.value < widget.max) {
      if (!kIsWeb) HapticFeedback.selectionClick();
      widget.onChanged(widget.value + widget.step);
    }
  }

  void _decrement() {
    if (widget.value > widget.min) {
      if (!kIsWeb) HapticFeedback.selectionClick();
      widget.onChanged(widget.value - widget.step);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Spacing.vXs,
        ],
        Container(
          width: widget.width,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: AppRadius.roundedLg,
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              // Decrement button
              _buildStepperButton(
                icon: LucideIcons.minus,
                onTap: _decrement,
                enabled: widget.value > widget.min,
              ),
              // Value display
              Expanded(
                child: Center(
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$_displayValue',
                          style: AppTypography.headlineMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.unit != null) ...[
                          Spacing.hXxs,
                          Text(
                            widget.unit!,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              // Increment button
              _buildStepperButton(
                icon: LucideIcons.plus,
                onTap: _increment,
                enabled: widget.value < widget.max,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepperButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      onLongPressStart:
          enabled ? (_) => _startLongPress(icon == LucideIcons.plus) : null,
      onLongPressEnd: (_) => _stopLongPress(),
      child: Container(
        width: 44,
        height: double.infinity,
        decoration: BoxDecoration(
          color: enabled
              ? AppColors.brandPrimary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: icon == LucideIcons.minus
              ? const BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.lg - 1),
                  bottomLeft: Radius.circular(AppRadius.lg - 1),
                )
              : const BorderRadius.only(
                  topRight: Radius.circular(AppRadius.lg - 1),
                  bottomRight: Radius.circular(AppRadius.lg - 1),
                ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? AppColors.brandPrimary : AppColors.textMuted,
        ),
      ),
    );
  }

  bool _isLongPressing = false;

  void _startLongPress(bool isIncrement) {
    _isLongPressing = true;
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!_isLongPressing) return false;
      if (isIncrement) {
        _increment();
      } else {
        _decrement();
      }
      return _isLongPressing;
    });
  }

  void _stopLongPress() {
    _isLongPressing = false;
  }
}

// =============================================================================
// 3. GLASS SEARCH BAR - Premium search input
// =============================================================================

class GlassSearchBar extends StatefulWidget {
  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final bool showLoading;
  final bool autofocus;

  const GlassSearchBar({
    super.key,
    this.hint = 'Search...',
    this.controller,
    this.onChanged,
    this.onClear,
    this.showLoading = false,
    this.autofocus = false,
  });

  @override
  State<GlassSearchBar> createState() => _GlassSearchBarState();
}

class _GlassSearchBarState extends State<GlassSearchBar> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChange);
    _hasText = _controller.text.isNotEmpty;
  }

  void _onTextChange() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _clear() {
    _controller.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.roundedLg,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 14),
            child: widget.showLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.brandPrimary,
                    ),
                  )
                : const Icon(
                    LucideIcons.search,
                    size: 20,
                    color: AppColors.textMuted,
                  ),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              autofocus: widget.autofocus,
              style: AppTypography.bodyMedium,
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textMuted,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            ),
          ),
          AnimatedOpacity(
            opacity: _hasText ? 1.0 : 0.0,
            duration: AppAnimations.fast,
            child: GestureDetector(
              onTap: _hasText ? _clear : null,
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(right: 6),
                child: const Icon(
                  LucideIcons.x,
                  size: 18,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// 4. GLASS SWITCH - Premium toggle with gradient
// =============================================================================

class GlassSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final String? subtitle;
  final IconData? icon;

  const GlassSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged != null
          ? () {
              if (!kIsWeb) HapticFeedback.selectionClick();
              onChanged!(!value);
            }
          : null,
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: value
                    ? AppColors.brandPrimary.withValues(alpha: 0.1)
                    : AppColors.bgCardHover,
                borderRadius: AppRadius.roundedMd,
              ),
              child: Icon(
                icon,
                size: 18,
                color: value ? AppColors.brandPrimary : AppColors.textMuted,
              ),
            ),
            Spacing.hMd,
          ],
          if (label != null)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label!, style: AppTypography.titleSmall),
                  if (subtitle != null) ...[
                    Spacing.vXxs,
                    Text(
                      subtitle!,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          // Toggle
          AnimatedContainer(
            duration: AppAnimations.fast,
            curve: Curves.easeOutCubic,
            width: 52,
            height: 32,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              gradient: value
                  ? const LinearGradient(
                      colors: [AppColors.brandPrimary, Color(0xFF81ECAD)],
                    )
                  : null,
              color: value ? null : AppColors.bgCardHover,
              borderRadius: BorderRadius.circular(16),
              boxShadow: value
                  ? [
                      BoxShadow(
                        color: AppColors.brandPrimary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: AnimatedAlign(
              duration: AppAnimations.fast,
              curve: Curves.easeOutBack,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// 5. PREMIUM DECIMAL INPUT - For weight input (kg)
// =============================================================================

class PremiumDecimalInput extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final double step;
  final ValueChanged<double> onChanged;
  final String? label;
  final String? unit;
  final double width;

  const PremiumDecimalInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 999,
    this.step = 0.5,
    this.label,
    this.unit = 'kg',
    this.width = 160,
  });

  @override
  State<PremiumDecimalInput> createState() => _PremiumDecimalInputState();
}

class _PremiumDecimalInputState extends State<PremiumDecimalInput> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _formatValue(widget.value));
  }

  @override
  void didUpdateWidget(covariant PremiumDecimalInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && !_isEditing) {
      _controller.text = _formatValue(widget.value);
    }
  }

  String _formatValue(double value) {
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
  }

  void _increment() {
    final newValue = (widget.value + widget.step).clamp(widget.min, widget.max);
    if (!kIsWeb) HapticFeedback.selectionClick();
    widget.onChanged(newValue);
    _controller.text = _formatValue(newValue);
  }

  void _decrement() {
    final newValue = (widget.value - widget.step).clamp(widget.min, widget.max);
    if (!kIsWeb) HapticFeedback.selectionClick();
    widget.onChanged(newValue);
    _controller.text = _formatValue(newValue);
  }

  void _onSubmitted(String text) {
    _isEditing = false;
    final parsed = double.tryParse(text);
    if (parsed != null) {
      final clamped = parsed.clamp(widget.min, widget.max);
      widget.onChanged(clamped);
      _controller.text = _formatValue(clamped);
    } else {
      _controller.text = _formatValue(widget.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Spacing.vXs,
        ],
        Container(
          width: widget.width,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: AppRadius.roundedLg,
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              _buildButton(LucideIcons.minus, _decrement),
              Expanded(
                child: TextField(
                  controller: _controller,
                  textAlign: TextAlign.center,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  onTap: () => _isEditing = true,
                  onSubmitted: _onSubmitted,
                  onEditingComplete: () => _onSubmitted(_controller.text),
                  style: AppTypography.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixText: widget.unit,
                    suffixStyle: AppTypography.caption.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ),
              _buildButton(LucideIcons.plus, _increment),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: double.infinity,
        color: Colors.transparent,
        child: Icon(
          icon,
          size: 18,
          color: AppColors.brandPrimary,
        ),
      ),
    );
  }
}
