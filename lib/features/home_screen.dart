import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/shared_widgets.dart';
import '../core/workout_provider.dart';
import '../core/settings_provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/models.dart';
import 'templates_screen.dart';
import '../core/widgets/premium_home_widgets.dart';

// =============================================================================
// PHASE 3: HOME SCREEN ENHANCEMENTS
// =============================================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // 3.3 Chart period toggle
  String _chartPeriod = 'week'; // 'week' or 'month'

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkoutProvider>().addListener(_errorListener);
    });
  }

  @override
  void dispose() {
    // Phase 2.11: Fix memory leak
    if (mounted) {
      context.read<WorkoutProvider>().removeListener(_errorListener);
    }
    super.dispose();
  }

  void _errorListener() {
    final provider = context.read<WorkoutProvider>();
    if (provider.errorMessage != null && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage!),
            backgroundColor: AppColors.error,
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: provider.clearError,
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              Spacing.vLg,
              _buildBentoGrid(context),
              Spacing.vXl,
              _buildRecentHistory(context),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // PHASE 3.1: HEADER PERSONALIZATION
  // ===========================================================================

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: Spacing.paddingScreen,
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Navigate to Profile tab below!')),
                      );
                    },
                    child: GradientAvatarRing(
                      size: 52,
                      child: GymAvatar(
                        name: settings.userName,
                        size: 48,
                        borderWidth: 0, // No border needed inside the ring
                        borderColor: Colors.transparent,
                      ),
                    ),
                  ),
                  Spacing.hMd,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.brandPrimary.withValues(alpha: 0.1),
                          borderRadius: AppRadius.roundedSm,
                        ),
                        child: Text(
                          _getDynamicGreeting().toUpperCase(),
                          style: AppTypography.overline.copyWith(
                            color: AppColors.brandPrimary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      Spacing.vXxs,
                      Text(
                        settings.userName,
                        style: AppTypography.headlineMedium,
                      ),
                    ],
                  ),
                ],
              ),
              Consumer<WorkoutProvider>(
                builder: (context, provider, child) {
                  return AnimatedFireBadge(
                    streak: provider.streak,
                    onTap: () => _showStreakDetails(context),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  // Dynamic greeting based on time of day
  String _getDynamicGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 5) return 'Night Owl 🦉';
    if (hour < 12) return 'Good Morning ☀️';
    if (hour < 17) return 'Good Afternoon 💪';
    if (hour < 21) return 'Good Evening 🌆';
    return 'Night Owl 🦉';
  }

  void _showStreakDetails(BuildContext context) {
    if (!kIsWeb) HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: Spacing.paddingCard,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer<WorkoutProvider>(
              builder: (context, provider, child) {
                final streak = provider.streak;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.border,
                        borderRadius: AppRadius.roundedFull,
                      ),
                    ),
                    Spacing.vLg,
                    const Icon(LucideIcons.flame,
                        size: 64, color: Color(0xFFF97316)),
                    Spacing.vMd,
                    Text('$streak Day Streak! 🔥',
                        style: AppTypography.displayMedium),
                    Spacing.vSm,
                    Text(
                      streak > 0
                          ? 'Keep it up! You\'re on fire.'
                          : 'Start your first workout today!',
                      style: AppTypography.bodyMedium
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    Spacing.vLg,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStreakStat(
                            'Current', '$streak', Icons.local_fire_department),
                        _buildStreakStat('Best', '$streak', Icons.emoji_events),
                        _buildStreakStat('Total', '${provider.history.length}',
                            Icons.fitness_center),
                      ],
                    ),
                    Spacing.vXl,
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: AppColors.textSecondary),
        Spacing.vSm,
        Text(value, style: AppTypography.stat),
        Text(label, style: AppTypography.caption),
      ],
    );
  }

  // ===========================================================================
  // PHASE 3.2: BENTO GRID INTERACTIVITY
  // ===========================================================================

  Widget _buildBentoGrid(BuildContext context) {
    final workoutProvider =
        Provider.of<WorkoutProvider>(context, listen: false);

    return Padding(
      padding: Spacing.paddingScreen,
      child: Column(
        children: [
          // Hero Action Card (Full Width)
          _buildHeroCard(workoutProvider),
          Spacing.vMd,

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column
              Expanded(
                child: Column(
                  children: [
                    _buildLastSessionCard(context),
                    Spacing.vMd,
                    _buildWeeklyGoalCard(),
                  ],
                ),
              ),
              Spacing.hMd,
              // Right Column
              Expanded(
                child: _buildVolumeChartCard(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(WorkoutProvider workoutProvider) {
    return PremiumHeroCard(
      onTap: () {
        if (!kIsWeb) HapticFeedback.mediumImpact();
        workoutProvider.startWorkout();
      },
      onLongPress: () => _showQuickActions(context),
    );
  }

  void _showQuickActions(BuildContext context) {
    if (!kIsWeb) HapticFeedback.heavyImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: Spacing.paddingCard,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: const BoxDecoration(
                color: AppColors.border,
                borderRadius: AppRadius.roundedFull,
              ),
            ),
            Spacing.vLg,
            const Text('Quick Actions', style: AppTypography.headlineSmall),
            Spacing.vLg,
            _buildQuickActionItem(
              icon: LucideIcons.plus,
              label: 'Empty Workout',
              onTap: () {
                Navigator.pop(context);
                Provider.of<WorkoutProvider>(context, listen: false)
                    .startWorkout();
              },
            ),
            _buildQuickActionItem(
              icon: LucideIcons.repeat,
              label: 'Repeat Last Session',
              onTap: () {
                Navigator.pop(context);
                final provider =
                    Provider.of<WorkoutProvider>(context, listen: false);
                if (provider.history.isNotEmpty) {
                  provider.startWorkoutFromHistory(provider.history.first);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No previous session found!')),
                  );
                }
              },
            ),
            _buildQuickActionItem(
              icon: LucideIcons.fileText,
              label: 'From Template',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TemplatesScreen(),
                  ),
                );
              },
            ),
            Spacing.vMd,
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    // Phase 2.1.M2: Migrated to GlassCard.frosted
    return GlassCard.frosted(
      margin: const EdgeInsets.only(bottom: 8),
      accentColor: AppColors.brandPrimary,
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.brandPrimary),
          Spacing.hMd,
          Text(label, style: AppTypography.titleMedium),
          const Spacer(),
          const Icon(LucideIcons.chevronRight,
              size: 18, color: AppColors.textMuted),
        ],
      ),
    );
  }

  Widget _buildVolumeChartCard() {
    return Consumer<WorkoutProvider>(
      builder: (context, provider, child) {
        final spots = _getVolumeSpots(provider.history, _chartPeriod);

        return Container(
          height: 312, // Double height of other cards for bento effect
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: AppRadius.roundedLg,
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'VOLUME',
                    style: AppTypography.overline.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 1.0,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _toggleChartPeriod(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.brandPrimary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.repeat,
                          size: 12, color: AppColors.brandPrimary),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              _buildLargeCounter(provider),
              const Spacer(),
              GradientAreaChart(
                spots: spots,
                height: 120,
                color: AppColors.brandPrimary,
              ),
              Spacing.vSm,
              Center(
                child: Text(
                  _chartPeriod == 'week' ? 'LAST 7 DAYS' : 'LAST 4 WEEKS',
                  style: AppTypography.caption
                      .copyWith(color: AppColors.textMuted),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<FlSpot> _getVolumeSpots(List<WorkoutHistory> history, String period) {
    final List<double> values;
    if (period == 'week') {
      values = List.generate(7, (i) {
        final date = DateTime.now().subtract(Duration(days: 6 - i));
        final dayWorkouts = history.where((w) =>
            w.date.year == date.year &&
            w.date.month == date.month &&
            w.date.day == date.day);
        return dayWorkouts.fold<double>(0, (sum, w) => sum + w.totalVolume);
      });
    } else {
      values = List.generate(4, (i) {
        final now = DateTime.now();
        final weekEnd = now.subtract(Duration(days: (3 - i) * 7));
        final weekStart = weekEnd.subtract(const Duration(days: 6));
        final weekWorkouts = history.where((w) =>
            w.date.isAfter(weekStart.subtract(const Duration(seconds: 1))) &&
            w.date.isBefore(weekEnd.add(const Duration(seconds: 1))));
        return weekWorkouts.fold<double>(0, (sum, w) => sum + w.totalVolume);
      });
    }

    return values
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();
  }

  Widget _buildLargeCounter(WorkoutProvider provider) {
    final total =
        provider.history.fold<double>(0, (sum, w) => sum + w.totalVolume);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCounter(
          value: total.round(),
          style:
              AppTypography.displaySmall.copyWith(fontWeight: FontWeight.bold),
          suffix: ' kg',
        ),
        Text(
          'Total Lifted (All Time)',
          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildWeeklyGoalCard() {
    return Consumer2<WorkoutProvider, SettingsProvider>(
      builder: (context, workout, settings, child) {
        return PremiumGoalCard(
          count: workout.weeklyWorkoutCount,
          goal: settings.weeklyGoal,
          height: 148,
        );
      },
    );
  }

  void _toggleChartPeriod() {
    if (!kIsWeb) HapticFeedback.selectionClick();
    setState(() {
      _chartPeriod = _chartPeriod == 'week' ? 'month' : 'week';
    });
  }

  Widget _buildLastSessionCard(BuildContext context) {
    return Consumer<WorkoutProvider>(
      builder: (context, provider, child) {
        final lastSession = provider.lastSession;
        if (lastSession == null) {
          return const PremiumStatCard(
            height: 148,
            title: 'LAST SESSION',
            value: 'NONE',
            subtitle: 'Start training',
            icon: LucideIcons.history,
            accentColor: AppColors.textMuted,
          );
        }

        return PremiumStatCard(
          height: 148,
          title: 'LAST VOL',
          value: '${lastSession.totalVolume.round()}kg',
          subtitle: lastSession.name,
          icon: LucideIcons.history,
          accentColor: AppColors.brandSecondary,
          onTap: () => _showSessionDetails(context, lastSession),
        );
      },
    );
  }

  void _showSessionDetails(BuildContext context, WorkoutHistory session) {
    if (!kIsWeb) HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: Spacing.paddingCard,
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: AppColors.border,
                    borderRadius: AppRadius.roundedFull,
                  ),
                ),
              ),
              Spacing.vLg,
              Text(session.name, style: AppTypography.displayMedium),
              Spacing.vXs,
              Text(
                '${_formatDate(session.date)} • ${session.duration} minutes',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary),
              ),
              Spacing.vLg,
              _buildSessionStatRow(
                  'Total Volume', '${session.totalVolume.round()} kg'),
              _buildSessionStatRow('Exercises', '${session.exercises.length}'),
              _buildSessionStatRow('PRs Set', '${session.prCount}'),
              Spacing.vLg,
              const GymDivider(),
              Spacing.vMd,
              const Text('Exercises', style: AppTypography.titleLarge),
              Spacing.vMd,
              ...session.exercises
                  .map((name) => _buildExerciseItem(name, 'Completed')),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildSessionStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary)),
          Text(value, style: AppTypography.titleMedium),
        ],
      ),
    );
  }

  Widget _buildExerciseItem(String name, String details) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.brandPrimary,
              shape: BoxShape.circle,
            ),
          ),
          Spacing.hMd,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.titleSmall),
                Text(details, style: AppTypography.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // PHASE 3.4: RECENT HISTORY WITH SWIPE-TO-DELETE
  // ===========================================================================

  Widget _buildRecentHistory(BuildContext context) {
    return Consumer<WorkoutProvider>(
      builder: (context, provider, child) {
        final history = provider.history.take(10).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: Spacing.paddingScreen,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent History',
                      style: AppTypography.headlineSmall),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Switch to History tab to see all')),
                      );
                    },
                    child: Text(
                      'VIEW ALL',
                      style: AppTypography.labelSmall
                          .copyWith(color: AppColors.brandPrimary),
                    ),
                  ),
                ],
              ),
            ),
            Spacing.vMd,
            HorizontalHistoryScroller(
              history: history,
              onTap: (session) => _showSessionDetails(context, session),
            ),
          ],
        );
      },
    );
  }
}
