import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../core/app_theme.dart';
import '../core/shared_widgets.dart';
import '../core/workout_provider.dart';
import '../models/models.dart';
import 'workout_logger_screen.dart';

class TemplateEditorScreen extends StatefulWidget {
  final WorkoutTemplate? template;
  const TemplateEditorScreen({super.key, this.template});

  @override
  State<TemplateEditorScreen> createState() => _TemplateEditorScreenState();
}

class _TemplateEditorScreenState extends State<TemplateEditorScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  List<ActiveExercise> _exercises = [];

  @override
  void initState() {
    super.initState();
    if (widget.template != null) {
      _nameController.text = widget.template!.name;
      _descController.text = widget.template!.description ?? '';
      _exercises = List.from(widget.template!.exercises);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _saveTemplate() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a template name')),
      );
      return;
    }

    if (_exercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one exercise')),
      );
      return;
    }

    final newTemplate = WorkoutTemplate(
      id: widget.template?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      description: _descController.text.trim(),
      exercises: _exercises,
      lastUsed: widget.template?.lastUsed ?? DateTime.now(),
    );

    final provider = context.read<WorkoutProvider>();
    if (widget.template == null) {
      provider.addTemplate(newTemplate);
    } else {
      provider.updateTemplate(newTemplate);
    }

    Navigator.pop(context);
  }

  void _addExercise() {
    // Show exercise picker
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgMain,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => ExerciseSelectModal(
        onExerciseSelected: (exercise) {
          setState(() {
            _exercises.add(ActiveExercise(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              exerciseId: exercise.id,
              name: exercise.name,
              muscle: exercise.muscle,
              equipment: exercise.equipment,
              sets: [WorkoutSet(id: 's1', kg: '', reps: '', completed: false)],
            ));
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      appBar: AppBar(
        title: Text(widget.template == null ? 'New Template' : 'Edit Template'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveTemplate,
            child: const Text('SAVE',
                style: TextStyle(
                    color: AppColors.brandPrimary,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: Spacing.paddingScreen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GymInput(
              controller: _nameController,
              label: 'TEMPLATE NAME',
              hint: 'e.g. Upper Body Power',
              autofocus: widget.template == null,
            ),
            Spacing.vMd,
            GymInput(
              controller: _descController,
              label: 'DESCRIPTION (OPTIONAL)',
              hint: 'Short focus of this workout',
              maxLines: 2,
            ),
            Spacing.vXl,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('EXERCISES', style: AppTypography.overline),
                TextButton.icon(
                  onPressed: _addExercise,
                  icon: const Icon(LucideIcons.plus, size: 16),
                  label: const Text('ADD'),
                ),
              ],
            ),
            Spacing.vMd,
            if (_exercises.isEmpty)
              _buildEmptyExercises()
            else
              ...List.generate(_exercises.length, (index) {
                return _buildExerciseItem(index);
              }),
            Spacing.vXl,
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyExercises() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.roundedMd,
        border: Border.all(color: AppColors.border, style: BorderStyle.solid),
      ),
      child: const Column(
        children: [
          Icon(LucideIcons.dumbbell, size: 48, color: AppColors.textDisabled),
          Spacing.vMd,
          Text('No exercises added yet', style: AppTypography.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildExerciseItem(int index) {
    final ex = _exercises[index];
    return GymCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(ex.name, style: AppTypography.titleMedium),
              ),
              IconButton(
                icon: const Icon(LucideIcons.trash2,
                    size: 18, color: AppColors.error),
                onPressed: () {
                  setState(() => _exercises.removeAt(index));
                },
              ),
            ],
          ),
          ...List.generate(ex.sets.length, (sIndex) {
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.bgCardHover,
                    child: Text('${sIndex + 1}', style: AppTypography.caption),
                  ),
                  Spacing.hMd,
                  const Expanded(
                      child:
                          Text('Normal Set', style: AppTypography.bodySmall)),
                  IconButton(
                    icon: const Icon(LucideIcons.circleMinus,
                        size: 16, color: AppColors.textMuted),
                    onPressed: () {
                      if (ex.sets.length > 1) {
                        setState(() {
                          final newSets = List<WorkoutSet>.from(ex.sets)
                            ..removeAt(sIndex);
                          _exercises[index] = ex.copyWith(sets: newSets);
                        });
                      }
                    },
                  ),
                ],
              ),
            );
          }),
          TextButton.icon(
            onPressed: () {
              setState(() {
                final newSet = WorkoutSet(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  kg: '',
                  reps: '',
                );
                final newSets = List<WorkoutSet>.from(ex.sets)..add(newSet);
                _exercises[index] = ex.copyWith(sets: newSets);
              });
            },
            icon: const Icon(LucideIcons.plus, size: 14),
            label: const Text('ADD SET', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
