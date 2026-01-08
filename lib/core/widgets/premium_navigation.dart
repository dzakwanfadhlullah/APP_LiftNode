import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../app_theme.dart';

// =============================================================================
// PHASE 5.1: PREMIUM NAVIGATION WIDGETS
// =============================================================================

// =============================================================================
// 1. GLASS BOTTOM NAV BAR - Floating glass navigation
// =============================================================================

class GlassBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onFabTap;
  final VoidCallback? onFabLongPress;

  const GlassBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onFabTap,
    this.onFabLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: ClipRRect(
        borderRadius: AppRadius.roundedXl,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.bgCard.withValues(alpha: 0.85),
              borderRadius: AppRadius.roundedXl,
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.5),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: _AnimatedNavItem(
                    icon: LucideIcons.house,
                    label: 'Home',
                    isActive: currentIndex == 0,
                    onTap: () => onTap(0),
                  ),
                ),
                Expanded(
                  child: _AnimatedNavItem(
                    icon: LucideIcons.clockArrowUp,
                    label: 'History',
                    isActive: currentIndex == 1,
                    onTap: () => onTap(1),
                  ),
                ),
                // FAB Placeholder
                const SizedBox(width: 72),
                Expanded(
                  child: _AnimatedNavItem(
                    icon: LucideIcons.dumbbell,
                    label: 'Library',
                    isActive: currentIndex == 2,
                    onTap: () => onTap(2),
                  ),
                ),
                Expanded(
                  child: _AnimatedNavItem(
                    icon: LucideIcons.user,
                    label: 'Profile',
                    isActive: currentIndex == 3,
                    onTap: () => onTap(3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// 2. ANIMATED NAV ITEM - Individual tab with glow and scale
// =============================================================================

class _AnimatedNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _AnimatedNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_AnimatedNavItem> createState() => _AnimatedNavItemState();
}

class _AnimatedNavItemState extends State<_AnimatedNavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    if (widget.isActive) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant _AnimatedNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!kIsWeb) HapticFeedback.selectionClick();
        widget.onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: widget.isActive
                          ? AppColors.brandPrimary.withValues(alpha: 0.15)
                          : Colors.transparent,
                      borderRadius: AppRadius.roundedMd,
                      boxShadow: widget.isActive
                          ? [
                              BoxShadow(
                                color: AppColors.brandPrimary.withValues(
                                    alpha: 0.3 * _glowAnimation.value),
                                blurRadius: 12,
                                spreadRadius: 0,
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      widget.icon,
                      size: 22,
                      color: widget.isActive
                          ? AppColors.brandPrimary
                          : AppColors.textMuted,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight:
                        widget.isActive ? FontWeight.w700 : FontWeight.w500,
                    color: widget.isActive
                        ? AppColors.brandPrimary
                        : AppColors.textMuted,
                  ),
                  child: Text(widget.label),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// =============================================================================
// 3. PREMIUM FAB - Floating action button with pulsing glow
// =============================================================================

class PremiumFAB extends StatefulWidget {
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const PremiumFAB({
    super.key,
    required this.onTap,
    this.onLongPress,
  });

  @override
  State<PremiumFAB> createState() => _PremiumFABState();
}

class _PremiumFABState extends State<PremiumFAB> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _pressController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Pulsing glow animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.4, end: 0.8).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Press animation
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _pressController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _pressController.reverse();
  }

  void _onTapCancel() {
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: () {
        if (!kIsWeb) HapticFeedback.mediumImpact();
        widget.onTap();
      },
      onLongPress: widget.onLongPress != null
          ? () {
              if (!kIsWeb) HapticFeedback.heavyImpact();
              widget.onLongPress!();
            }
          : null,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseController, _pressController]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.brandPrimary,
                    Color(0xFF81ECAD),
                  ],
                ),
                boxShadow: [
                  // Outer glow (pulsing)
                  BoxShadow(
                    color: AppColors.brandPrimary
                        .withValues(alpha: _pulseAnimation.value),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                  // Inner shadow
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  LucideIcons.plus,
                  color: Colors.black,
                  size: 28,
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
// 4. PREMIUM NAV SCAFFOLD - Complete navigation shell
// =============================================================================

class PremiumNavScaffold extends StatefulWidget {
  final List<Widget> screens;
  final int initialIndex;
  final VoidCallback onFabTap;

  const PremiumNavScaffold({
    super.key,
    required this.screens,
    this.initialIndex = 0,
    required this.onFabTap,
  });

  @override
  State<PremiumNavScaffold> createState() => _PremiumNavScaffoldState();
}

class _PremiumNavScaffoldState extends State<PremiumNavScaffold> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabChanged(int index) {
    if (!kIsWeb) HapticFeedback.selectionClick();
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: KeyedSubtree(
          key: ValueKey(_currentIndex),
          child: widget.screens[_currentIndex],
        ),
      ),
      floatingActionButton: PremiumFAB(onTap: widget.onFabTap),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: GlassBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
        onFabTap: widget.onFabTap,
      ),
    );
  }
}
