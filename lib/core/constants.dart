import '../models/models.dart';

class AppConstants {
  static final List<Exercise> exerciseDb = [
    Exercise(
      id: 'e1',
      name: 'Barbell Bench Press',
      muscle: 'Chest',
      equipment: 'Barbell',
    ),
    Exercise(
      id: 'e2',
      name: 'Incline Dumbbell Press',
      muscle: 'Chest',
      equipment: 'Dumbbell',
    ),
    Exercise(
      id: 'e3',
      name: 'Lat Pulldown',
      muscle: 'Back',
      equipment: 'Cable',
    ),
    Exercise(
      id: 'e4',
      name: 'Barbell Squat',
      muscle: 'Legs',
      equipment: 'Barbell',
    ),
    Exercise(
      id: 'e5',
      name: 'Romanian Deadlift',
      muscle: 'Legs',
      equipment: 'Barbell',
    ),
    Exercise(
      id: 'e6',
      name: 'Lateral Raise',
      muscle: 'Shoulders',
      equipment: 'Dumbbell',
    ),
    Exercise(
      id: 'e7',
      name: 'Tricep Pushdown',
      muscle: 'Arms',
      equipment: 'Cable',
    ),
    Exercise(
      id: 'e8',
      name: 'Bicep Curl',
      muscle: 'Arms',
      equipment: 'Dumbbell',
    ),
  ];

  static final List<Map<String, String>> mockHistory = [
    {
      'id': 'h1',
      'name': 'Push Day A',
      'date': 'Yesterday',
      'volume': '4,250 kg',
    },
    {
      'id': 'h2',
      'name': 'Pull Day B',
      'date': '3 days ago',
      'volume': '3,800 kg',
    },
    {'id': 'h3', 'name': 'Leg Day', 'date': '5 days ago', 'volume': '6,100 kg'},
  ];
}
