/// Shared Widgets - Barrel file for backward compatibility
///
/// This file now re-exports all widgets from the modular widgets folder.
/// Individual widget files are located in lib/core/widgets/
///
/// Structure:
/// - gym_card.dart        → GymCard, ShimmerEffect
/// - neon_button.dart     → NeonButton, ButtonSize
/// - gym_badge.dart       → GymBadge, BadgeVariant, PulsingBadge
/// - gym_form_widgets.dart    → GymInput, GymSwitch
/// - gym_display_widgets.dart → GymTypography, GymDivider, GymAvatar,
///                              GymProgressBar, GymListTile, GymEmptyState
/// - global_error_boundary.dart → GlobalErrorBoundary

export 'widgets/widgets.dart';
