import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../settings_provider.dart';

// =============================================================================
// NEON BUTTON - Enhanced with size variants and icon-only mode
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
    final settings = context.watch<SettingsProvider>();
    final baseHeight = widget.height ?? _getBaseHeight();
    return settings.largeTouchTargets ? baseHeight * 1.2 : baseHeight;
  }

  double _getBaseHeight() {
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
    final settings = context.watch<SettingsProvider>();
    final config = _getVariantConfig();
    final isEnabled =
        !widget.isDisabled && !widget.isLoading && widget.onPress != null;
    final scale = _isPressed ? 0.95 : 1.0;
    final duration =
        settings.reducedMotion ? Duration.zero : AppAnimations.buttonPress;

    if (widget.isIconOnly) {
      return _buildIconButton(config, isEnabled, scale, duration);
    }

    return AnimatedScale(
      scale: scale,
      duration: duration,
      curve: AppAnimations.snappy,
      child: SizedBox(
        width: widget.width,
        height: _height,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppRadius.roundedMd,
            boxShadow: isEnabled ? config.shadows : null,
          ),
          child: AnimatedOpacity(
            duration:
                settings.reducedMotion ? Duration.zero : AppAnimations.fast,
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
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.roundedMd,
                  side: config.borderSide,
                ),
              ),
              child: Listener(
                onPointerDown: (_) => setState(() => _isPressed = true),
                onPointerUp: (_) => setState(() => _isPressed = false),
                onPointerCancel: (_) => setState(() => _isPressed = false),
                child: widget.isLoading
                    ? _buildLoader(config)
                    : _buildContent(config),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(
      _ButtonConfig config, bool isEnabled, double scale, Duration duration) {
    final settings = context.watch<SettingsProvider>();
    return AnimatedScale(
      scale: scale,
      duration: duration,
      curve: AppAnimations.snappy,
      child: AnimatedOpacity(
        duration: settings.reducedMotion ? Duration.zero : AppAnimations.fast,
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
          shadows: [
            BoxShadow(
              color: AppColors.error.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
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
          shadows: [
            BoxShadow(
              color: AppColors.brandPrimary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        );
    }
  }
}

class _ButtonConfig {
  final Color backgroundColor;
  final Color foregroundColor;
  final BorderSide borderSide;
  final List<BoxShadow>? shadows;

  _ButtonConfig({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderSide,
    this.shadows,
  });
}
