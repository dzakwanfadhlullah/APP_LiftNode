import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/shared_widgets.dart';
import '../core/workout_provider.dart';
import '../core/constants.dart';
import '../models/models.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class WorkoutLoggerScreen extends StatelessWidget {
  const WorkoutLoggerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkoutProvider>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(context, provider),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const GymTypography(
                        'Evening Pump',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (provider.exercises.isEmpty)
                        _buildEmptyState(context)
                      else
                        ...provider.exercises.asMap().entries.map((entry) {
                          return _buildExerciseCard(
                            context,
                            entry.key,
                            entry.value,
                            provider,
                          );
                        }),
                      const SizedBox(height: 12),
                      if (provider.exercises.isNotEmpty)
                        NeonButton(
                          title: 'Add Exercise',
                          variant: 'secondary',
                          icon: LucideIcons.plus,
                          onPress: () => _showExerciseModal(context),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (provider.isResting) _buildRestTimer(context, provider),
        ],
      ),
    );
  }

  Widget _buildRestTimer(BuildContext context, WorkoutProvider provider) {
    return Positioned(
      bottom: 40,
      left: MediaQuery.of(context).size.width * 0.2,
      right: MediaQuery.of(context).size.width * 0.2,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.brandPrimary,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.brandPrimary.withValues(alpha: 0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const GymTypography(
              'RESTING',
              color: Colors.black,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            GymTypography(
              provider.restElapsedTime,
              color: Colors.black,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => provider.stopRest(),
              child: const Icon(LucideIcons.x, size: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WorkoutProvider provider) {
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
          IconButton(
            icon: const Icon(
              LucideIcons.chevronDown,
              color: AppColors.textSecondary,
            ),
            onPressed: () => provider.finishWorkout(),
          ),
          Column(
            children: [
              const GymTypography(
                'ACTIVE WORKOUT',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.brandPrimary,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    LucideIcons.clock,
                    size: 14,
                    color: AppColors.brandPrimary,
                  ),
                  const SizedBox(width: 6),
                  GymTypography(
                    provider.elapsedTime,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ],
          ),
          NeonButton(
            title: 'Finish',
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            onPress: () => provider.finishWorkout(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Icon(
              LucideIcons.dumbbell,
              size: 48,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            const GymTypography(
              "Let's get moving",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            const GymTypography(
              'Add an exercise to start tracking your gains.',
              align: TextAlign.center,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 24),
            NeonButton(
              title: 'Add Exercise',
              icon: LucideIcons.plus,
              width: 200,
              onPress: () => _showExerciseModal(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard(
    BuildContext context,
    int exIndex,
    ActiveExercise ex,
    WorkoutProvider provider,
  ) {
    return GymCard(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GymTypography(
                  ex.name,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.brandPrimary,
                      ),
                ),
                const Icon(
                  LucideIcons.ellipsis,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: const Color(0xFF27272A).withValues(alpha: 0.5),
          ),
          _buildTableHeader(context),
          ...ex.sets.asMap().entries.map((setEntry) {
            return SetRow(
              exIndex: exIndex,
              setIndex: setEntry.key,
              workoutSet: setEntry.value,
            );
          }),
          InkWell(
            onTap: () => provider.addSet(exIndex),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.plus,
                    size: 16,
                    color: AppColors.brandPrimary,
                  ),
                  SizedBox(width: 8),
                  GymTypography(
                    'ADD SET',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
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

  Widget _buildTableHeader(BuildContext context) {
    return Container(
      color: AppColors.bgCardHover.withValues(alpha: 0.5),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: const Row(
        children: [
          SizedBox(
            width: 30,
            child: Center(
              child: GymTypography('SET', style: TextStyle(fontSize: 10)),
            ),
          ),
          Expanded(
            child: Center(
              child: GymTypography('PREV', style: TextStyle(fontSize: 10)),
            ),
          ),
          SizedBox(
            width: 60,
            child: Center(
              child: GymTypography('KG', style: TextStyle(fontSize: 10)),
            ),
          ),
          SizedBox(
            width: 60,
            child: Center(
              child: GymTypography('REPS', style: TextStyle(fontSize: 10)),
            ),
          ),
          SizedBox(
            width: 40,
            child: Center(
              child: GymTypography('✓', style: TextStyle(fontSize: 10)),
            ),
          ),
        ],
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
}

class ExerciseSelectModal extends StatefulWidget {
  const ExerciseSelectModal({super.key});

  @override
  State<ExerciseSelectModal> createState() => _ExerciseSelectModalState();
}

class _ExerciseSelectModalState extends State<ExerciseSelectModal> {
  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final filteredExercises = AppConstants.exerciseDb.where((ex) {
      final matchesSearch = ex.name.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    autofocus: true,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'Search exercise...',
                      hintStyle: const TextStyle(color: AppColors.textMuted),
                      prefixIcon: const Icon(
                        LucideIcons.search,
                        size: 20,
                        color: AppColors.textMuted,
                      ),
                      filled: true,
                      fillColor: AppColors.bgCard,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const GymTypography(
                    'Cancel',
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildFilterChips(),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: filteredExercises.length,
              itemBuilder: (context, index) {
                final ex = filteredExercises[index];
                return ListTile(
                  onTap: () {
                    context.read<WorkoutProvider>().addExercise(ex);
                    Navigator.pop(context);
                  },
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: GymTypography(
                        ex.name.substring(0, 2),
                        color: Colors.black,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  title: GymTypography(
                    ex.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: GymTypography(
                    ex.muscle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  trailing: const Icon(
                    LucideIcons.plus,
                    color: AppColors.brandPrimary,
                    size: 20,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All', 'Chest', 'Back', 'Legs', 'Arms', 'Shoulders'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : AppColors.bgCard,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.white : AppColors.border,
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontSize: 12,
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

class SetRow extends StatelessWidget {
  final int exIndex;
  final int setIndex;
  final WorkoutSet workoutSet;

  const SetRow({
    super.key,
    required this.exIndex,
    required this.setIndex,
    required this.workoutSet,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<WorkoutProvider>();

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: workoutSet.completed ? 0.5 : 1.0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.3)),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Center(
                child: GymTypography(
                  '${setIndex + 1}',
                  color: AppColors.textSecondary,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: GymTypography(
                  '-',
                  color: AppColors.textMuted,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
            _buildInputCell(
              value: workoutSet.kg,
              onChanged: (v) => provider.updateSet(exIndex, setIndex, kg: v),
              hint: '0',
            ),
            const SizedBox(width: 8),
            _buildInputCell(
              value: workoutSet.reps,
              onChanged: (v) => provider.updateSet(exIndex, setIndex, reps: v),
              hint: '0',
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => provider.toggleSetComplete(exIndex, setIndex),
              child: Container(
                width: 40,
                height: 32,
                decoration: BoxDecoration(
                  color: workoutSet.completed
                      ? AppColors.brandPrimary
                      : AppColors.bgCardHover,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  LucideIcons.check,
                  size: 18,
                  color: workoutSet.completed
                      ? Colors.black
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCell({
    required String value,
    required Function(String) onChanged,
    required String hint,
  }) {
    return SizedBox(
      width: 60,
      child: TextField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textMuted),
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          filled: true,
          fillColor: AppColors.bgCardHover,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none,
          ),
        ),
        controller: TextEditingController(text: value)
          ..selection = TextSelection.fromPosition(
            TextPosition(offset: value.length),
          ),
        onChanged: onChanged,
      ),
    );
  }
}
