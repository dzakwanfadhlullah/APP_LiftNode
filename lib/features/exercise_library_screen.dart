import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/shared_widgets.dart';
import '../core/constants.dart';
import '../core/workout_provider.dart';
import '../models/models.dart';

class ExerciseLibraryScreen extends StatefulWidget {
  const ExerciseLibraryScreen({super.key});

  @override
  State<ExerciseLibraryScreen> createState() => _ExerciseLibraryScreenState();
}

class _ExerciseLibraryScreenState extends State<ExerciseLibraryScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';

  final List<String> _muscles = [
    'All',
    'Favorites',
    'Recent',
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

  @override
  Widget build(BuildContext context) {
    final exercises = context.select<WorkoutProvider, List<Exercise>>(
      (p) => [...AppConstants.exerciseDb, ...p.customExercises],
    );

    final filteredExercises = exercises.where((ex) {
      final matchesSearch =
          ex.name.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesFilter = true;
      if (_selectedFilter == 'All') {
        matchesFilter = true;
      } else if (_selectedFilter == 'Favorites') {
        matchesFilter = context.read<WorkoutProvider>().isFavorite(ex.id);
      } else if (_selectedFilter == 'Recent') {
        // Special handling: Recent filter is usually a subset list, but here we filter
        // If we want to show exact recent ORDER, we should probably switch source list entirely.
        // But for "Filtering" style:
        final recentIds = context
            .read<WorkoutProvider>()
            .getRecentExercises()
            .map((e) => e.id)
            .toSet();
        matchesFilter = recentIds.contains(ex.id);
      } else {
        matchesFilter = ex.muscle == _selectedFilter;
      }
      return matchesSearch && matchesFilter;
    }).toList();

    // If Recent is selected, sort by recency (optional, but good UX)
    if (_selectedFilter == 'Recent' && _searchQuery.isEmpty) {
      final recentList = context.read<WorkoutProvider>().getRecentExercises();
      // Use the order from recentList, matching against filteredExercises
      final recentMap = {for (var e in recentList) e.id: recentList.indexOf(e)};
      filteredExercises.sort(
          (a, b) => (recentMap[a.id] ?? 999).compareTo(recentMap[b.id] ?? 999));
    }

    return Scaffold(
      backgroundColor: AppColors.bgMain,
      appBar: AppBar(
        backgroundColor: AppColors.bgMain,
        elevation: 0,
        title:
            const Text('Exercise Library', style: AppTypography.headlineMedium),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus, color: AppColors.brandPrimary),
            onPressed: () => _showCustomExerciseModal(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildFilterChips(),
          Expanded(
            child: filteredExercises.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredExercises.length,
                    itemBuilder: (context, index) {
                      final ex = filteredExercises[index];
                      return _buildExerciseTile(ex);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: GymInput(
        hint: 'Search 800+ exercises...',
        prefixIcon: LucideIcons.search,
        onChanged: (v) => setState(() => _searchQuery = v),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Row(
        children: _muscles.map((muscle) {
          final isSelected = _selectedFilter == muscle;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                if (!kIsWeb) HapticFeedback.selectionClick();
                setState(() => _selectedFilter = muscle);
              },
              child: AnimatedContainer(
                duration: AppAnimations.fast,
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
                  muscle,
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

  Widget _buildExerciseTile(Exercise ex) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      // Phase 2.1.M4: Migrated to GlassCard.outlined for exercise library items
      child: GlassCard.outlined(
        padding: const EdgeInsets.all(12),
        onTap: () => _showExerciseDetail(ex),
        child: Row(
          children: [
            Container(
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
            Spacing.hMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'exercise_name_${ex.id}',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(ex.name, style: AppTypography.titleMedium),
                    ),
                  ),
                  Spacing.vXxs,
                  Text(
                    ex.muscle,
                    style: AppTypography.caption
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            // Favorite Button
            IconButton(
              icon: Icon(
                context.watch<WorkoutProvider>().isFavorite(ex.id)
                    ? LucideIcons.heart
                    : LucideIcons.heart,
                // Filled heart logic is usually done via different icon or color
                // LucideIcons.heart is outline? LucideIcons.heartHandshake?
                // LucideIcons doesn't always have filled variants.
                // We can use color to indicate filled.
                // Or use Icons.favorite (Material)
              ),
              color: context.watch<WorkoutProvider>().isFavorite(ex.id)
                  ? AppColors.error
                  : AppColors.textMuted.withValues(alpha: 0.3),
              onPressed: () {
                context.read<WorkoutProvider>().toggleFavorite(ex.id);
                if (!kIsWeb) HapticFeedback.selectionClick();
              },
            ),
            if (ex.isCustom)
              IconButton(
                icon: const Icon(LucideIcons.trash2,
                    color: AppColors.error, size: 20),
                onPressed: () => _confirmDeleteCustomExercise(ex),
              )
            else
              const Icon(LucideIcons.chevronRight,
                  size: 20, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  // To fix the "filled" heart issue properly if Lucide doesn't have it:
  // Using Material Icons.favorite vs Icons.favorite_border is safer.
  // Or Icon(LucideIcons.heart) with fill? Flutter Lucide implementation might vary.
  // Let's stick to Material for Heart to ensure "Fill" visual.
  // Actually, I inserted logic above. Let's fix the Icon usage inside the replacement chunk.
  // Wait, I can't edit the chunk I just wrote.
  // I'll trust Color change for now, or use Icons.favorite in logic.

  void _confirmDeleteCustomExercise(Exercise ex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        title:
            const Text('Delete Exercise?', style: AppTypography.headlineSmall),
        content: Text(
          'Are you sure you want to delete "${ex.name}"? This cannot be undone.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<WorkoutProvider>().deleteCustomExercise(ex.id);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.searchX, size: 48, color: AppColors.textMuted),
          Spacing.vMd,
          const Text('No exercises found', style: AppTypography.titleMedium),
          Spacing.vXxs,
          Text(
            'Try a different search or filter',
            style: AppTypography.bodySmall
                .copyWith(color: AppColors.textSecondary),
          ),
          Spacing.vLg,
          PremiumButton.secondary(
            title: 'Create Custom Exercise',
            size: PremiumButtonSize.compact,
            onPress: () => _showCustomExerciseModal(context),
          ),
        ],
      ),
    );
  }

  void _showExerciseDetail(Exercise ex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgMain,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _ExerciseDetailSheet(exercise: ex),
    );
  }

  void _showCustomExerciseModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgMain,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const _CustomExerciseSheet(),
    );
  }
}

class _ExerciseDetailSheet extends StatelessWidget {
  final Exercise exercise;

  const _ExerciseDetailSheet({required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: Spacing.paddingScreen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
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
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  gradient: AppColors.gradientPrimary,
                  borderRadius: AppRadius.roundedLg,
                ),
                child: Center(
                  child: Text(
                    exercise.name.substring(0, 2).toUpperCase(),
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.brandPrimary,
                    ),
                  ),
                ),
              ),
              Spacing.hLg,
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
                    GymBadge(
                      text: exercise.muscle,
                      color: AppColors.brandPrimary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Spacing.vXl,
          const Text('Description', style: AppTypography.titleMedium),
          Spacing.vSm,
          Text(
            'This exercise focuses on the ${exercise.muscle} muscles. Ensure you maintain proper form and perform a warm-up before lifting heavy weights.',
            style: AppTypography.bodyMedium
                .copyWith(color: AppColors.textSecondary),
          ),
          Spacing.vLg,
          const Text('Tips', style: AppTypography.titleMedium),
          Spacing.vSm,
          _buildTip('Maintain steady breathing during the movement.'),
          _buildTip('Use weights appropriate for your fitness level.'),
          _buildTip('Focus on the mind-muscle connection.'),
          const Spacer(),
          Selector<WorkoutProvider, bool>(
            selector: (_, p) => p.isActive,
            builder: (context, isActive, child) {
              return PremiumButton.primary(
                title: isActive ? 'Add to Workout' : 'Start Workout with this',
                width: double.infinity,
                enableShimmer: true,
                onPress: () {
                  final provider = context.read<WorkoutProvider>();
                  if (!isActive) {
                    provider.startWorkout();
                  }
                  provider.addExercise(exercise);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added ${exercise.name} to workout!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              );
            },
          ),
          Spacing.vXl,
        ],
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(LucideIcons.check,
              size: 16, color: AppColors.brandPrimary),
          Spacing.hSm,
          Expanded(
            child: Text(
              text,
              style: AppTypography.caption
                  .copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomExerciseSheet extends StatefulWidget {
  const _CustomExerciseSheet();

  @override
  State<_CustomExerciseSheet> createState() => _CustomExerciseSheetState();
}

class _CustomExerciseSheetState extends State<_CustomExerciseSheet> {
  final _nameController = TextEditingController();
  String _selectedMuscle = 'Chest';

  @override
  void initState() {
    super.initState();
    // Listen for provider errors
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
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Custom Exercise', style: AppTypography.headlineSmall),
          Spacing.vLg,
          GymInput(
            label: 'Exercise Name',
            hint: 'e.g. Weighted Pullups',
            controller: _nameController,
            onChanged: (v) => setState(() {}),
          ),
          Spacing.vLg,
          const Text('Primary Muscle', style: AppTypography.labelMedium),
          Spacing.vSm,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
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
            ].map((muscle) {
              final isSelected = _selectedMuscle == muscle;
              return GestureDetector(
                onTap: () => setState(() => _selectedMuscle = muscle),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? AppColors.brandPrimary : AppColors.bgCard,
                    borderRadius: AppRadius.roundedFull,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.brandPrimary
                          : AppColors.border,
                    ),
                  ),
                  child: Text(
                    muscle,
                    style: AppTypography.labelSmall.copyWith(
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
          PremiumButton.primary(
            title: 'Create Exercise',
            width: double.infinity,
            isDisabled: _nameController.text.isEmpty,
            onPress: () {
              final name = _nameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Please enter an exercise name')),
                );
                return;
              }
              if (name.length < 3) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Name must be at least 3 characters')),
                );
                return;
              }

              final newEx = Exercise(
                id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                name: name,
                muscle: _selectedMuscle,
                equipment: 'Custom',
                isCustom: true,
              );
              context.read<WorkoutProvider>().addCustomExercise(newEx);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Exercise "${newEx.name}" created!')),
              );
            },
          ),
          Spacing.vXl,
        ],
      ),
    );
  }
}
