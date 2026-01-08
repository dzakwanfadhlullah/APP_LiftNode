import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/shared_widgets.dart';
import '../core/workout_provider.dart';
import '../core/settings_provider.dart';
import '../core/constants.dart';
import '../models/models.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// =============================================================================
// PHASE 4: WORKOUT LOGGER REFINEMENTS
// =============================================================================

class WorkoutLoggerScreen extends StatefulWidget {
  const WorkoutLoggerScreen({super.key});

  @override
  State<WorkoutLoggerScreen> createState() => _WorkoutLoggerScreenState();
}

class _WorkoutLoggerScreenState extends State<WorkoutLoggerScreen> {
  // 4.3 Rest timer presets
  int _selectedRestTime = 90; // seconds
  final List<int> _restPresets = [30, 60, 90, 120, 180];

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
      backgroundColor: AppColors.bgMain,
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: Spacing.paddingScreen,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWorkoutTitle(context),
                      Spacing.vLg,
                      Selector<WorkoutProvider, List<ActiveExercise>>(
                        selector: (_, p) => p.exercises,
                        builder: (context, exercises, child) {
                          if (exercises.isEmpty) {
                            return _buildEmptyState(context);
                          }
                          return ReorderableListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: exercises.length,
                            onReorder: (oldIndex, newIndex) {
                              context
                                  .read<WorkoutProvider>()
                                  .reorderExercises(oldIndex, newIndex);
                            },
                            proxyDecorator: (child, index, animation) {
                              return AnimatedBuilder(
                                animation: animation,
                                builder: (BuildContext context, Widget? child) {
                                  return Material(
                                    color: Colors.transparent,
                                    shadowColor: Colors.black,
                                    elevation: 8.0 * animation.value,
                                    child: child,
                                  );
                                },
                                child: child,
                              );
                            },
                            itemBuilder: (context, index) {
                              final exercise = exercises[index];
                              return _ExerciseCard(
                                key: ValueKey(
                                    exercise.id), // Important for reorder
                                exercise: exercise,
                                index: index,
                                onDeleteSet: (setIndex) =>
                                    _confirmDeleteSet(context, index, setIndex),
                              );
                            },
                          );
                        },
                      ),
                      Spacing.vMd,
                      Selector<WorkoutProvider, bool>(
                        selector: (_, p) => p.exercises.isNotEmpty,
                        builder: (context, hasExercises, child) {
                          if (!hasExercises) return const SizedBox.shrink();
                          return NeonButton(
                            variant: 'outline',
                            title: 'ADD EXERCISE',
                            icon: LucideIcons.plus,
                            onPress: () => _showExerciseModal(context),
                          );
                        },
                      ),
                      Spacing.vXxl,
                    ],
                  ),
                ),
              ),
            ],
          ),
          Selector<WorkoutProvider, bool>(
            selector: (_, p) => p.isResting,
            builder: (context, isResting, child) {
              if (isResting) return _buildEnhancedRestTimer(context);
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutTitle(BuildContext context) {
    final hour = DateTime.now().hour;
    final sessionName = hour < 12
        ? 'Morning Pump 💪'
        : hour < 17
            ? 'Afternoon Grind 🔥'
            : 'Evening Pump 🌙';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(sessionName, style: AppTypography.headlineLarge),
            Spacing.vXxs,
            Text(
              _getFormattedDate(),
              style: AppTypography.caption.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
        NeonButton.icon(
          icon: LucideIcons.settings,
          onPress: () => _showWorkoutSettings(context),
        ),
      ],
    );
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
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
    return '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  void _showWorkoutSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _WorkoutSettingsSheet(
        selectedRestTime: _selectedRestTime,
        restPresets: _restPresets,
        onRestTimeChanged: (time) {
          setState(() => _selectedRestTime = time);
          Navigator.pop(context);
        },
      ),
    );
  }

  // ===========================================================================
  // PHASE 4.3: ENHANCED REST TIMER WITH CIRCULAR PROGRESS
  // ===========================================================================

  Widget _buildEnhancedRestTimer(BuildContext context) {
    final provider = context.read<WorkoutProvider>();
    // Parse elapsed time to get seconds
    final parts = provider.restElapsedTime.split(':');
    final minutes = int.tryParse(parts[0]) ?? 0;
    final seconds = int.tryParse(parts[1]) ?? 0;
    final totalSeconds = minutes * 60 + seconds;
    final progress = (totalSeconds / _selectedRestTime).clamp(0.0, 1.0);

    return Positioned(
      bottom: 40,
      left: 20,
      right: 20,
      child: GymCard(
        gradient: AppColors.gradientPrimary,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                // Circular progress indicator
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 6,
                          backgroundColor: AppColors.bgCardHover,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            progress >= 1.0
                                ? AppColors.brandPrimary
                                : AppColors.brandSecondary,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Selector<WorkoutProvider, String>(
                            selector: (_, p) => p.restElapsedTime,
                            builder: (context, restElapsedTime, child) {
                              return Text(
                                restElapsedTime,
                                style:
                                    AppTypography.stat.copyWith(fontSize: 20),
                              );
                            },
                          ),
                          Text(
                            '/ ${_formatRestTime(_selectedRestTime)}',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Spacing.hLg,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(LucideIcons.timer,
                              size: 16, color: AppColors.brandPrimary),
                          Spacing.hSm,
                          Text('REST TIME', style: AppTypography.overline),
                        ],
                      ),
                      Spacing.vSm,
                      Text(
                        progress >= 1.0 ? "Time's up! 💪" : 'Recover & prepare',
                        style: AppTypography.bodyMedium.copyWith(
                          color: progress >= 1.0
                              ? AppColors.brandPrimary
                              : AppColors.textSecondary,
                        ),
                      ),
                      Spacing.vMd,
                      // Quick adjust buttons
                      Row(
                        children: [
                          _buildRestAdjustButton('-30s', () {
                            // Decrease target rest time
                            if (_selectedRestTime > 30) {
                              setState(() => _selectedRestTime -= 30);
                            }
                          }),
                          Spacing.hSm,
                          _buildRestAdjustButton('+30s', () {
                            setState(() => _selectedRestTime += 30);
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => provider.stopRest(),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: AppColors.bgCardHover,
                      borderRadius: AppRadius.roundedMd,
                    ),
                    child: const Icon(LucideIcons.x,
                        size: 20, color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestAdjustButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: const BoxDecoration(
          color: AppColors.bgCardHover,
          borderRadius: AppRadius.roundedSm,
        ),
        child: Text(label, style: AppTypography.labelSmall),
      ),
    );
  }

  String _formatRestTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  // ===========================================================================
  // HEADER & EMPTY STATE
  // ===========================================================================

  Widget _buildHeader(BuildContext context) {
    final provider = context.read<WorkoutProvider>();
    return Container(
      color: AppColors.bgCard,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        bottom: 12,
        left: 16,
        right: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => _confirmCancelWorkout(context, provider),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.bgCardHover,
                borderRadius: AppRadius.roundedMd,
              ),
              child: const Icon(
                LucideIcons.chevronDown,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Spacing.hSm,
                  const Text(
                    'ACTIVE WORKOUT',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      color: AppColors.brandPrimary,
                    ),
                  ),
                ],
              ),
              Spacing.vXxs,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.clock,
                      size: 14, color: AppColors.textSecondary),
                  Spacing.hXs,
                  Selector<WorkoutProvider, String>(
                    selector: (_, p) => p.elapsedTime,
                    builder: (context, elapsedTime, child) {
                      return Text(
                        elapsedTime,
                        style: AppTypography.statSmall.copyWith(
                          fontFamily: 'monospace',
                          fontSize: 18,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          NeonButton(
            title: 'Finish',
            size: ButtonSize.small,
            icon: LucideIcons.check,
            onPress: () => _showWorkoutSummary(context, provider),
          ),
        ],
      ),
    );
  }

  void _confirmCancelWorkout(BuildContext context, WorkoutProvider provider) {
    if (!kIsWeb) HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.roundedLg),
        title:
            const Text('Cancel Workout?', style: AppTypography.headlineSmall),
        content: Text(
          'Your progress will be lost. Are you sure?',
          style:
              AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Going',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          NeonButton(
            title: 'Cancel',
            variant: 'danger',
            size: ButtonSize.small,
            onPress: () {
              Navigator.pop(context);
              provider.finishWorkout(context.read<SettingsProvider>());
            },
          ),
        ],
      ),
    );
  }

  void _confirmDeleteSet(BuildContext context, int exIndex, int setIndex) {
    if (!kIsWeb) HapticFeedback.lightImpact();
    // For now, just show a snackbar - actual delete would be in provider
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Set ${setIndex + 1} deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            // Undo logic would go here
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return GymEmptyState(
      icon: LucideIcons.dumbbell,
      title: "Let's get moving",
      subtitle: 'Add an exercise to start tracking your gains.',
      action: NeonButton(
        title: 'Add Exercise',
        icon: LucideIcons.plus,
        onPress: () => _showExerciseModal(context),
      ),
    );
  }

  void _showExerciseModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgMain,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const ExerciseSelectModal(),
    );
  }

  // ===========================================================================
  // PHASE 4.4: WORKOUT SUMMARY MODAL
  // ===========================================================================

  void _showWorkoutSummary(BuildContext context, WorkoutProvider provider) {
    if (!kIsWeb) HapticFeedback.heavyImpact();

    // Calculate stats
    final totalSets = provider.exercises.fold<int>(
      0,
      (sum, ex) => sum + ex.sets.where((s) => s.completed).length,
    );
    final totalVolume = provider.exercises.fold<double>(0, (sum, ex) {
      return sum +
          ex.sets.where((s) => s.completed).fold<double>(0, (setSum, s) {
            final kg = double.tryParse(s.kg) ?? 0;
            final reps = int.tryParse(s.reps) ?? 0;
            return setSum + (kg * reps);
          });
    });
    final exerciseCount = provider.exercises.length;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _WorkoutSummarySheet(
        elapsedTime: provider.elapsedTime,
        exerciseCount: exerciseCount,
        totalSets: totalSets,
        totalVolume: totalVolume,
        exercises: provider.exercises,
        onFinish: () {
          Navigator.pop(context);
          provider.finishWorkout(context.read<SettingsProvider>());
        },
        onContinue: () => Navigator.pop(context),
      ),
    );
  }
}

// =============================================================================
// PHASE 4.2: EXERCISE CARD WITH SWIPE-TO-DELETE SETS
// =============================================================================

class _ExerciseCard extends StatelessWidget {
  final int index;
  final ActiveExercise exercise;
  final Function(int setIndex) onDeleteSet;

  const _ExerciseCard({
    super.key,
    required this.index,
    required this.exercise,
    required this.onDeleteSet,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<WorkoutProvider>();

    return GymCard(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          _buildExerciseHeader(context),
          const GymDivider(height: 1),
          _buildTableHeader(),
          // Sets with swipe-to-delete
          ...exercise.sets.asMap().entries.map((setEntry) {
            return _SetRow(
              key: ValueKey('set_${index}_${setEntry.key}'),
              exIndex: index,
              setIndex: setEntry.key,
              workoutSet: setEntry.value,
              previousSet:
                  setEntry.key > 0 ? exercise.sets[setEntry.key - 1] : null,
              onDelete: () => onDeleteSet(setEntry.key),
            );
          }),
          // Add set button
          InkWell(
            onTap: () => provider.addSet(index),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.plus,
                      size: 16, color: AppColors.brandPrimary),
                  Spacing.hSm,
                  Text(
                    'ADD SET',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.brandPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseHeader(BuildContext context) {
    return ReorderableDragStartListener(
      index: index,
      child: GestureDetector(
        onTap: () => _showExerciseOptions(
            context, index, exercise.exerciseId), // Use exerciseId
        child: Container(
          color: Colors.transparent, // Hit test target
          padding: const EdgeInsets.all(16).copyWith(bottom: 0),
          child: Row(
            children: [
              Icon(LucideIcons.gripVertical,
                  color: AppColors.textMuted.withValues(alpha: 0.5), size: 20),
              Spacing.hSm,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.brandPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (exercise.muscle.isNotEmpty) ...[
                      Spacing.vXxs,
                      Text(
                        exercise.muscle.toUpperCase(),
                        style: AppTypography.overline,
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, size: 20),
                onPressed: () => _showExerciseOptions(
                    context, index, exercise.exerciseId), // Use exerciseId
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      color: AppColors.bgCardHover.withValues(alpha: 0.5),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: const Row(
        children: [
          SizedBox(
              width: 35,
              child: Center(child: Text('SET', style: AppTypography.overline))),
          Expanded(
              child:
                  Center(child: Text('PREV', style: AppTypography.overline))),
          SizedBox(
              width: 60,
              child: Center(child: Text('KG', style: AppTypography.overline))),
          SizedBox(
              width: 60,
              child:
                  Center(child: Text('REPS', style: AppTypography.overline))),
          SizedBox(
              width: 40,
              child: Center(child: Text('RPE', style: AppTypography.overline))),
          SizedBox(
              width: 45,
              child: Center(child: Text('✓', style: AppTypography.overline))),
        ],
      ),
    );
  }

  void _showExerciseOptions(
      BuildContext context, int index, String exerciseId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textDisabled,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Spacing.vLg,
            _buildOptionItem(
              context,
              icon: LucideIcons.info,
              label: 'Exercise Info',
              onTap: () {
                Navigator.pop(context);
                final exercise =
                    context.read<WorkoutProvider>().exercises[index];
                _showExerciseInfo(context, exercise);
              },
            ),
            _buildOptionItem(
              context,
              icon: LucideIcons.replace,
              label: 'Replace Exercise',
              onTap: () {
                _handleReplaceExercise(context, index);
              },
            ),
            _buildOptionItem(
              context,
              icon: LucideIcons.trash2,
              label: 'Remove Exercise',
              color: AppColors.error,
              onTap: () {
                context.read<WorkoutProvider>().removeExercise(exerciseId);
                Navigator.pop(context);
              },
            ),
            Spacing.vLg,
          ],
        ),
      ),
    );
  }

  void _handleReplaceExercise(BuildContext context, int index) {
    Navigator.pop(context); // Close details sheet
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => ExerciseSelectModal(
        onExerciseSelected: (exercise) {
          context.read<WorkoutProvider>().replaceExercise(index, exercise);
          Navigator.pop(context); // Close picker
        },
      ),
    );
  }

  Widget _buildOptionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color ?? AppColors.textPrimary),
            Spacing.hMd,
            Text(
              label,
              style: AppTypography.bodyLarge.copyWith(
                color: color ?? AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExerciseInfo(BuildContext context, ActiveExercise exercise) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, controller) => SingleChildScrollView(
          controller: controller,
          padding: Spacing.paddingCard,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.brandPrimary.withValues(alpha: 0.1),
                      borderRadius: AppRadius.roundedMd,
                    ),
                    child: const Icon(LucideIcons.dumbbell,
                        color: AppColors.brandPrimary, size: 28),
                  ),
                  Spacing.hMd,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: 'exercise_name_${exercise.id}',
                          child: Material(
                            color: Colors.transparent,
                            child: Text(exercise.name,
                                style: AppTypography.headlineSmall),
                          ),
                        ),
                        Text(exercise.muscle,
                            style: AppTypography.bodyMedium
                                .copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
              const GymDivider(),
              const Text('Instructions', style: AppTypography.titleMedium),
              Spacing.vSm,
              Text(
                'Detailed instructions for ${exercise.name} will appear here. '
                'Perform this exercise with controlled form and full range of motion.',
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.textSecondary, height: 1.5),
              ),
              Spacing.vLg,
              _buildInfoRow(
                  LucideIcons.target, 'Target Muscle', exercise.muscle),
              Spacing.vSm,
              _buildInfoRow(
                  LucideIcons.layers, 'Equipment', exercise.equipment),
              Spacing.vSm,
              _buildInfoRow(
                  LucideIcons.activity, 'Difficulty', 'Intermediate'), // Mock
              Spacing.vLg,
              const Text('Last Performed', style: AppTypography.titleMedium),
              Spacing.vSm,
              Consumer<WorkoutProvider>(
                builder: (context, provider, child) {
                  final lastSets =
                      provider.getLastPerformedSets(exercise.exerciseId);
                  if (lastSets == null || lastSets.isEmpty) {
                    return Text(
                      'No previous data for this exercise.',
                      style: AppTypography.caption
                          .copyWith(color: AppColors.textMuted),
                    );
                  }
                  return Column(
                    children: lastSets.map((s) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Text('Set ${lastSets.indexOf(s) + 1}',
                                style: AppTypography.labelSmall),
                            const Spacer(),
                            Text('${s.kg}kg x ${s.reps}',
                                style: AppTypography.bodySmall),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              Spacing.vLg,
              NeonButton.small(
                title: 'Close',
                onPress: () => Navigator.pop(context),
                variant: 'secondary',
              ),
              Spacing.vLg,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        Spacing.hSm,
        Text('$label:',
            style: AppTypography.bodyMedium
                .copyWith(color: AppColors.textSecondary)),
        const Spacer(),
        Text(value,
            style:
                AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// =============================================================================
// PHASE 4.1: SET ROW WITH SMART DEFAULTS & AUTO-FOCUS
// =============================================================================

class _SetRow extends StatefulWidget {
  final int exIndex;
  final int setIndex;
  final WorkoutSet workoutSet;
  final WorkoutSet? previousSet;
  final VoidCallback onDelete;

  const _SetRow({
    super.key,
    required this.exIndex,
    required this.setIndex,
    required this.workoutSet,
    this.previousSet,
    required this.onDelete,
  });

  @override
  State<_SetRow> createState() => _SetRowState();
}

class _SetRowState extends State<_SetRow> {
  late TextEditingController _kgController;
  late TextEditingController _repsController;
  late TextEditingController _rpeController;
  final FocusNode _kgFocus = FocusNode();
  final FocusNode _repsFocus = FocusNode();
  final FocusNode _rpeFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    // 4.1 Smart defaults: use previous set values if current is empty
    final defaultKg = widget.workoutSet.kg.isEmpty
        ? (widget.previousSet?.kg ?? '')
        : widget.workoutSet.kg;
    final defaultReps = widget.workoutSet.reps.isEmpty
        ? (widget.previousSet?.reps ?? '')
        : widget.workoutSet.reps;
    final defaultRpe = widget.workoutSet.rpe ?? '';

    _kgController = TextEditingController(text: defaultKg);
    _repsController = TextEditingController(text: defaultReps);
    _rpeController = TextEditingController(text: defaultRpe);
  }

  @override
  void dispose() {
    _kgController.dispose();
    _repsController.dispose();
    _rpeController.dispose();
    _kgFocus.dispose();
    _repsFocus.dispose();
    _rpeFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<WorkoutProvider>();
    final prevDisplay = widget.previousSet != null
        ? '${widget.previousSet!.kg}×${widget.previousSet!.reps}'
        : '-';

    return Dismissible(
      key: Key('set_${widget.exIndex}_${widget.setIndex}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => widget.onDelete(),
      background: Container(
        color: AppColors.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(LucideIcons.trash2, color: Colors.white, size: 18),
      ),
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: widget.workoutSet.completed
              ? AppColors.brandPrimary.withValues(alpha: 0.05)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.3)),
          ),
        ),
        child: Row(
          children: [
            // Set Type Selector (with Note indicator)
            SizedBox(
              width: 35,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _buildSetTypeSelector(provider),
                  if (widget.workoutSet.note != null &&
                      widget.workoutSet.note!.isNotEmpty)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                            color: AppColors.brandSecondary,
                            shape: BoxShape.circle),
                      ),
                    ),
                ],
              ),
            ),
            // Previous set (or Note preview if tapped?)
            Expanded(
              child: GestureDetector(
                onTap: () => _copyPreviousSet(provider),
                onLongPress: () => _showNoteDialog(context, provider),
                child: Center(
                  child: widget.workoutSet.note != null &&
                          widget.workoutSet.note!.isNotEmpty
                      ? Text(
                          widget.workoutSet.note!,
                          style: AppTypography.caption
                              .copyWith(color: AppColors.brandSecondary),
                          overflow: TextOverflow.ellipsis,
                        )
                      : Text(
                          prevDisplay,
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textMuted,
                            decoration: widget.previousSet != null
                                ? TextDecoration.underline
                                : null,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
              ),
            ),
            // KG input
            _buildInput(
              controller: _kgController,
              focusNode: _kgFocus,
              isDecimal: true,
              width: 60,
              onChanged: (val) =>
                  provider.updateSet(widget.exIndex, widget.setIndex, kg: val),
              onSubmitted: (_) => _repsFocus.requestFocus(),
            ),
            Spacing.hXs,
            // Reps input
            _buildInput(
              controller: _repsController,
              focusNode: _repsFocus,
              width: 60,
              onChanged: (val) => provider
                  .updateSet(widget.exIndex, widget.setIndex, reps: val),
              onSubmitted: (_) => _rpeFocus.requestFocus(),
            ),
            Spacing.hXs,
            // RPE input
            _buildInput(
              controller: _rpeController,
              focusNode: _rpeFocus,
              width: 40,
              isDecimal: true,
              onChanged: (val) {
                if (val.isEmpty) {
                  provider.updateSet(widget.exIndex, widget.setIndex,
                      rpe: null);
                } else {
                  provider.updateSet(widget.exIndex, widget.setIndex, rpe: val);
                }
              },
              onSubmitted: (_) {
                _rpeFocus.unfocus();
                // Optionally auto-complete logic
              },
            ),
            Spacing.hXs,
            // Checkbox
            GestureDetector(
              onTap: () => _handleSetComplete(provider),
              child: AnimatedContainer(
                duration: AppAnimations.fast,
                width: 45,
                height: 36,
                decoration: BoxDecoration(
                  color: widget.workoutSet.completed
                      ? AppColors.brandPrimary
                      : AppColors.bgCardHover,
                  borderRadius: AppRadius.roundedSm,
                  border: widget.workoutSet.completed
                      ? null
                      : Border.all(color: AppColors.border),
                ),
                child: Icon(
                  widget.workoutSet.completed
                      ? LucideIcons.check
                      : LucideIcons.circle,
                  size: 18,
                  color: widget.workoutSet.completed
                      ? AppColors.onPrimary
                      : AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetTypeSelector(WorkoutProvider provider) {
    Color bg;
    Color fg;
    String label;

    switch (widget.workoutSet.type) {
      case SetType.warmup:
        bg = AppColors.warning.withValues(alpha: 0.2);
        fg = AppColors.warning;
        label = 'W';
        break;
      case SetType.failure:
        bg = AppColors.error.withValues(alpha: 0.2);
        fg = AppColors.error;
        label = 'F';
        break;
      case SetType.normal:
        bg = AppColors.bgCardHover;
        fg = AppColors.textPrimary;
        label = '${widget.setIndex + 1}';
        break;
    }

    return PopupMenuButton<SetType>(
      initialValue: widget.workoutSet.type,
      onSelected: (SetType type) {
        provider.updateSet(widget.exIndex, widget.setIndex, type: type);
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: SetType.normal,
          child: Text('Normal Set'),
        ),
        const PopupMenuItem(
          value: SetType.warmup,
          child: Text('Warmup Set (W)'),
        ),
        const PopupMenuItem(
          value: SetType.failure,
          child: Text('Failure Set (F)'),
        ),
      ],
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: AppRadius.roundedXs,
          border: Border.all(
            color: fg.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.labelMedium.copyWith(color: fg),
          ),
        ),
      ),
    );
  }

  void _copyPreviousSet(WorkoutProvider provider) {
    if (widget.previousSet != null) {
      if (!kIsWeb) HapticFeedback.selectionClick();
      _kgController.text = widget.previousSet!.kg;
      _repsController.text = widget.previousSet!.reps;
      provider.updateSet(
        widget.exIndex,
        widget.setIndex,
        kg: widget.previousSet!.kg,
        reps: widget.previousSet!.reps,
      );
    }
  }

  void _handleSetComplete(WorkoutProvider provider) {
    if (!kIsWeb) HapticFeedback.mediumImpact();
    final settings = context.read<SettingsProvider>();
    provider.toggleSetComplete(widget.exIndex, widget.setIndex,
        restDurationSeconds: settings.defaultRestSeconds);
  }

  Widget _buildInput({
    required TextEditingController controller,
    required FocusNode focusNode,
    required Function(String) onChanged,
    required Function(String) onSubmitted,
    bool isDecimal = false,
    double width = 60,
  }) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.numberWithOptions(decimal: isDecimal),
        textAlign: TextAlign.center,
        textInputAction: TextInputAction.next,
        style: AppTypography.statSmall.copyWith(fontSize: 18),
        inputFormatters: [
          if (isDecimal)
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
          else
            FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 8),
          filled: true,
          fillColor: AppColors.bgInput,
          border: OutlineInputBorder(
            borderRadius: AppRadius.roundedSm,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.roundedSm,
            borderSide: BorderSide(color: AppColors.brandPrimary, width: 2),
          ),
        ),
        onChanged: onChanged,
        onSubmitted: onSubmitted,
      ),
    );
  }

  void _showNoteDialog(BuildContext context, WorkoutProvider provider) {
    final noteController = TextEditingController(text: widget.workoutSet.note);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.roundedLg),
        title: const Text('Set Note', style: AppTypography.headlineSmall),
        content: GymInput(
          controller: noteController,
          hint: 'Enter note...',
          autofocus: true,
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          NeonButton(
            title: 'Save',
            size: ButtonSize.small,
            onPress: () {
              provider.updateSet(
                widget.exIndex,
                widget.setIndex,
                note: noteController.text.trim(),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// PHASE 4.4: WORKOUT SUMMARY SHEET
// =============================================================================

class _WorkoutSummarySheet extends StatelessWidget {
  final String elapsedTime;
  final int exerciseCount;
  final int totalSets;
  final double totalVolume;
  final List<ActiveExercise> exercises;
  final VoidCallback onFinish;
  final VoidCallback onContinue;

  const _WorkoutSummarySheet({
    required this.elapsedTime,
    required this.exerciseCount,
    required this.totalSets,
    required this.totalVolume,
    required this.exercises,
    required this.onFinish,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: Spacing.paddingCard,
      child: Column(
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
          const Icon(LucideIcons.trophy,
              size: 56, color: AppColors.brandPrimary),
          Spacing.vMd,
          const Text('Workout Complete! 🎉',
              style: AppTypography.displayMedium),
          Spacing.vSm,
          Text(
            'Great job pushing through!',
            style: AppTypography.bodyMedium
                .copyWith(color: AppColors.textSecondary),
          ),
          Spacing.vXl,
          // Stats grid
          Row(
            children: [
              Expanded(
                  child: _buildStatCard(
                      'Duration', elapsedTime, LucideIcons.clock)),
              Spacing.hMd,
              Expanded(
                  child: _buildStatCard(
                      'Exercises', '$exerciseCount', LucideIcons.dumbbell)),
            ],
          ),
          Spacing.vMd,
          Row(
            children: [
              Expanded(
                  child:
                      _buildStatCard('Sets', '$totalSets', LucideIcons.layers)),
              Spacing.hMd,
              Expanded(
                child: _buildStatCard(
                  'Volume',
                  '${(totalVolume / 1000).toStringAsFixed(1)}k kg',
                  LucideIcons.scale,
                ),
              ),
            ],
          ),
          Spacing.vXl,
          // PR section (mock)
          if (_hasPersonalRecords())
            Container(
              padding: Spacing.paddingCard,
              decoration: BoxDecoration(
                gradient: AppColors.gradientPrimary,
                borderRadius: AppRadius.roundedLg,
                border: Border.all(
                    color: AppColors.brandPrimary.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.award,
                      size: 32, color: AppColors.brandPrimary),
                  Spacing.hMd,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('NEW PERSONAL RECORD!',
                            style: AppTypography.overline),
                        Spacing.vXxs,
                        Text(
                          'Bench Press: 80kg × 8 reps',
                          style: AppTypography.titleMedium.copyWith(
                            color: AppColors.brandPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const Spacer(),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: NeonButton(
                  title: 'Continue',
                  variant: 'secondary',
                  onPress: onContinue,
                ),
              ),
              Spacing.hMd,
              Expanded(
                child: NeonButton(
                  title: 'Finish',
                  icon: LucideIcons.check,
                  onPress: onFinish,
                ),
              ),
            ],
          ),
          Spacing.vLg,
        ],
      ),
    );
  }

  bool _hasPersonalRecords() {
    // Mock: randomly show PR for demo
    return Random().nextBool();
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return GymCard(
      child: Column(
        children: [
          Icon(icon, size: 24, color: AppColors.textSecondary),
          Spacing.vSm,
          Text(value, style: AppTypography.stat),
          Spacing.vXxs,
          Text(label, style: AppTypography.caption),
        ],
      ),
    );
  }
}

// =============================================================================
// WORKOUT SETTINGS SHEET
// =============================================================================

class _WorkoutSettingsSheet extends StatelessWidget {
  final int selectedRestTime;
  final List<int> restPresets;
  final Function(int) onRestTimeChanged;

  const _WorkoutSettingsSheet({
    required this.selectedRestTime,
    required this.restPresets,
    required this.onRestTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          const Text('Workout Settings', style: AppTypography.headlineSmall),
          Spacing.vLg,
          Text(
            'Default Rest Time',
            style: AppTypography.labelMedium
                .copyWith(color: AppColors.textSecondary),
          ),
          Spacing.vMd,
          Wrap(
            spacing: 8,
            children: restPresets.map((time) {
              final isSelected = time == selectedRestTime;
              return GestureDetector(
                onTap: () => onRestTimeChanged(time),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.brandPrimary
                        : AppColors.bgCardHover,
                    borderRadius: AppRadius.roundedMd,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.brandPrimary
                          : AppColors.border,
                    ),
                  ),
                  child: Text(
                    '${time}s',
                    style: AppTypography.titleMedium.copyWith(
                      color: isSelected
                          ? AppColors.onPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
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

// =============================================================================
// EXERCISE SELECT MODAL
// =============================================================================

class ExerciseSelectModal extends StatefulWidget {
  final Function(Exercise)? onExerciseSelected;
  const ExerciseSelectModal({super.key, this.onExerciseSelected});

  @override
  State<ExerciseSelectModal> createState() => _ExerciseSelectModalState();
}

class _ExerciseSelectModalState extends State<ExerciseSelectModal> {
  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final customExercises = context
        .select<WorkoutProvider, List<Exercise>>((p) => p.customExercises);
    final allExercises = [...AppConstants.exerciseDb, ...customExercises];

    final filteredExercises = allExercises.where((ex) {
      final matchesSearch =
          ex.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter =
          _selectedFilter == 'All' || ex.muscle == _selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Padding(
            padding: Spacing.paddingScreen,
            child: Row(
              children: [
                Expanded(
                  child: GymInput(
                    hint: 'Search exercise...',
                    prefixIcon: LucideIcons.search,
                    onChanged: (v) => setState(() => _searchQuery = v),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: AppTypography.bodyMedium
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          Spacing.vMd,
          _buildFilterChips(),
          Spacing.vMd,
          Expanded(
            child: ListView.builder(
              itemCount: filteredExercises.length,
              itemBuilder: (context, index) {
                final ex = filteredExercises[index];
                return GymListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      gradient: AppColors.gradientPrimary,
                      borderRadius: AppRadius.roundedMd,
                    ),
                    child: Center(
                      child: Text(
                        ex.name.substring(0, 2).toUpperCase(),
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.brandPrimary,
                        ),
                      ),
                    ),
                  ),
                  title: ex.name,
                  subtitle: ex.muscle,
                  trailing: Icon(
                    widget.onExerciseSelected != null
                        ? LucideIcons.replace
                        : LucideIcons.plus,
                    color: AppColors.brandPrimary,
                    size: 20,
                  ),
                  onTap: () {
                    if (widget.onExerciseSelected != null) {
                      widget.onExerciseSelected!(ex);
                    } else {
                      context.read<WorkoutProvider>().addExercise(ex);
                      Navigator.pop(context);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: Spacing.paddingScreen,
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.brandPrimary : AppColors.bgCard,
                  borderRadius: AppRadius.roundedFull,
                  border: Border.all(
                    color:
                        isSelected ? AppColors.brandPrimary : AppColors.border,
                  ),
                ),
                child: Text(
                  filter,
                  style: AppTypography.labelMedium.copyWith(
                    color: isSelected
                        ? AppColors.onPrimary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
