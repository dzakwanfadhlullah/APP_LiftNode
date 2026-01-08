import 'package:flutter/material.dart';
import '../models/models.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/workout_provider.dart';
import '../core/app_theme.dart';
import '../core/shared_widgets.dart';

// =============================================================================
// PHASE 5: HISTORY SCREEN
// =============================================================================

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  String _searchQuery = '';
  String _selectedFilter = 'All';
  DateTimeRange? _dateRange;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredWorkouts = _getFilteredWorkouts(context);

    return Scaffold(
      backgroundColor: AppColors.bgMain,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildWorkoutsTab(filteredWorkouts),
                  _buildStatsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: Spacing.paddingScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('History', style: AppTypography.displayLarge),
              Row(
                children: [
                  PremiumButton.icon(
                    icon: LucideIcons.calendarDays,
                    onPress: () => _showDateRangePicker(context),
                    style: PremiumButtonStyle.tinted,
                  ),
                  Spacing.hSm,
                  PremiumButton.icon(
                    icon: LucideIcons.filter,
                    onPress: () => _showFilterSheet(context),
                    style: PremiumButtonStyle.tinted,
                  ),
                ],
              ),
            ],
          ),
          Spacing.vMd,
          GymInput(
            hint: 'Search workouts...',
            prefixIcon: LucideIcons.search,
            onChanged: (v) => setState(() => _searchQuery = v),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: Spacing.paddingScreen,
      decoration: const BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.roundedMd,
      ),
      child: TabBar(
        controller: _tabController,
        indicator: const BoxDecoration(
          color: AppColors.brandPrimary,
          borderRadius: AppRadius.roundedMd,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppColors.onPrimary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTypography.labelMedium,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Workouts'),
          Tab(text: 'Stats'),
        ],
      ),
    );
  }

  Widget _buildWorkoutsTab(List<WorkoutHistory> workouts) {
    if (workouts.isEmpty) {
      return _buildEmptyState();
    }

    final groupedWorkouts = _groupByDate(workouts);

    return ListView.builder(
      padding: Spacing.paddingScreen,
      itemCount: groupedWorkouts.length,
      itemBuilder: (context, index) {
        final dateKey = groupedWorkouts.keys.elementAt(index);
        final dayWorkouts = groupedWorkouts[dateKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateHeader(dateKey),
            Spacing.vSm,
            ...dayWorkouts.map((workout) => _WorkoutCard(
                  workout: workout,
                  onTap: () => _showWorkoutDetail(context, workout),
                  onDelete: () => _confirmDeleteWorkout(context, workout),
                )),
            Spacing.vMd,
          ],
        );
      },
    );
  }

  Widget _buildDateHeader(String dateKey) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: const BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: AppRadius.roundedSm,
          ),
          child: Text(
            dateKey,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Spacing.hMd,
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.border,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: GymEmptyState(
          icon: LucideIcons.calendarDays,
          title: 'No workouts found',
          subtitle: _searchQuery.isNotEmpty
              ? 'No results for "$_searchQuery". Try a different search.'
              : 'Your workout history will appear here once you complete a session.',
          action: _searchQuery.isNotEmpty
              ? PremiumButton.secondary(
                  title: 'Clear Search',
                  onPress: () => setState(() => _searchQuery = ''),
                )
              : null,
        ),
      ),
    );
  }

  void _showWorkoutDetail(BuildContext context, WorkoutHistory workout) {
    if (!kIsWeb) HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _WorkoutDetailSheet(workout: workout),
    );
  }

  void _confirmDeleteWorkout(BuildContext context, WorkoutHistory workout) {
    if (!kIsWeb) HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.roundedLg),
        title:
            const Text('Delete Workout?', style: AppTypography.headlineSmall),
        content: Text(
          'This action cannot be undone.',
          style:
              AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          PremiumButton.danger(
            title: 'Delete',
            size: PremiumButtonSize.compact,
            onPress: () {
              context.read<WorkoutProvider>().deleteHistoryEntry(workout.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Workout deleted')),
              );
            },
          ),
        ],
      ),
    );
  }

  List<WorkoutHistory> _getFilteredWorkouts(BuildContext context) {
    final history = context.watch<WorkoutProvider>().history;
    return history.where((workout) {
      final matchesSearch = workout.name
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          workout.exercises
              .any((e) => e.toLowerCase().contains(_searchQuery.toLowerCase()));
      final matchesFilter = _selectedFilter == 'All' ||
          workout.muscleGroups.contains(_selectedFilter);
      bool matchesDate = true;
      if (_dateRange != null) {
        matchesDate = workout.date
                .isAfter(_dateRange!.start.subtract(const Duration(days: 1))) &&
            workout.date.isBefore(_dateRange!.end.add(const Duration(days: 1)));
      }
      return matchesSearch && matchesFilter && matchesDate;
    }).toList();
  }

  void _showDateRangePicker(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.brandPrimary,
              onPrimary: Colors.black,
              surface: AppColors.bgCard,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _dateRange = picked);
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _FilterSheet(
        selectedFilter: _selectedFilter,
        dateRange: _dateRange,
        onFilterChanged: (filter) {
          setState(() => _selectedFilter = filter);
          Navigator.pop(context);
        },
        onClearFilters: () {
          setState(() {
            _selectedFilter = 'All';
            _dateRange = null;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  Map<String, List<WorkoutHistory>> _groupByDate(
      List<WorkoutHistory> workouts) {
    final grouped = <String, List<WorkoutHistory>>{};
    for (final workout in workouts) {
      final now = DateTime.now();
      final diff = now.difference(workout.date).inDays;
      String key;
      if (diff == 0) {
        key = 'Today';
      } else if (diff == 1) {
        key = 'Yesterday';
      } else if (diff < 7) {
        key = 'This Week';
      } else if (diff < 30) {
        key = 'This Month';
      } else {
        key = 'Earlier';
      }
      grouped.putIfAbsent(key, () => []).add(workout);
    }
    return grouped;
  }

  Widget _buildStatsTab() {
    final stats = _calculateStats();
    return SingleChildScrollView(
      padding: Spacing.paddingScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: _buildStatCard('Total Workouts',
                      '${stats['totalWorkouts']}', LucideIcons.calendar)),
              Spacing.hMd,
              Expanded(
                  child: _buildStatCard(
                      'Total Volume',
                      '${(stats['totalVolume'] / 1000).toStringAsFixed(1)}k kg',
                      LucideIcons.scale)),
            ],
          ),
          Spacing.vMd,
          Row(
            children: [
              Expanded(
                  child: _buildStatCard('Avg Duration',
                      '${stats['avgDuration']} min', LucideIcons.clock)),
              Spacing.hMd,
              Expanded(
                  child: _buildStatCard(
                      'PR\'s Set', '${stats['prCount']}', LucideIcons.trophy)),
            ],
          ),
          Spacing.vXl,
          const Text('Workout Frequency', style: AppTypography.headlineSmall),
          Spacing.vMd,
          _buildFrequencyChart(),
          Spacing.vXl,
          const Text('Most Trained', style: AppTypography.headlineSmall),
          Spacing.vMd,
          _buildMuscleDistribution(
              stats['muscleDistribution'] as Map<String, int>),
          Spacing.vXl,
          const Text('Workout Activity', style: AppTypography.headlineSmall),
          Spacing.vMd,
          _buildActivityHeatmap(),
          Spacing.vXl,
          const Text('Recent PRs', style: AppTypography.headlineSmall),
          Spacing.vMd,
          _buildRecentPRs(),
        ],
      ),
    );
  }

  Widget _buildActivityHeatmap() {
    final history = context.watch<WorkoutProvider>().history;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Last 12 weeks (84 days)
    const weeks = 12;
    const days = weeks * 7;
    final startDate = today.subtract(const Duration(days: days - 1));

    // Map workouts to dates
    final workoutDates = <DateTime, int>{};
    for (var w in history) {
      final date = DateTime(w.date.year, w.date.month, w.date.day);
      workoutDates[date] = (workoutDates[date] ?? 0) + 1;
    }

    // Phase 2.1.M3: Migrated to GlassCard.solid for consistent heatmap background
    return GlassCard.solid(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Consistency', style: AppTypography.labelMedium),
              Text('${history.length} workouts total',
                  style: AppTypography.caption),
            ],
          ),
          Spacing.vMd,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(weeks, (wIdx) {
                return Column(
                  children: List.generate(7, (dIdx) {
                    final date = startDate.add(Duration(days: wIdx * 7 + dIdx));
                    if (date.isAfter(today)) {
                      return const SizedBox(width: 14, height: 14);
                    }

                    final count = workoutDates[date] ?? 0;
                    final color = count == 0
                        ? AppColors.bgCardHover
                        : count == 1
                            ? AppColors.brandPrimary.withValues(alpha: 0.4)
                            : count == 2
                                ? AppColors.brandPrimary.withValues(alpha: 0.7)
                                : AppColors.brandPrimary;

                    return Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    );
                  }),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    // Phase 2.1.M3: Migrated to GlassCard.frosted
    return GlassCard.frosted(
      accentColor: AppColors.brandPrimary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.brandPrimary),
              Spacing.hSm,
              Text(label, style: AppTypography.caption),
            ],
          ),
          Spacing.vSm,
          Text(value, style: AppTypography.stat),
        ],
      ),
    );
  }

  Widget _buildFrequencyChart() {
    final weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final history = context.watch<WorkoutProvider>().history;

    // Calculate workout frequency per weekday from last 4 weeks
    final frequency = List<int>.filled(7, 0);
    final fourWeeksAgo = DateTime.now().subtract(const Duration(days: 28));

    for (var workout in history) {
      if (workout.date.isAfter(fourWeeksAgo)) {
        final dayIndex = workout.date.weekday - 1; // Monday = 0
        frequency[dayIndex]++;
      }
    }

    final maxFreq = frequency.reduce((a, b) => a > b ? a : b);
    final normalizer = maxFreq > 0 ? maxFreq.toDouble() : 1.0;

    // Phase 2.1.M3: Migrated to GlassCard.frosted
    return GlassCard.frosted(
      accentColor: AppColors.brandPrimary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (i) {
          final isToday = DateTime.now().weekday == i + 1;
          return Column(
            children: [
              Container(
                width: 32,
                height: 80,
                decoration: const BoxDecoration(
                    color: AppColors.bgCardHover,
                    borderRadius: AppRadius.roundedSm),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedContainer(
                    duration: AppAnimations.normal,
                    width: 32,
                    height: (frequency[i] / normalizer) * 80,
                    decoration: BoxDecoration(
                      gradient:
                          frequency[i] > 0 ? AppColors.gradientPrimary : null,
                      color: frequency[i] == 0 ? AppColors.bgCardHover : null,
                      borderRadius: AppRadius.roundedSm,
                    ),
                  ),
                ),
              ),
              Spacing.vSm,
              Text(
                weekDays[i],
                style: AppTypography.caption.copyWith(
                  color: isToday
                      ? AppColors.brandPrimary
                      : AppColors.textSecondary,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildMuscleDistribution(Map<String, int> distribution) {
    if (distribution.isEmpty) return const SizedBox.shrink();

    final List<PieChartSectionData> sections = [];
    final total = distribution.values.fold<int>(0, (sum, v) => sum + v);

    int i = 0;
    distribution.forEach((muscle, count) {
      final percentage = (count / total * 100).round();
      if (percentage < 3) return; // Skip very small sections

      final colors = [
        AppColors.brandPrimary,
        const Color(0xFFF97316),
        const Color(0xFF3B82F6),
        const Color(0xFFEAB308),
        const Color(0xFFA855F7),
        const Color(0xFF10B981),
      ];

      sections.add(
        PieChartSectionData(
          value: count.toDouble(),
          title: '$percentage%',
          radius: 60,
          titleStyle: AppTypography.labelSmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          color: colors[i % colors.length],
          badgeWidget: Text(
            muscle,
            style: const TextStyle(fontSize: 8, color: Colors.white70),
          ),
          badgePositionPercentageOffset: 1.4,
        ),
      );
      i++;
    });

    // Phase 2.1.M3: Migrated to GlassCard.frosted
    return GlassCard.frosted(
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: sections,
                sectionsSpace: 2,
                centerSpaceRadius: 30,
              ),
            ),
          ),
          Spacing.vMd,
          // Simple legend
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: distribution.entries.take(5).map((e) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors
                          .brandPrimary, // Simple mock color for legend
                      shape: BoxShape.circle,
                    ),
                  ),
                  Spacing.hXs,
                  Text(e.key, style: AppTypography.caption),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentPRs() {
    final history = context.watch<WorkoutProvider>().history;

    // Get workouts with PRs (prCount > 0), take last 5
    final workoutsWithPRs =
        history.where((w) => w.prCount > 0).take(5).toList();

    if (workoutsWithPRs.isEmpty) {
      // Phase 2.1.M3: Migrated to GlassCard.frosted
      return GlassCard.frosted(
        child: Column(
          children: [
            const Icon(LucideIcons.trophy,
                size: 32, color: AppColors.textMuted),
            Spacing.vMd,
            Text(
              'No PRs yet!',
              style: AppTypography.titleMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
            Spacing.vXs,
            const Text(
              'Complete workouts to track your personal records',
              style: AppTypography.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: workoutsWithPRs.map((workout) {
        final daysAgo = DateTime.now().difference(workout.date).inDays;
        final dateText = daysAgo == 0
            ? 'Today'
            : daysAgo == 1
                ? 'Yesterday'
                : '$daysAgo days ago';

        return GlassCard.frosted(
          margin: const EdgeInsets.only(bottom: 12),
          accentColor: AppColors.brandPrimary,
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                    gradient: AppColors.gradientPrimary,
                    borderRadius: AppRadius.roundedMd),
                child: const Icon(LucideIcons.trophy,
                    size: 22, color: AppColors.brandPrimary),
              ),
              Spacing.hMd,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(workout.exercises.first,
                        style: AppTypography.titleMedium),
                    Text(dateText, style: AppTypography.caption),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: const BoxDecoration(
                    color: AppColors.bgCardHover,
                    borderRadius: AppRadius.roundedSm),
                child: Text(
                    '${workout.prCount} PR${workout.prCount > 1 ? 's' : ''}',
                    style: AppTypography.statSmall),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Map<String, dynamic> _calculateStats() {
    final history = context.watch<WorkoutProvider>().history;
    final totalWorkouts = history.length;
    final totalVolume =
        history.fold<double>(0, (sum, w) => sum + w.totalVolume);
    final avgDuration = totalWorkouts > 0
        ? (history.fold<int>(0, (sum, w) => sum + w.duration) / totalWorkouts)
            .round()
        : 0;
    final prCount = history.fold<int>(0, (sum, w) => sum + w.prCount);
    final muscleDistribution = <String, int>{};
    for (final workout in history) {
      for (final muscle in workout.muscleGroups) {
        muscleDistribution[muscle] = (muscleDistribution[muscle] ?? 0) + 1;
      }
    }
    return {
      'totalWorkouts': totalWorkouts,
      'totalVolume': totalVolume,
      'avgDuration': avgDuration,
      'prCount': prCount,
      'muscleDistribution': muscleDistribution,
    };
  }
}

class _WorkoutCard extends StatelessWidget {
  final WorkoutHistory workout;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  const _WorkoutCard(
      {required this.workout, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(workout.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.bgSurface,
            title:
                const Text('Delete Workout', style: AppTypography.titleMedium),
            content: const Text(
                'Are you sure you want to delete this workout? This action cannot be undone.'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel',
                      style: TextStyle(color: AppColors.textSecondary))),
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Delete',
                      style: TextStyle(color: AppColors.error))),
            ],
          ),
        );
      },
      onDismissed: (_) => onDelete(),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: const BoxDecoration(
            color: AppColors.error, borderRadius: AppRadius.roundedLg),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(LucideIcons.trash2, color: Colors.white),
      ),
      // Phase 2.1.M3: Migrated to GlassCard.frosted for workout history cards
      child: GlassCard.frosted(
        margin: const EdgeInsets.only(bottom: 12),
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                  gradient: AppColors.gradientPrimary,
                  borderRadius: AppRadius.roundedMd),
              child: const Icon(LucideIcons.dumbbell,
                  size: 24, color: AppColors.brandPrimary),
            ),
            Spacing.hMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(workout.name, style: AppTypography.titleMedium),
                      if (workout.prCount > 0) ...[
                        Spacing.hSm,
                        GymBadge.solid(
                            text: '${workout.prCount} PR',
                            color: AppColors.brandSecondary),
                      ],
                    ],
                  ),
                  Spacing.vXxs,
                  Text(
                      '${workout.exercises.length} exercises • ${workout.duration} min',
                      style: AppTypography.caption
                          .copyWith(color: AppColors.textMuted)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${(workout.totalVolume / 1000).toStringAsFixed(1)}k',
                    style: AppTypography.statSmall),
                const Text('kg', style: AppTypography.caption),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkoutDetailSheet extends StatelessWidget {
  final WorkoutHistory workout;
  const _WorkoutDetailSheet({required this.workout});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: Spacing.paddingCard,
      child: Column(
        children: [
          Container(
              width: 40,
              height: 4,
              decoration: const BoxDecoration(
                  color: AppColors.border,
                  borderRadius: AppRadius.roundedFull)),
          Spacing.vLg,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(workout.name, style: AppTypography.displayMedium),
                    Spacing.vXxs,
                    Text(_formatDate(workout.date),
                        style: AppTypography.bodyMedium
                            .copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              PremiumButton.icon(
                icon: LucideIcons.share2,
                onPress: _shareWorkout,
                style: PremiumButtonStyle.tinted,
              ),
            ],
          ),
          Spacing.vLg,
          Row(
            children: [
              _buildDetailStat(
                  'Duration', '${workout.duration} min', LucideIcons.clock),
              Spacing.hMd,
              _buildDetailStat(
                  'Volume',
                  '${(workout.totalVolume / 1000).toStringAsFixed(1)}k kg',
                  LucideIcons.scale),
              Spacing.hMd,
              _buildDetailStat('Exercises', '${workout.exercises.length}',
                  LucideIcons.dumbbell),
            ],
          ),
          Spacing.vLg,
          const GymDivider(),
          Spacing.vMd,
          Expanded(
            child: ListView.builder(
              itemCount: workout.exercises.length,
              itemBuilder: (context, index) =>
                  _buildExerciseItem(workout.exercises[index], index),
            ),
          ),
          Spacing.vMd,
          PremiumButton.secondary(
            title: 'Repeat Workout',
            width: double.infinity,
            icon: LucideIcons.repeat,
            onPress: () {
              context.read<WorkoutProvider>().startWorkoutFromHistory(workout);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Workout started from history!')),
              );
            },
          ),
          Spacing.vMd,
          PremiumButton.secondary(
            title: 'Save as Template',
            width: double.infinity,
            icon: LucideIcons.plus,
            onPress: () {
              context
                  .read<WorkoutProvider>()
                  .saveHistoryAsTemplate(workout, workout.name);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Saved to templates!')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailStat(String label, String value, IconData icon) {
    return Expanded(
      // Phase 2.1.M3: Migrated to GlassCard.frosted
      child: GlassCard.frosted(
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondary),
            Spacing.vSm,
            Text(value, style: AppTypography.titleMedium),
            Text(label, style: AppTypography.caption),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseItem(String exercise, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.bgCardHover,
              borderRadius: AppRadius.roundedSm,
            ),
            child: Center(
              child: Text('${index + 1}', style: AppTypography.labelSmall),
            ),
          ),
          Spacing.hMd,
          Expanded(
            child: Text(exercise, style: AppTypography.bodyMedium),
          ),
          const Icon(LucideIcons.chevronRight,
              size: 16, color: AppColors.textMuted),
        ],
      ),
    );
  }

  void _shareWorkout() {
    final exercisesTxt = workout.exercises.join(', ');
    final shareTxt = 'Just finished a workout! 💪\n\n'
        'Workout: ${workout.name}\n'
        'Duration: ${workout.duration} min\n'
        'Volume: ${(workout.totalVolume / 1000).toStringAsFixed(1)}k kg\n'
        'Exercises: $exercisesTxt\n\n'
        'Tracked with Gym Tracker Pro';

    Share.share(shareTxt);
  }

  String _formatDate(DateTime date) {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }
}

class _FilterSheet extends StatelessWidget {
  final String selectedFilter;
  final DateTimeRange? dateRange;
  final Function(String) onFilterChanged;
  final VoidCallback onClearFilters;
  const _FilterSheet(
      {required this.selectedFilter,
      this.dateRange,
      required this.onFilterChanged,
      required this.onClearFilters});

  @override
  Widget build(BuildContext context) {
    final filters = [
      'All',
      'Abdominals',
      'Abductors',
      'Adductors',
      'Biceps',
      'Calves',
      'Cardio',
      'Chest',
      'Forearms',
      'Full Body',
      'Glutes',
      'Hamstrings',
      'Lats',
      'Lower Back',
      'Neck',
      'Obliques',
      'Quadriceps',
      'Shoulders',
      'Traps',
      'Triceps',
      'Upper Back',
    ];
    return Container(
      padding: Spacing.paddingCard,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: Container(
                  width: 40,
                  height: 4,
                  decoration: const BoxDecoration(
                      color: AppColors.border,
                      borderRadius: AppRadius.roundedFull))),
          Spacing.vLg,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filter By Muscle Group',
                  style: AppTypography.headlineSmall),
              TextButton(
                  onPressed: onClearFilters,
                  child: const Text('Clear All',
                      style: TextStyle(color: AppColors.error))),
            ],
          ),
          Spacing.vMd,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: filters.map((filter) {
              final isSelected = selectedFilter == filter;
              return GestureDetector(
                onTap: () => onFilterChanged(filter),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.brandPrimary
                        : AppColors.bgCardHover,
                    borderRadius: AppRadius.roundedFull,
                    border: Border.all(
                        color: isSelected
                            ? AppColors.brandPrimary
                            : AppColors.border),
                  ),
                  child: Text(filter,
                      style: AppTypography.labelMedium.copyWith(
                          color: isSelected
                              ? AppColors.onPrimary
                              : AppColors.textPrimary)),
                ),
              );
            }).toList(),
          ),
          Spacing.vXl,
        ],
      ),
    );
  }
}
