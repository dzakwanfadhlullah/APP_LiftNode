import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../app_theme.dart';

// =============================================================================
// 1. PREMIUM PROGRESS INDICATOR
// =============================================================================

class PremiumProgressIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const PremiumProgressIndicator({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Spacing.paddingScreen,
      child: Row(
        children: List.generate(totalSteps, (index) {
          final isActive = index <= currentStep;
          final isCurrent = index == currentStep;

          return Expanded(
            child: AnimatedContainer(
              duration: AppAnimations.normal,
              curve: Curves.easeOutCubic,
              height: isCurrent ? 6 : 4,
              margin: EdgeInsets.only(right: index == totalSteps - 1 ? 0 : 8),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.brandPrimary
                    : AppColors.border.withValues(alpha: 0.3),
                borderRadius: AppRadius.roundedFull,
                boxShadow: isCurrent
                    ? [
                        BoxShadow(
                          color: AppColors.brandPrimary.withValues(alpha: 0.4),
                          blurRadius: 8,
                          spreadRadius: 2,
                        )
                      ]
                    : [],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// =============================================================================
// 2. SELECTABLE NUMBER BADGE (FOR GOAL SELECTION)
// =============================================================================

class SelectableNumberBadge extends StatefulWidget {
  final int number;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableNumberBadge({
    super.key,
    required this.number,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<SelectableNumberBadge> createState() => _SelectableNumberBadgeState();
}

class _SelectableNumberBadgeState extends State<SelectableNumberBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _liftAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _liftAnimation = Tween<double>(begin: 0.0, end: -8.0).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));

    if (widget.isSelected) _animController.forward();
  }

  @override
  void didUpdateWidget(SelectableNumberBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _animController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _liftAnimation.value),
            child: Transform.scale(
              scale: widget.isSelected ? 1.05 : 1.0,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: widget.isSelected
                      ? AppColors.brandPrimary
                      : AppColors.bgCard,
                  borderRadius: AppRadius.roundedMd,
                  border: Border.all(
                    color: widget.isSelected
                        ? AppColors.brandPrimary
                        : AppColors.border,
                    width: 2,
                  ),
                  boxShadow: widget.isSelected
                      ? [
                          BoxShadow(
                            color:
                                AppColors.brandPrimary.withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 10),
                          )
                        ]
                      : [],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      widget.number.toString(),
                      style: AppTypography.displaySmall.copyWith(
                        color: widget.isSelected
                            ? Colors.black
                            : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.isSelected)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(LucideIcons.check,
                              size: 10, color: AppColors.brandPrimary),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// =============================================================================
// 3. ANIMATED SEGMENTED CONTROL (UNIT SELECTOR)
// =============================================================================

class AnimatedSegmentedControl extends StatelessWidget {
  final String selectedValue;
  final List<String> values;
  final List<String> labels;
  final Function(String) onChanged;

  const AnimatedSegmentedControl({
    super.key,
    required this.selectedValue,
    required this.values,
    required this.labels,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = values.indexOf(selectedValue);

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.roundedLg,
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        children: [
          // Sliding Indicator
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.elasticOut,
            alignment: Alignment(
              (selectedIndex / (values.length - 1)) * 2 - 1,
              0,
            ),
            child: FractionallySizedBox(
              widthFactor: 1 / values.length,
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.brandPrimary,
                  borderRadius: AppRadius.roundedMd,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.brandPrimary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
              ),
            ),
          ),

          // Labels
          Row(
            children: List.generate(values.length, (index) {
              final isSelected = index == selectedIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onChanged(values[index]);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: AppTypography.labelLarge.copyWith(
                        color:
                            isSelected ? Colors.black : AppColors.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      child: Text(labels[index]),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
