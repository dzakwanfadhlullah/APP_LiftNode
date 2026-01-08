import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import '../app_theme.dart';
import '../settings_provider.dart';

// =============================================================================
// PHASE 2.1 V1.4: GLASS CARD - Premium Glassmorphism Card Component
// Replacement for GymCard with frosted glass effect, glow borders, and depth
// =============================================================================

/// Variant options untuk GlassCard
enum GlassCardVariant {
  /// Full frosted glass dengan blur effect - paling premium
  frosted,

  /// Solid colored dengan gradient overlay - untuk cards dengan konten penting
  solid,

  /// Gradient background dengan glass border - untuk feature cards
  gradient,

  /// Border only, transparent background - untuk outlined/secondary cards
  outlined,
}

class GlassCard extends StatefulWidget {
  final Widget child;
  final GlassCardVariant variant;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? accentColor;
  final double? width;
  final double? height;
  final double blurAmount;
  final double borderRadius;
  final bool isLoading;
  final bool enableHover;
  final bool enablePressEffect;
  final bool enableBorderGlow;
  final Gradient? customGradient;

  const GlassCard({
    super.key,
    required this.child,
    this.variant = GlassCardVariant.frosted,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.accentColor,
    this.width,
    this.height,
    this.blurAmount = GlassBlur.medium,
    this.borderRadius = 20.0,
    this.isLoading = false,
    this.enableHover = true,
    this.enablePressEffect = true,
    this.enableBorderGlow = true,
    this.customGradient,
  });

  /// Preset: Frosted glass card (default premium look)
  const GlassCard.frosted({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.accentColor,
    this.width,
    this.height,
    this.isLoading = false,
  })  : variant = GlassCardVariant.frosted,
        blurAmount = GlassBlur.medium,
        borderRadius = 20.0,
        enableHover = true,
        enablePressEffect = true,
        enableBorderGlow = true,
        customGradient = null;

  /// Preset: Solid card dengan accent color
  const GlassCard.solid({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.accentColor,
    this.width,
    this.height,
    this.isLoading = false,
  })  : variant = GlassCardVariant.solid,
        blurAmount = 0,
        borderRadius = 20.0,
        enableHover = true,
        enablePressEffect = true,
        enableBorderGlow = false,
        customGradient = null;

  /// Preset: Gradient card untuk hero/feature sections
  const GlassCard.gradient({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.accentColor,
    this.width,
    this.height,
    this.customGradient,
    this.isLoading = false,
  })  : variant = GlassCardVariant.gradient,
        blurAmount = 0,
        borderRadius = 20.0,
        enableHover = true,
        enablePressEffect = true,
        enableBorderGlow = true;

  /// Preset: Outlined card (transparent with border)
  const GlassCard.outlined({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.accentColor,
    this.width,
    this.height,
    this.isLoading = false,
  })  : variant = GlassCardVariant.outlined,
        blurAmount = 0,
        borderRadius = 20.0,
        enableHover = true,
        enablePressEffect = true,
        enableBorderGlow = true,
        customGradient = null;

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  bool _isHovered = false;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  void _handleHoverEnter() {
    if (!widget.enableHover) return;
    setState(() => _isHovered = true);
    if (widget.enableBorderGlow) {
      _glowController.forward();
    }
  }

  void _handleHoverExit() {
    if (!widget.enableHover) return;
    setState(() => _isHovered = false);
    if (widget.enableBorderGlow) {
      _glowController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final reducedMotion = settings.reducedMotion;
    final fastDuration = reducedMotion ? Duration.zero : AppAnimations.fast;

    // Calculate scale based on press/hover state
    double scale = 1.0;
    if (widget.enablePressEffect) {
      scale = _isPressed ? 0.97 : (_isHovered ? 1.02 : 1.0);
    }

    final effectiveAccentColor = widget.accentColor ?? AppColors.brandPrimary;

    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress != null
          ? () {
              if (!kIsWeb) HapticFeedback.mediumImpact();
              widget.onLongPress!();
            }
          : null,
      onTapDown: widget.enablePressEffect
          ? (_) => setState(() => _isPressed = true)
          : null,
      onTapUp: widget.enablePressEffect
          ? (_) => setState(() => _isPressed = false)
          : null,
      onTapCancel: widget.enablePressEffect
          ? () => setState(() => _isPressed = false)
          : null,
      child: MouseRegion(
        onEnter: (_) => _handleHoverEnter(),
        onExit: (_) => _handleHoverExit(),
        child: AnimatedScale(
          scale: scale,
          duration: fastDuration,
          curve: AppAnimations.snappy,
          child: AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                width: widget.width,
                height: widget.height,
                margin: widget.margin,
                decoration: _buildOuterDecoration(effectiveAccentColor),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: _buildCardContent(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildOuterDecoration(Color accentColor) {
    List<BoxShadow> shadows = [];

    // Base shadow
    if (_isHovered) {
      shadows = AppShadows.elevated(level: 2);
    } else {
      shadows = AppShadows.elevated(level: 1);
    }

    // Add glow effect on hover if enabled
    if (widget.enableBorderGlow && _glowAnimation.value > 0) {
      shadows = [
        ...shadows,
        ...AppShadows.ambient(
          accentColor,
          intensity: 0.3 * _glowAnimation.value,
          blur: 20,
        ),
      ];
    }

    return BoxDecoration(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      boxShadow: shadows,
    );
  }

  Widget _buildCardContent() {
    switch (widget.variant) {
      case GlassCardVariant.frosted:
        return _buildFrostedCard();
      case GlassCardVariant.solid:
        return _buildSolidCard();
      case GlassCardVariant.gradient:
        return _buildGradientCard();
      case GlassCardVariant.outlined:
        return _buildOutlinedCard();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // FROSTED GLASS VARIANT
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildFrostedCard() {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: widget.blurAmount,
        sigmaY: widget.blurAmount,
      ),
      child: Container(
        padding: widget.padding ?? Spacing.paddingCard,
        decoration: BoxDecoration(
          color: _isHovered ? AppColors.glassBgMedium : AppColors.glassBgLight,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: _buildGlassBorder(),
        ),
        child: widget.isLoading ? _buildShimmerContent() : widget.child,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SOLID VARIANT
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildSolidCard() {
    final bgColor = widget.accentColor ?? AppColors.bgCard;
    return Container(
      padding: widget.padding ?? Spacing.paddingCard,
      decoration: BoxDecoration(
        color: _isHovered ? Color.lerp(bgColor, Colors.white, 0.05) : bgColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: _isHovered ? AppColors.borderFocused : AppColors.border,
          width: 1,
        ),
      ),
      child: widget.isLoading ? _buildShimmerContent() : widget.child,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // GRADIENT VARIANT
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildGradientCard() {
    final gradient = widget.customGradient ??
        LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            widget.accentColor ?? AppColors.brandPrimary,
            Color.lerp(
              widget.accentColor ?? AppColors.brandPrimary,
              Colors.black,
              0.3,
            )!,
          ],
        );

    return Container(
      padding: widget.padding ?? Spacing.paddingCard,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: _buildGlassBorder(),
      ),
      child: widget.isLoading ? _buildShimmerContent() : widget.child,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // OUTLINED VARIANT
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildOutlinedCard() {
    final borderColor = widget.accentColor ?? AppColors.border;
    return Container(
      padding: widget.padding ?? Spacing.paddingCard,
      decoration: BoxDecoration(
        color: _isHovered ? AppColors.glassBgDark : Colors.transparent,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          color: _isHovered
              ? (widget.accentColor ?? AppColors.borderFocused)
              : borderColor,
          width: _isHovered ? 2 : 1.5,
        ),
      ),
      child: widget.isLoading ? _buildShimmerContent() : widget.child,
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────────────────────────────────

  /// Creates premium glass border with light source effect
  Border _buildGlassBorder() {
    if (_isHovered && widget.enableBorderGlow) {
      final glowColor = widget.accentColor ?? AppColors.brandPrimary;
      return Border.all(
        color: glowColor.withValues(alpha: 0.5),
        width: 1.5,
      );
    }
    return const Border(
      top: BorderSide(color: AppColors.glassBorderLight, width: 1),
      left: BorderSide(color: AppColors.glassBorderSubtle, width: 1),
      right: BorderSide(color: AppColors.glassBorderDark, width: 1),
      bottom: BorderSide(color: AppColors.glassBorderDark, width: 1),
    );
  }

  /// Shimmer loading content
  Widget _buildShimmerContent() {
    return GlassCardShimmer(
      borderRadius: widget.borderRadius - 4,
    );
  }
}

// =============================================================================
// GLASS CARD SHIMMER - Premium loading animation
// =============================================================================

class GlassCardShimmer extends StatefulWidget {
  final double borderRadius;
  final double height;

  const GlassCardShimmer({
    super.key,
    this.borderRadius = 16,
    this.height = 60,
  });

  @override
  State<GlassCardShimmer> createState() => _GlassCardShimmerState();
}

class _GlassCardShimmerState extends State<GlassCardShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                AppColors.bgCard,
                AppColors.bgCardHover,
                AppColors.bgCard,
              ],
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}

// =============================================================================
// GLASS CARD THEME - Consistent styling presets
// =============================================================================

class GlassCardTheme {
  GlassCardTheme._();

  /// Default padding for glass cards
  static const EdgeInsets defaultPadding = Spacing.paddingCard;

  /// Default border radius
  static const double defaultBorderRadius = 20.0;

  /// Default blur amount for frosted variant
  static const double defaultBlurAmount = GlassBlur.medium;

  /// Preset: Primary accent (green glow)
  static const Color primaryAccent = AppColors.brandPrimary;

  /// Preset: Secondary accent (cyan glow)
  static const Color secondaryAccent = AppColors.brandSecondary;

  /// Preset: Tertiary accent (purple glow)
  static const Color tertiaryAccent = AppColors.brandTertiary;

  /// Preset: Warning accent (orange glow)
  static const Color warningAccent = AppColors.warning;

  /// Preset: Error accent (red glow)
  static const Color errorAccent = AppColors.error;

  /// Hero card gradient (untuk Start Workout card)
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.brandPrimary, Color(0xFF8BD56B)],
  );

  /// Stats card gradient
  static const LinearGradient statsGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A2F23), Color(0xFF0D1A12)],
  );
}
