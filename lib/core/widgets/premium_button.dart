import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../settings_provider.dart';

enum PremiumButtonStyle { filled, tinted, bordered, glass }

enum PremiumButtonSize { compact, regular, large, hero }

class PremiumButton extends StatefulWidget {
  final String? title;
  final IconData? icon;
  final VoidCallback? onPress;
  final PremiumButtonStyle style;
  final PremiumButtonSize size;
  final Color? accentColor;
  final bool enablePulse;
  final bool enableShimmer;
  final bool isLoading;
  final bool isDisabled;
  final bool isIconOnly;
  final double? borderRadius;
  final double? width;
  final double? height;

  const PremiumButton({
    super.key,
    this.title,
    this.icon,
    this.onPress,
    this.style = PremiumButtonStyle.filled,
    this.size = PremiumButtonSize.regular,
    this.accentColor,
    this.enablePulse = false,
    this.enableShimmer = false,
    this.isLoading = false,
    this.isDisabled = false,
    this.isIconOnly = false,
    this.borderRadius,
    this.width,
    this.height,
  });

  const PremiumButton.icon({
    super.key,
    required IconData this.icon,
    this.onPress,
    this.style = PremiumButtonStyle.tinted,
    this.size = PremiumButtonSize.regular,
    this.accentColor,
    this.isLoading = false,
    this.isDisabled = false,
    this.borderRadius,
  })  : title = null,
        enablePulse = false,
        enableShimmer = false,
        isIconOnly = true,
        width = null,
        height = null;

  const PremiumButton.primary({
    super.key,
    this.title,
    this.icon,
    this.onPress,
    this.size = PremiumButtonSize.regular,
    this.enablePulse = false,
    this.enableShimmer = false,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height,
    this.borderRadius,
  })  : style = PremiumButtonStyle.filled,
        accentColor = null,
        isIconOnly = false;

  const PremiumButton.secondary({
    super.key,
    this.title,
    this.icon,
    this.onPress,
    this.size = PremiumButtonSize.regular,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height,
    this.borderRadius,
  })  : style = PremiumButtonStyle.bordered,
        accentColor = null,
        enablePulse = false,
        enableShimmer = false,
        isIconOnly = false;

  const PremiumButton.danger({
    super.key,
    this.title,
    this.icon,
    this.onPress,
    this.size = PremiumButtonSize.regular,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height,
    this.borderRadius,
  })  : style = PremiumButtonStyle.filled,
        accentColor = AppColors.error,
        enablePulse = false,
        enableShimmer = false,
        isIconOnly = false;

  const PremiumButton.ghost({
    super.key,
    this.title,
    this.icon,
    this.onPress,
    this.size = PremiumButtonSize.regular,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height,
    this.borderRadius,
  })  : style = PremiumButtonStyle.glass,
        accentColor = null,
        enablePulse = false,
        enableShimmer = false,
        isIconOnly = false;

  const PremiumButton.hero({
    super.key,
    this.title,
    this.icon,
    this.onPress,
    this.style = PremiumButtonStyle.filled,
    this.accentColor,
    this.enablePulse = true,
    this.enableShimmer = true,
    this.borderRadius,
  })  : size = PremiumButtonSize.hero,
        isLoading = false,
        isDisabled = false,
        isIconOnly = false,
        width = double.infinity,
        height = null;

  @override
  State<PremiumButton> createState() => _PremiumButtonState();
}

class _PremiumButtonState extends State<PremiumButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _shimmerAnimation;
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  double _getHeight() {
    if (widget.height != null) return widget.height!;
    switch (widget.size) {
      case PremiumButtonSize.compact:
        return 34;
      case PremiumButtonSize.regular:
        return 48;
      case PremiumButtonSize.large:
        return 56;
      case PremiumButtonSize.hero:
        return 64;
    }
  }

  double _getFontSize() {
    switch (widget.size) {
      case PremiumButtonSize.compact:
        return 12;
      case PremiumButtonSize.regular:
        return 14;
      case PremiumButtonSize.large:
        return 16;
      case PremiumButtonSize.hero:
        return 18;
    }
  }

  Color _getPrimaryColor() {
    return widget.accentColor ?? AppColors.brandPrimary;
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isEnabled =
        !widget.isDisabled && !widget.isLoading && widget.onPress != null;
    final primaryColor = _getPrimaryColor();

    final scale = _isPressed ? 0.96 : (_isHovered ? 1.02 : 1.0);
    final duration = settings.reducedMotion
        ? Duration.zero
        : const Duration(milliseconds: 150);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: isEnabled ? _handlePress : null,
        child: AnimatedScale(
          scale: scale,
          duration: duration,
          curve: Curves.easeOutCubic,
          child: Opacity(
            opacity: isEnabled ? 1.0 : 0.6,
            child: Container(
              width: widget.isIconOnly ? _getHeight() : widget.width,
              height: _getHeight(),
              child: Stack(
                children: [
                  // 3D Ledge Effect
                  if (widget.style == PremiumButtonStyle.filled &&
                      isEnabled &&
                      !widget.isIconOnly)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      top: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: 0.8),
                          borderRadius: widget.borderRadius != null
                              ? BorderRadius.circular(widget.borderRadius!)
                              : AppRadius.roundedMd,
                        ),
                      ),
                    ),

                  // Main Button Surface
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: EdgeInsets.only(
                      bottom: (widget.style == PremiumButtonStyle.filled &&
                              isEnabled &&
                              !_isPressed &&
                              !widget.isIconOnly)
                          ? 4
                          : 0,
                    ),
                    decoration: _getBoxDecoration(primaryColor, isEnabled),
                    child: ClipRRect(
                      borderRadius: widget.borderRadius != null
                          ? BorderRadius.circular(widget.borderRadius!)
                          : AppRadius.roundedMd,
                      child: Stack(
                        children: [
                          // Shimmer Effect
                          if (widget.enableShimmer && isEnabled)
                            AnimatedBuilder(
                              animation: _shimmerAnimation,
                              builder: (context, child) {
                                return Positioned.fill(
                                  child: FractionallySizedBox(
                                    widthFactor: 0.3,
                                    alignment:
                                        Alignment(_shimmerAnimation.value, 0.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.white.withValues(alpha: 0.0),
                                            Colors.white.withValues(alpha: 0.2),
                                            Colors.white.withValues(alpha: 0.0),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),

                          // Content
                          Center(
                            child: widget.isLoading
                                ? _buildLoader(primaryColor)
                                : _buildContent(primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Pulse Animation overlay for Hero
                  if (widget.enablePulse && isEnabled)
                    _PulseOverlay(
                      color: primaryColor,
                      borderRadius: widget.borderRadius,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handlePress() {
    if (!kIsWeb) HapticFeedback.mediumImpact();
    widget.onPress?.call();
  }

  BoxDecoration _getBoxDecoration(Color primaryColor, bool isEnabled) {
    final radius = widget.borderRadius != null
        ? BorderRadius.circular(widget.borderRadius!)
        : AppRadius.roundedMd;
    switch (widget.style) {
      case PremiumButtonStyle.filled:
        return BoxDecoration(
          color: primaryColor,
          borderRadius: radius,
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.3),
                    blurRadius: _isHovered ? 15 : 10,
                    offset: const Offset(0, 4),
                    spreadRadius: _isHovered ? 2 : 0,
                  ),
                ]
              : null,
        );
      case PremiumButtonStyle.tinted:
        return BoxDecoration(
          color: primaryColor.withValues(alpha: 0.1),
          borderRadius: radius,
          border: Border.all(
            color: primaryColor.withValues(alpha: 0.2),
            width: 1,
          ),
        );
      case PremiumButtonStyle.bordered:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: radius,
          border: Border.all(
            color: _isHovered ? primaryColor : AppColors.border,
            width: 1.5,
          ),
        );
      case PremiumButtonStyle.glass:
        return BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: radius,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              spreadRadius: -2,
            ),
          ],
        );
    }
  }

  Widget _buildLoader(Color primaryColor) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          widget.style == PremiumButtonStyle.filled
              ? Colors.white
              : primaryColor,
        ),
      ),
    );
  }

  Widget _buildContent(Color primaryColor) {
    final textColor = widget.style == PremiumButtonStyle.filled
        ? Colors.white
        : (widget.style == PremiumButtonStyle.glass
            ? Colors.white
            : primaryColor);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.icon != null) ...[
            AnimatedRotation(
              turns: _isHovered ? 0.05 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                widget.icon,
                size: widget.size == PremiumButtonSize.hero ? 24 : 18,
                color: textColor,
              ),
            ),
            if (widget.title != null) const SizedBox(width: 10),
          ],
          if (widget.title != null)
            Text(
              widget.title!,
              style: TextStyle(
                color: textColor,
                fontSize: _getFontSize(),
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
        ],
      ),
    );
  }
}

class _PulseOverlay extends StatefulWidget {
  final Color color;
  final double? borderRadius;
  const _PulseOverlay({required this.color, this.borderRadius});

  @override
  State<_PulseOverlay> createState() => _PulseOverlayState();
}

class _PulseOverlayState extends State<_PulseOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Opacity(
            opacity: (1.0 - _controller.value).clamp(0.0, 1.0),
            child: Transform.scale(
              scale: _animation.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: widget.borderRadius != null
                      ? BorderRadius.circular(widget.borderRadius!)
                      : AppRadius.roundedMd,
                  border: Border.all(
                    color: widget.color.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
