import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import 'core/app_theme.dart';
import 'core/settings_provider.dart';
import 'core/shared_widgets.dart';
import 'core/widgets/achievement_overlay.dart';
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

  @override
  Widget build(BuildContext context) {
    final workoutActive =
        context.select<WorkoutProvider, bool>((p) => p.isActive);

    return Scaffold(
      backgroundColor: AppColors.bgMain,
      body: workoutActive
          ? const WorkoutLoggerScreen()
          : Stack(
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
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
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildCustomTabBar(),
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
    );
  }

  Widget _buildCustomTabBar() {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: AppColors.bgCard,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTabItem(LucideIcons.house, 'Home', 0),
          _buildTabItem(LucideIcons.clockArrowUp, 'History', 1),
          _buildFab(),
          _buildTabItem(LucideIcons.dumbbell, 'Library', 2),
          _buildTabItem(LucideIcons.user, 'Profile', 3),
        ],
      ),
    );
  }

  Widget _buildTabItem(IconData icon, String label, int index) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        if (!kIsWeb) HapticFeedback.selectionClick();
        setState(() => _currentIndex = index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: isActive ? AppColors.brandPrimary : AppColors.textMuted,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isActive ? AppColors.brandPrimary : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFab() {
    return GestureDetector(
      onTap: () {
        // Start a new workout when FAB is tapped
        context.read<WorkoutProvider>().startWorkout();
      },
      child: Container(
        width: 56,
        height: 56,
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: AppColors.brandPrimary,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.bgMain, width: 4),
          boxShadow: [
            BoxShadow(
              color: AppColors.brandPrimary.withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(LucideIcons.plus, color: Colors.black, size: 24),
      ),
    );
  }
}
