import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/shared_widgets.dart';
import '../core/constants.dart';
import '../core/workout_provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';

// =============================================================================
// PHASE 3: HOME SCREEN ENHANCEMENTS
// =============================================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _counterController;
  late Animation<double> _counterAnimation;

  // 3.3 Chart period toggle
  String _chartPeriod = 'week'; // 'week' or 'month'

  @override
  void initState() {
    super.initState();
    // 3.2 Animated counters on first load
    _counterController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _counterAnimation = CurvedAnimation(
      parent: _counterController,
      curve: Curves.easeOutCubic,
    );
    _counterController.forward();

    // 9.2 Data Resilience - Error Listener
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<WorkoutProvider>();
      provider.addListener(() {
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
      });
    });
  }

  @override
  void dispose() {
    _counterController.dispose();
    super.dispose();
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Profile settings coming soon!')),
                ),
                child: const GymAvatar(
                  name: 'Dzakwan',
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
                  const Text(
                    'Dzakwan',
                    style: AppTypography.headlineMedium,
                  ),
                ],
              ),
            ],
          ),
          _buildStreakBadge(context),
        ],
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
            ListenableBuilder(
              listenable: _counterAnimation,
              builder: (context, child) {
                return Text(
                  '${(12 * _counterAnimation.value).round()} Day',
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
    HapticFeedback.lightImpact();
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
            const Icon(LucideIcons.flame, size: 64, color: Color(0xFFF97316)),
            Spacing.vMd,
            const Text('12 Day Streak! 🔥', style: AppTypography.displayMedium),
            Spacing.vSm,
            Text(
              'Keep it up! You\'re on fire.',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
            Spacing.vLg,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStreakStat('Current', '12', Icons.local_fire_department),
                _buildStreakStat('Best', '21', Icons.emoji_events),
                _buildStreakStat('Total', '89', Icons.fitness_center),
              ],
            ),
            Spacing.vXl,
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
        HapticFeedback.mediumImpact();
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
    HapticFeedback.heavyImpact();
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Coming soon!')),
                );
              },
            ),
            _buildQuickActionItem(
              icon: LucideIcons.fileText,
              label: 'From Template',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Templates coming soon!')),
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

  void _toggleChartPeriod() {
    HapticFeedback.selectionClick();
    setState(() {
      _chartPeriod = _chartPeriod == 'week' ? 'month' : 'week';
    });
  }

  Widget _buildLastSessionCard(BuildContext context, double width) {
    return GymCard(
      width: width,
      onTap: () => _showSessionDetails(context),
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
            const Text('Push Day A', style: AppTypography.headlineSmall),
            Spacing.vXxs,
            // Animated stat counter
            ListenableBuilder(
              listenable: _counterAnimation,
              builder: (context, child) {
                return Text(
                  'Best: Bench ${(80 * _counterAnimation.value).round()}kg',
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.textSecondary),
                );
              },
            ),
            const Spacer(),
            Row(
              children: [
                const GymBadge(text: 'PR', color: AppColors.brandSecondary),
                Spacing.hXs,
                Text(
                  '45 min',
                  style: AppTypography.caption
                      .copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSessionDetails(BuildContext context) {
    HapticFeedback.lightImpact();
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
              const Text('Push Day A', style: AppTypography.displayMedium),
              Spacing.vXs,
              Text(
                'Yesterday • 45 minutes',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary),
              ),
              Spacing.vLg,
              _buildSessionStatRow('Total Volume', '4,280 kg'),
              _buildSessionStatRow('Exercises', '5'),
              _buildSessionStatRow('Sets', '18'),
              _buildSessionStatRow('Best Lift', 'Bench Press 80kg'),
              Spacing.vLg,
              const GymDivider(),
              Spacing.vMd,
              const Text('Exercises', style: AppTypography.titleLarge),
              Spacing.vMd,
              _buildExerciseItem('Bench Press', '4 sets • 60-80kg'),
              _buildExerciseItem('Incline DB Press', '3 sets • 25-30kg'),
              _buildExerciseItem('Cable Fly', '4 sets • 15-20kg'),
              _buildExerciseItem('Tricep Pushdown', '4 sets • 25-35kg'),
              _buildExerciseItem('Overhead Extension', '3 sets • 20-25kg'),
            ],
          ),
        ),
      ),
    );
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
    final history = List<Map<String, String>>.from(AppConstants.mockHistory);

    return Padding(
      padding: Spacing.paddingScreen,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent History', style: AppTypography.headlineSmall),
              TextButton.icon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('History page coming soon!')),
                ),
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
            ...history.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return _HistoryItem(
                key: ValueKey(item['name']! + item['date']!),
                item: item,
                index: index,
                onDismissed: () {
                  // Handle delete
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item['name']} deleted'),
                      action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          // Undo logic
                        },
                      ),
                    ),
                  );
                },
              );
            }),
        ],
      ),
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
  final Map<String, String> item;
  final int index;
  final VoidCallback onDismissed;

  const _HistoryItem({
    super.key,
    required this.item,
    required this.index,
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
                    Text(item['name']!, style: AppTypography.titleMedium),
                    Spacing.vXxs,
                    Text(
                      item['date']!,
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
                    item['volume']!,
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

  void _showHistoryDetails(BuildContext context) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item['name']} details coming soon!')),
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
    final weeklyValues = [40.0, 60.0, 30.0, 80.0, 50.0, 90.0, 20.0];
    final monthlyValues = [
      60.0,
      45.0,
      70.0,
      55.0,
      80.0,
      65.0,
      90.0,
      75.0,
      50.0,
      85.0,
      70.0,
      95.0
    ];

    final values = period == 'week' ? weeklyValues : monthlyValues;
    final maxY = values.reduce((a, b) => a > b ? a : b) * 1.2;

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
          final isHighlight = entry.value > (maxY * 0.7);
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
                width: period == 'week' ? 10 : 6,
                borderRadius: BorderRadius.circular(period == 'week' ? 5 : 3),
              ),
            ],
          );
        }).toList(),
      ),
      swapAnimationDuration: AppAnimations.normal,
      swapAnimationCurve: AppAnimations.smooth,
    );
  }
}
