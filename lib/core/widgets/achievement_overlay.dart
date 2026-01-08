import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../../models/models.dart';
import '../shared_widgets.dart';

class AchievementOverlay extends StatelessWidget {
  final Achievement achievement;
  final VoidCallback onDismiss;

  const AchievementOverlay({
    super.key,
    required this.achievement,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: GymCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: achievement.color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    achievement.icon,
                    color: achievement.color,
                    size: 28,
                  ),
                ),
                Spacing.hMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ACHIEVEMENT UNLOCKED!',
                        style: TextStyle(
                          color: AppColors.brandPrimary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        achievement.title,
                        style: AppTypography.displaySmall,
                      ),
                      Text(
                        achievement.description,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Spacing.vMd,
            SizedBox(
              width: double.infinity,
              child: NeonButton(
                title: 'AWESOME!',
                onPress: onDismiss,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
