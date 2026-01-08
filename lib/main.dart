import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/app_theme.dart';
import 'core/settings_provider.dart';
import 'core/shared_widgets.dart';
import 'core/widgets/achievement_overlay.dart';
import 'core/widgets/premium_navigation.dart';
import 'core/workout_provider.dart';
import 'features/exercise_library_screen.dart';
import 'features/history_screen.dart';
import 'features/home_screen.dart';
import 'features/onboarding_screen.dart';
import 'features/profile_screen.dart';
import 'features/workout_logger_screen.dart';

import 'core/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const GlobalErrorBoundary(
        child: GymTrackerApp(),
      ),
    ),
  );
}

class GymTrackerApp extends StatelessWidget {
  const GymTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Tracker Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      builder: (context, child) {
        return Container(
          color: Colors.black, // Background color for the empty space
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: child,
            ),
          ),
        );
      },
      home: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          if (settings.isFirstRun) {
            return const OnboardingScreen();
          }
          return const MainScaffold();
        },
      ),
      onGenerateRoute: (settings) {
        // Deep linking support (Phase 2.14)
        if (settings.name == '/history') {
          return MaterialPageRoute(
              builder: (_) => const MainScaffold(initialIndex: 1));
        }
        if (settings.name == '/library') {
          return MaterialPageRoute(
              builder: (_) => const MainScaffold(initialIndex: 2));
        }
        if (settings.name == '/profile') {
          return MaterialPageRoute(
              builder: (_) => const MainScaffold(initialIndex: 3));
        }
        return MaterialPageRoute(builder: (_) => const MainScaffold());
      },
    );
  }
}

class MainScaffold extends StatefulWidget {
  final int initialIndex;
  const MainScaffold({super.key, this.initialIndex = 0});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
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

  void _startWorkout() {
    context.read<WorkoutProvider>().startWorkout();
  }

  @override
  Widget build(BuildContext context) {
    final workoutActive =
        context.select<WorkoutProvider, bool>((p) => p.isActive);

    if (workoutActive) {
      return const WorkoutLoggerScreen();
    }

    return Scaffold(
      backgroundColor: AppColors.bgMain,
      extendBody: true, // Allow content to extend behind nav bar
      body: Stack(
        children: [
          // Main content with fade transition
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: KeyedSubtree(
              key: ValueKey(_currentIndex),
              child: <Widget>[
                const HomeScreen(),
                const HistoryScreen(),
                const ExerciseLibraryScreen(),
                const ProfileScreen(),
              ][_currentIndex],
            ),
          ),
          // Achievement Overlay
          Consumer<WorkoutProvider>(
            builder: (context, provider, _) {
              if (provider.newlyUnlockedAchievements.isEmpty) {
                return const SizedBox.shrink();
              }
              return Container(
                color: Colors.black54,
                child: Center(
                  child: AchievementOverlay(
                    achievement: provider.newlyUnlockedAchievements.first,
                    onDismiss: () {
                      provider.clearNewlyUnlockedAchievements();
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      // Premium FAB centered
      floatingActionButton: PremiumFAB(
        onTap: _startWorkout,
        onLongPress: () {
          // Could show quick actions menu here
          if (!kIsWeb) HapticFeedback.heavyImpact();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // Glass Bottom Navigation
      bottomNavigationBar: GlassBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
        onFabTap: _startWorkout,
      ),
    );
  }
}
