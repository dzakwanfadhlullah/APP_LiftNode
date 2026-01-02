import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'core/workout_provider.dart';
import 'features/home_screen.dart';
import 'features/history_screen.dart';
import 'features/workout_logger_screen.dart';
import 'features/profile_screen.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => WorkoutProvider())],
      child: const GymTrackerApp(),
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
      home: const MainScaffold(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final workoutActive = context.watch<WorkoutProvider>().isActive;

    return Scaffold(
      backgroundColor: AppColors.bgMain,
      body: workoutActive
          ? const WorkoutLoggerScreen()
          : Stack(
              children: [
                IndexedStack(
                  index: _currentIndex,
                  children: const [
                    HomeScreen(),
                    HistoryScreen(),
                    ProfileScreen(),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildCustomTabBar(),
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
          _buildTabItem(LucideIcons.user, 'Profile', 2),
        ],
      ),
    );
  }

  Widget _buildTabItem(IconData icon, String label, int index) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
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
    return Container(
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
    );
  }
}
