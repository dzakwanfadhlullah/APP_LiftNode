import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../models/models.dart';

class AchievementRules {
  static final List<Achievement> defaultAchievements = [
    Achievement(
      id: 'first_workout',
      title: 'First Step',
      description: 'Completed your first workout session!',
      icon: LucideIcons.flame,
      color: Colors.orange,
    ),
    Achievement(
      id: 'early_bird',
      title: 'Early Bird',
      description: 'Completed a workout before 8:00 AM.',
      icon: LucideIcons.medal,
      color: Colors.amber,
    ),
    Achievement(
      id: 'night_owl',
      title: 'Night Owl',
      description: 'Completed a workout after 10:00 PM.',
      icon: LucideIcons.moon,
      color: Colors.indigo,
    ),
    Achievement(
      id: 'streak_3',
      title: 'Consistency',
      description: 'Achieved a 3-day workout streak!',
      icon: LucideIcons.zap,
      color: Colors.yellow,
    ),
    Achievement(
      id: 'volume_1000',
      title: 'Heavy Hitter',
      description: 'Lifted over 1,000kg in a single session!',
      icon: LucideIcons.dumbbell,
      color: Colors.blue,
    ),
    Achievement(
      id: 'marathon_10',
      title: 'Steady Progress',
      description: 'Completed 10 workout sessions.',
      icon: LucideIcons.star,
      color: Colors.purple,
    ),
  ];
}
