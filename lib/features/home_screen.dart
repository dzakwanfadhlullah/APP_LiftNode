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
                      // Navigate to Profile Tab (index 3)
                      // This assumes HomeScreen is hosted in a MainScaffold that provides navigation
                      // For now, if we can't easily switch tabs from here without a global controller,
                      // we can just open the edit sheet if we are in ProfileScreen,
                      // but here in HomeScreen it's better to navigate.
                      // Actually, the easiest way to switch tabs in this specific architecture
                      // (if using a stateful MainScaffold) is to use a provider or a global key.
                      // Since I don't see one yet, I'll check how tabs are switched.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Navigate to Profile tab below!')),
                      );
                    },
                    child: GymAvatar(
                      name: settings.userName,
                      size: 44,
                      borderColor: AppColors.brandPrimary,
                    ),
                  ),
                  Spacing.hMd,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getDynamicGreeting().toUpperCase(),
                        style: AppTypography.overline.copyWith(
                          color: AppColors.textSecondary,
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
              _buildStreakBadge(context),
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

  Widget _buildStreakBadge(BuildContext context) {
    return GestureDetector(
      onTap: () => _showStreakDetails(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFF97316).withValues(alpha: 0.2),
              const Color(0xFFEF4444).withValues(alpha: 0.1),
            ],
          ),
          borderRadius: AppRadius.roundedFull,
          border: Border.all(
            color: const Color(0xFFF97316).withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.flame, size: 18, color: Color(0xFFF97316)),
            Spacing.hXs,
            Consumer<WorkoutProvider>(
              builder: (context, provider, child) {
                return Text(
                  '${provider.streak} Day',
                  style: AppTypography.labelMedium.copyWith(
                    color: const Color(0xFFF97316),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
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
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 32 - 12) / 2;
    final workoutProvider =
        Provider.of<WorkoutProvider>(context, listen: false);

    return Padding(
      padding: Spacing.paddingScreen,
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          // Hero Action Card
          _buildHeroCard(workoutProvider),

          // Volume Chart Card with toggle
          _buildVolumeChartCard(itemWidth),

          // Last Session Card with animated stats
          _buildLastSessionCard(context, itemWidth),

          // Weekly Goal Card (Phase 2.7)
          _buildWeeklyGoalCard(itemWidth),
        ],
      ),
    );
  }

  Widget _buildHeroCard(WorkoutProvider workoutProvider) {
    return GymCard(
      width: double.infinity,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.brandPrimary, Color(0xFF8BD56B)],
      ),
      onTap: () {
        if (!kIsWeb) HapticFeedback.mediumImpact();
        workoutProvider.startWorkout();
      },
      onLongPress: () => _showQuickActions(context),
      child: SizedBox(
        height: 140,
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.plus,
                      size: 28, color: Colors.black),
                ),
                Spacing.hMd,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Start Workout',
                      style: AppTypography.headlineLarge
                          .copyWith(color: Colors.black),
                    ),
                    Spacing.vXxs,
                    Text(
                      'Tap to begin • Hold for options',
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.black.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              right: -30,
              bottom: -30,
              child: Icon(
                LucideIcons.dumbbell,
                size: 140,
                color: Colors.black.withValues(alpha: 0.08),
              ),
            ),
          ],
        ),
      ),
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
    return GymCard(
      margin: const EdgeInsets.only(bottom: 8),
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

  Widget _buildVolumeChartCard(double width) {
    return GymCard(
      width: width,
      onTap: () => _toggleChartPeriod(),
      child: SizedBox(
        height: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'VOLUME (KG)',
                  style: AppTypography.overline
                      .copyWith(color: AppColors.textSecondary),
                ),
                const Icon(
                  LucideIcons.refreshCw,
                  size: 12,
                  color: AppColors.textMuted,
                ),
              ],
            ),
            Spacing.vSm,
            Expanded(child: _VolumeChart(period: _chartPeriod)),
            Spacing.vSm,
            Center(
              child: GestureDetector(
                onTap: () => _toggleChartPeriod(),
                child: GymBadge(
                  text: _chartPeriod == 'week' ? 'THIS WEEK' : 'THIS MONTH',
                  icon: LucideIcons.calendar,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyGoalCard(double width) {
    return Consumer2<WorkoutProvider, SettingsProvider>(
      builder: (context, workout, settings, child) {
        final count = workout.weeklyWorkoutCount;
        final goal = settings.weeklyGoal;
        final progress = (count / goal).clamp(0.0, 1.0);

        return GymCard(
          width: width,
          onTap: () {
            // Future: Show goal settings
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Goal settings coming soon!')),
            );
          },
          child: SizedBox(
            height: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'WEEKLY GOAL',
                      style: AppTypography.overline
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    Icon(
                      LucideIcons.target,
                      size: 14,
                      color: progress >= 1.0
                          ? AppColors.brandPrimary
                          : AppColors.textMuted,
                    ),
                  ],
                ),
                const Spacer(),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 6,
                          backgroundColor: AppColors.bgCardHover,
                          color: AppColors.brandPrimary,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('$count', style: AppTypography.headlineSmall),
                          Text('/$goal',
                              style: AppTypography.caption
                                  .copyWith(color: AppColors.textMuted)),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  progress >= 1.0 ? 'Goal Reached! 🎉' : '${goal - count} left',
                  style: AppTypography.caption.copyWith(
                    color: progress >= 1.0
                        ? AppColors.brandPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
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

  Widget _buildLastSessionCard(BuildContext context, double width) {
    return Consumer<WorkoutProvider>(
      builder: (context, provider, child) {
        final lastSession = provider.lastSession;
        if (lastSession == null) {
          return GymCard(
            width: width,
            child: SizedBox(
              height: 160,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.history,
                      size: 32, color: AppColors.textMuted),
                  Spacing.vSm,
                  Text('No Sessions',
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.textMuted)),
                ],
              ),
            ),
          );
        }

        return GymCard(
          width: width,
          onTap: () => _showSessionDetails(context, lastSession),
          child: SizedBox(
            height: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'LAST SESSION',
                      style: AppTypography.overline
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    const Icon(LucideIcons.history,
                        size: 14, color: AppColors.brandSecondary),
                  ],
                ),
                Spacing.vSm,
                Text(lastSession.name,
                    style: AppTypography.headlineSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Spacing.vXxs,
                Text(
                  'Vol: ${lastSession.totalVolume.round()}kg',
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.textSecondary),
                ),
                const Spacer(),
                Row(
                  children: [
                    if (lastSession.prCount > 0)
                      const GymBadge(
                          text: 'PR', color: AppColors.brandSecondary),
                    if (lastSession.prCount > 0) Spacing.hXs,
                    Text(
                      '${lastSession.duration} min',
                      style: AppTypography.caption
                          .copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
        final history = provider.history.take(5).toList();

        return Padding(
          padding: Spacing.paddingScreen,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent History',
                      style: AppTypography.headlineSmall),
                  TextButton.icon(
                    onPressed: () {
                      // Navigate to history tab via main scaffold if possible,
                      // but here we just show a message since we are a sub-page.
                      // Actually, it's better to just keep it as is or show info.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Switch to History tab to see all')),
                      );
                    },
                    icon: const Icon(LucideIcons.arrowRight, size: 16),
                    label: Text(
                      'VIEW ALL',
                      style: AppTypography.labelSmall
                          .copyWith(color: AppColors.brandPrimary),
                    ),
                  ),
                ],
              ),
              Spacing.vMd,
              if (history.isEmpty)
                _buildEmptyHistory()
              else
                ...history.map((workout) {
                  return _HistoryItem(
                    key: ValueKey(workout.id),
                    workout: workout,
                    onDismissed: () {
                      provider.deleteHistoryEntry(workout.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Workout deleted')),
                      );
                    },
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyHistory() {
    return GymEmptyState(
      icon: LucideIcons.dumbbell,
      title: 'No Workouts Yet',
      subtitle: 'Start your first workout to see your history here.',
      action: NeonButton(
        title: 'Start Workout',
        icon: LucideIcons.plus,
        onPress: () {
          Provider.of<WorkoutProvider>(context, listen: false).startWorkout();
        },
      ),
    );
  }
}

// =============================================================================
// HISTORY ITEM WITH SWIPE-TO-DELETE
// =============================================================================

class _HistoryItem extends StatelessWidget {
  final WorkoutHistory workout;
  final VoidCallback onDismissed;

  const _HistoryItem({
    super.key,
    required this.workout,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key!,
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: const BoxDecoration(
          color: AppColors.error,
          borderRadius: AppRadius.roundedLg,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(LucideIcons.trash2, color: Colors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GymCard(
          onTap: () => _showHistoryDetails(context),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.brandPrimary.withValues(alpha: 0.1),
                  borderRadius: AppRadius.roundedMd,
                ),
                child: const Icon(
                  LucideIcons.check,
                  size: 22,
                  color: AppColors.brandPrimary,
                ),
              ),
              Spacing.hMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(workout.name, style: AppTypography.titleMedium),
                    Spacing.vXxs,
                    Text(
                      _formatDate(workout.date),
                      style: AppTypography.caption
                          .copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${workout.totalVolume.round()} kg',
                    style: AppTypography.statSmall.copyWith(fontSize: 16),
                  ),
                  Spacing.vXxs,
                  const Icon(
                    LucideIcons.chevronRight,
                    size: 16,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
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

  void _showHistoryDetails(BuildContext context) {
    if (!kIsWeb) HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${workout.name} details coming soon!')),
    );
  }
}

// =============================================================================
// PHASE 3.3: VOLUME CHART WITH WEEKLY/MONTHLY TOGGLE
// =============================================================================

class _VolumeChart extends StatelessWidget {
  final String period;

  const _VolumeChart({required this.period});

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutProvider>(
      builder: (context, provider, child) {
        final history = provider.history;
        final List<double> values;

        if (period == 'week') {
          // Last 7 days
          values = List.generate(7, (i) {
            final date = DateTime.now().subtract(Duration(days: 6 - i));
            final dayWorkouts = history.where((w) =>
                w.date.year == date.year &&
                w.date.month == date.month &&
                w.date.day == date.day);
            return dayWorkouts.fold<double>(0, (sum, w) => sum + w.totalVolume);
          });
        } else {
          // Last 4 weeks
          values = List.generate(4, (i) {
            final now = DateTime.now();
            final weekEnd = now.subtract(Duration(days: (3 - i) * 7));
            final weekStart = weekEnd.subtract(const Duration(days: 6));
            final weekWorkouts = history.where((w) =>
                w.date
                    .isAfter(weekStart.subtract(const Duration(seconds: 1))) &&
                w.date.isBefore(weekEnd.add(const Duration(seconds: 1))));
            return weekWorkouts.fold<double>(
                0, (sum, w) => sum + w.totalVolume);
          });
        }

        final maxVal = values.fold<double>(0, (max, v) => v > max ? v : max);
        final maxY = maxVal == 0 ? 100.0 : maxVal * 1.2;

        return BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceBetween,
            maxY: maxY,
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: AppColors.bgCardHover,
                tooltipRoundedRadius: 8,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${rod.toY.round()}kg\n',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: period == 'week'
                            ? 'Day ${groupIndex + 1}'
                            : 'Week ${groupIndex + 1}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            titlesData: const FlTitlesData(show: false),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            barGroups: values.asMap().entries.map((entry) {
              final isHighlight = entry.value > 0;
              return BarChartGroupData(
                x: entry.key,
                barRods: [
                  BarChartRodData(
                    toY: entry.value,
                    gradient: isHighlight
                        ? const LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Color(0xFF8BD56B), AppColors.brandPrimary],
                          )
                        : null,
                    color: isHighlight ? null : AppColors.bgCardHover,
                    width: period == 'week' ? 10 : 20,
                    borderRadius:
                        BorderRadius.circular(period == 'week' ? 5 : 8),
                  ),
                ],
              );
            }).toList(),
          ),
          swapAnimationDuration: AppAnimations.normal,
          swapAnimationCurve: AppAnimations.smooth,
        );
      },
    );
  }
}
