import 'package:flutter/material.dart';
import '../app_theme.dart';

// =============================================================================
// PHASE 5.2: ACCESSIBILITY & PERFORMANCE UTILITIES
// =============================================================================

// =============================================================================
// 1. REDUCED MOTION WRAPPER - Respects user's motion preferences
// =============================================================================

/// Wraps a child widget and provides reduced motion variants.
/// When the user has requested reduced motion, animations are disabled
/// or replaced with instant transitions.
class ReducedMotion extends StatelessWidget {
  final Widget child;
  final Widget? reducedChild;

  const ReducedMotion({
    super.key,
    required this.child,
    this.reducedChild,
  });

  /// Check if reduced motion is enabled
  static bool isEnabled(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return reduceMotion ? (reducedChild ?? child) : child;
  }
}

// =============================================================================
// 2. ACCESSIBLE TAP TARGET - Ensures minimum 48x48 touch target
// =============================================================================

/// Wraps a widget to ensure it meets the minimum touch target size (48x48).
/// This is an accessibility requirement for users with motor impairments.
class AccessibleTapTarget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final double minSize;

  const AccessibleTapTarget({
    super.key,
    required this.child,
    this.onTap,
    this.semanticLabel,
    this.minSize = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: onTap != null,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: minSize,
            minHeight: minSize,
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}

// =============================================================================
// 3. SEMANTIC WRAPPER - Adds screen reader labels
// =============================================================================

/// Provides semantic information for screen readers.
class SemanticWrapper extends StatelessWidget {
  final Widget child;
  final String label;
  final String? hint;
  final String? value;
  final bool isButton;
  final bool isHeader;
  final bool excludeSemantics;

  const SemanticWrapper({
    super.key,
    required this.child,
    required this.label,
    this.hint,
    this.value,
    this.isButton = false,
    this.isHeader = false,
    this.excludeSemantics = false,
  });

  @override
  Widget build(BuildContext context) {
    if (excludeSemantics) {
      return ExcludeSemantics(child: child);
    }

    return Semantics(
      label: label,
      hint: hint,
      value: value,
      button: isButton,
      header: isHeader,
      child: child,
    );
  }
}

// =============================================================================
// 4. FOCUS HIGHLIGHT - Keyboard navigation focus indicator
// =============================================================================

/// Adds a visible focus indicator for keyboard navigation.
class FocusHighlight extends StatefulWidget {
  final Widget child;
  final Color? focusColor;
  final double borderRadius;
  final double borderWidth;

  const FocusHighlight({
    super.key,
    required this.child,
    this.focusColor,
    this.borderRadius = AppRadius.md,
    this.borderWidth = 2.0,
  });

  @override
  State<FocusHighlight> createState() => _FocusHighlightState();
}

class _FocusHighlightState extends State<FocusHighlight> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.focusColor ?? AppColors.brandPrimary;

    return Focus(
      onFocusChange: (focused) => setState(() => _isFocused = focused),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: _isFocused
              ? Border.all(color: color, width: widget.borderWidth)
              : Border.all(
                  color: Colors.transparent, width: widget.borderWidth),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ]
              : null,
        ),
        child: widget.child,
      ),
    );
  }
}

// =============================================================================
// 5. REPAINT BOUNDARY WRAPPER - Performance optimization
// =============================================================================

/// Wraps heavy widgets in a RepaintBoundary for performance optimization.
/// Use this for widgets with complex animations or frequent repaints.
class OptimizedRepaint extends StatelessWidget {
  final Widget child;

  const OptimizedRepaint({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(child: child);
  }
}

// =============================================================================
// 6. ANIMATED DURATION HELPER - Respects reduced motion
// =============================================================================

/// Returns appropriate duration based on reduced motion preference.
Duration getAnimationDuration(
  BuildContext context, {
  Duration normal = const Duration(milliseconds: 300),
  Duration reduced = Duration.zero,
}) {
  if (MediaQuery.of(context).disableAnimations) {
    return reduced;
  }
  return normal;
}

/// Returns appropriate curve based on reduced motion preference.
Curve getAnimationCurve(
  BuildContext context, {
  Curve normal = Curves.easeOutCubic,
  Curve reduced = Curves.linear,
}) {
  if (MediaQuery.of(context).disableAnimations) {
    return reduced;
  }
  return normal;
}

// =============================================================================
// 7. ACCESSIBILITY CONSTANTS
// =============================================================================

/// Accessibility-related constants for the app.
class A11y {
  A11y._();

  /// Minimum touch target size per WCAG guidelines (48x48 logical pixels)
  static const double minTouchTarget = 48.0;

  /// Recommended touch target for better accessibility
  static const double recommendedTouchTarget = 56.0;

  /// Minimum contrast ratio for normal text (WCAG AA)
  static const double minContrastRatio = 4.5;

  /// Minimum contrast ratio for large text (WCAG AA)
  static const double minContrastRatioLarge = 3.0;

  /// Duration for focus ring animations
  static const Duration focusAnimationDuration = Duration(milliseconds: 150);
}
