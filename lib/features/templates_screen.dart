import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../core/app_theme.dart';
import '../core/shared_widgets.dart';
import '../core/workout_provider.dart';
import '../models/models.dart';
import 'template_editor_screen.dart';

class TemplatesScreen extends StatelessWidget {
  const TemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      appBar: AppBar(
        title: const Text('Workout Templates', style: AppTypography.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TemplateEditorScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<WorkoutProvider>(
        builder: (context, provider, _) {
          final templates = provider.templates;

          if (templates.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            padding: Spacing.paddingScreen,
            itemCount: templates.length,
            itemBuilder: (context, index) {
              final template = templates[index];
              return _buildTemplateCard(context, template, provider);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.fileText,
              size: 64, color: AppColors.textDisabled),
          Spacing.vMd,
          Text(
            'No templates yet',
            style: AppTypography.headlineSmall
                .copyWith(color: AppColors.textSecondary),
          ),
          Spacing.vSm,
          Text(
            'Create a template to speed up your training.',
            style:
                AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
          ),
          Spacing.vLg,
          PremiumButton.primary(
            title: 'CREATE FIRST TEMPLATE',
            enableShimmer: true,
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TemplateEditorScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(BuildContext context, WorkoutTemplate template,
      WorkoutProvider provider) {
    // Phase 2.1.M4: Migrated to GlassCard.outlined for template cards
    return GlassCard.outlined(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: () => _showTemplateActions(context, template, provider),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(template.name, style: AppTypography.titleLarge),
              ),
              const Icon(LucideIcons.ellipsisVertical,
                  size: 20, color: AppColors.textMuted),
            ],
          ),
          if (template.description != null &&
              template.description!.isNotEmpty) ...[
            Spacing.vXs,
            Text(
              template.description!,
              style: AppTypography.bodySmall
                  .copyWith(color: AppColors.textSecondary),
            ),
          ],
          Spacing.vMd,
          Wrap(
            spacing: 8,
            children: template.exercises.take(3).map((ex) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                  color: AppColors.bgCardHover,
                  borderRadius: AppRadius.roundedSm,
                ),
                child: Text(
                  ex.name,
                  style: AppTypography.labelSmall
                      .copyWith(color: AppColors.brandPrimary),
                ),
              );
            }).toList(),
          ),
          if (template.exercises.length > 3) ...[
            Spacing.vXs,
            Text(
              '+ ${template.exercises.length - 3} more exercises',
              style: AppTypography.caption,
            ),
          ],
          Spacing.vMd,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Uses: ${template.exercises.length} exercises',
                style: AppTypography.caption,
              ),
              Text(
                'Used: ${_formatDate(template.lastUsed)}',
                style: AppTypography.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showTemplateActions(BuildContext context, WorkoutTemplate template,
      WorkoutProvider provider) {
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
            Text(template.name, style: AppTypography.headlineSmall),
            Spacing.vLg,
            _buildActionItem(
              icon: LucideIcons.play,
              label: 'Start Workout',
              color: AppColors.brandPrimary,
              onTap: () {
                Navigator.pop(context); // Close sheet
                Navigator.pop(context); // Back to Home
                provider.startWorkoutFromTemplate(template);
              },
            ),
            _buildActionItem(
              icon: LucideIcons.pencil,
              label: 'Edit Template',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TemplateEditorScreen(template: template),
                  ),
                );
              },
            ),
            _buildActionItem(
              icon: LucideIcons.trash2,
              label: 'Delete Template',
              color: AppColors.error,
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(context, template, provider);
              },
            ),
            Spacing.vMd,
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.textPrimary),
      title:
          Text(label, style: TextStyle(color: color ?? AppColors.textPrimary)),
      onTap: onTap,
    );
  }

  void _confirmDelete(BuildContext context, WorkoutTemplate template,
      WorkoutProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        title: const Text('Delete Template?'),
        content: Text('Are you sure you want to delete "${template.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteTemplate(template.id);
              Navigator.pop(context);
            },
            child:
                const Text('DELETE', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
