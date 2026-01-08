import 'package:flutter/material.dart';

// =============================================================================
// 1. SHARED AXIS TRANSITION - For page navigation
// =============================================================================

class SharedAxisPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final SharedAxisTransitionType type;

  SharedAxisPageRoute({
    required this.page,
    this.type = SharedAxisTransitionType.horizontal,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              type: type,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 250),
        );
}

enum SharedAxisTransitionType { horizontal, vertical, scaled }

class SharedAxisTransition extends StatelessWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final SharedAxisTransitionType type;
  final Widget child;

  const SharedAxisTransition({
    super.key,
    required this.animation,
    required this.secondaryAnimation,
    required this.type,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    Widget transition;

    switch (type) {
      case SharedAxisTransitionType.horizontal:
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0.3, 0),
          end: Offset.zero,
        ).animate(curvedAnimation);

        transition = SlideTransition(
          position: slideAnimation,
          child: FadeTransition(opacity: fadeAnimation, child: child),
        );

      case SharedAxisTransitionType.vertical:
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(curvedAnimation);

        transition = SlideTransition(
          position: slideAnimation,
          child: FadeTransition(opacity: fadeAnimation, child: child),
        );

      case SharedAxisTransitionType.scaled:
        final scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
          curvedAnimation,
        );

        transition = ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(opacity: fadeAnimation, child: child),
        );
    }

    return transition;
  }
}

// =============================================================================
// 2. FADE THROUGH TRANSITION - For tab switches
// =============================================================================

class FadeThroughPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadeThroughPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
}

class FadeThroughTransition extends StatelessWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  const FadeThroughTransition({
    super.key,
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final fadeInAnimation = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );

    final scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    return FadeTransition(
      opacity: fadeInAnimation,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: child,
      ),
    );
  }
}

// =============================================================================
// 3. SLIDE UP PAGE ROUTE - For modal-style pages
// =============================================================================

class SlideUpPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SlideUpPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );

            final slideAnimation = Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curvedAnimation);

            final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
              ),
            );

            return SlideTransition(
              position: slideAnimation,
              child: FadeTransition(opacity: fadeAnimation, child: child),
            );
          },
          transitionDuration: const Duration(milliseconds: 350),
          reverseTransitionDuration: const Duration(milliseconds: 250),
        );
}

// =============================================================================
// 4. ANIMATED TAB SWITCHER - For smooth tab content switching
// =============================================================================

class AnimatedTabSwitcher extends StatelessWidget {
  final int index;
  final List<Widget> children;
  final Duration duration;
  final Curve curve;

  const AnimatedTabSwitcher({
    super.key,
    required this.index,
    required this.children,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: curve,
      switchOutCurve: curve,
      transitionBuilder: (child, animation) {
        final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
          ),
        );

        final scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: curve),
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(scale: scaleAnimation, child: child),
        );
      },
      child: KeyedSubtree(
        key: ValueKey(index),
        child: children[index],
      ),
    );
  }
}
