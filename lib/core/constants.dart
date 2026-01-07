import '../models/models.dart';

class AppConstants {
  static final List<Exercise> exerciseDb = [
    // 1. Abdominals
    Exercise(
        id: 'abs_1',
        name: 'Plank',
        muscle: 'Abdominals',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'abs_2',
        name: 'Crunches',
        muscle: 'Abdominals',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'abs_3',
        name: 'Leg Raises',
        muscle: 'Abdominals',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'abs_4',
        name: 'Russian Twists',
        muscle: 'Abdominals',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'abs_5',
        name: 'Ab Wheel Rollout',
        muscle: 'Abdominals',
        equipment: 'Wheel'),

    // 2. Abductors
    Exercise(
        id: 'abductor_1',
        name: 'Machine Abductions',
        muscle: 'Abductors',
        equipment: 'Machine'),
    Exercise(
        id: 'abductor_2',
        name: 'Seated Hip Abductions',
        muscle: 'Abductors',
        equipment: 'Machine'),
    Exercise(
        id: 'abductor_3',
        name: 'Clamshells',
        muscle: 'Abductors',
        equipment: 'Band'),
    Exercise(
        id: 'abductor_4',
        name: 'Lateral Band Walks',
        muscle: 'Abductors',
        equipment: 'Band'),
    Exercise(
        id: 'abductor_5',
        name: 'Side-Lying Leg Raises',
        muscle: 'Abductors',
        equipment: 'Bodyweight'),

    // 3. Adductors
    Exercise(
        id: 'adductor_1',
        name: 'Machine Adductions',
        muscle: 'Adductors',
        equipment: 'Machine'),
    Exercise(
        id: 'adductor_2',
        name: 'Seated Adductor Press',
        muscle: 'Adductors',
        equipment: 'Machine'),
    Exercise(
        id: 'adductor_3',
        name: 'Sumo Squat',
        muscle: 'Adductors',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'adductor_4',
        name: 'Copenhagen Plank',
        muscle: 'Adductors',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'adductor_5',
        name: 'Side-Lying Adductions',
        muscle: 'Adductors',
        equipment: 'Bodyweight'),

    // 4. Biceps
    Exercise(
        id: 'biceps_1',
        name: 'Barbell Curl',
        muscle: 'Biceps',
        equipment: 'Barbell'),
    Exercise(
        id: 'biceps_2',
        name: 'Dumbbell Curl',
        muscle: 'Biceps',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'biceps_3',
        name: 'Hammer Curl',
        muscle: 'Biceps',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'biceps_4',
        name: 'Preacher Curl',
        muscle: 'Biceps',
        equipment: 'Barbell'),
    Exercise(
        id: 'biceps_5',
        name: 'Concentration Curl',
        muscle: 'Biceps',
        equipment: 'Dumbbell'),

    // 5. Calves
    Exercise(
        id: 'calves_1',
        name: 'Standing Calf Raise',
        muscle: 'Calves',
        equipment: 'Machine'),
    Exercise(
        id: 'calves_2',
        name: 'Seated Calf Raise',
        muscle: 'Calves',
        equipment: 'Machine'),
    Exercise(
        id: 'calves_3',
        name: 'Leg Press Calf Raise',
        muscle: 'Calves',
        equipment: 'Machine'),
    Exercise(
        id: 'calves_4',
        name: 'Donkey Calf Raise',
        muscle: 'Calves',
        equipment: 'Machine'),
    Exercise(
        id: 'calves_5', name: 'Jump Rope', muscle: 'Calves', equipment: 'Rope'),

    // 6. Cardio
    Exercise(
        id: 'cardio_1',
        name: 'Running',
        muscle: 'Cardio',
        equipment: 'Treadmill'),
    Exercise(
        id: 'cardio_2', name: 'Cycling', muscle: 'Cardio', equipment: 'Bike'),
    Exercise(
        id: 'cardio_3', name: 'Swimming', muscle: 'Cardio', equipment: 'Pool'),
    Exercise(
        id: 'cardio_4', name: 'Rowing', muscle: 'Cardio', equipment: 'Machine'),
    Exercise(
        id: 'cardio_5',
        name: 'Stair Climber',
        muscle: 'Cardio',
        equipment: 'Machine'),

    // 7. Chest
    Exercise(
        id: 'chest_1',
        name: 'Barbell Bench Press',
        muscle: 'Chest',
        equipment: 'Barbell'),
    Exercise(
        id: 'chest_2',
        name: 'Incline Dumbbell Press',
        muscle: 'Chest',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'chest_3',
        name: 'Decline Bench Press',
        muscle: 'Chest',
        equipment: 'Barbell'),
    Exercise(
        id: 'chest_4',
        name: 'Chest Flys',
        muscle: 'Chest',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'chest_5',
        name: 'Pushups',
        muscle: 'Chest',
        equipment: 'Bodyweight'),

    // 8. Forearms
    Exercise(
        id: 'forearms_1',
        name: 'Wrist Curls',
        muscle: 'Forearms',
        equipment: 'Barbell'),
    Exercise(
        id: 'forearms_2',
        name: 'Reverse Wrist Curls',
        muscle: 'Forearms',
        equipment: 'Barbell'),
    Exercise(
        id: 'forearms_3',
        name: 'Farmer\'s Walk',
        muscle: 'Forearms',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'forearms_4',
        name: 'Dead Hangs',
        muscle: 'Forearms',
        equipment: 'Bar'),
    Exercise(
        id: 'forearms_5',
        name: 'Reverse Curls',
        muscle: 'Forearms',
        equipment: 'Barbell'),

    // 9. Full Body
    Exercise(
        id: 'fullbody_1',
        name: 'Burpees',
        muscle: 'Full Body',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'fullbody_2',
        name: 'Clean and Press',
        muscle: 'Full Body',
        equipment: 'Barbell'),
    Exercise(
        id: 'fullbody_3',
        name: 'Snatch',
        muscle: 'Full Body',
        equipment: 'Barbell'),
    Exercise(
        id: 'fullbody_4',
        name: 'Kettlebell Swings',
        muscle: 'Full Body',
        equipment: 'Kettlebell'),
    Exercise(
        id: 'fullbody_5',
        name: 'Thrusters',
        muscle: 'Full Body',
        equipment: 'Barbell'),

    // 10. Glutes
    Exercise(
        id: 'glutes_1',
        name: 'Hip Thrusts',
        muscle: 'Glutes',
        equipment: 'Barbell'),
    Exercise(
        id: 'glutes_2',
        name: 'Glute Bridges',
        muscle: 'Glutes',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'glutes_3',
        name: 'Cable Kickbacks',
        muscle: 'Glutes',
        equipment: 'Cable'),
    Exercise(
        id: 'glutes_4',
        name: 'Bulgarian Split Squats',
        muscle: 'Glutes',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'glutes_5',
        name: 'Glute Kickbacks (Machine)',
        muscle: 'Glutes',
        equipment: 'Machine'),

    // 11. Hamstrings
    Exercise(
        id: 'hamstrings_1',
        name: 'Deadlifts',
        muscle: 'Hamstrings',
        equipment: 'Barbell'),
    Exercise(
        id: 'hamstrings_2',
        name: 'Lying Leg Curls',
        muscle: 'Hamstrings',
        equipment: 'Machine'),
    Exercise(
        id: 'hamstrings_3',
        name: 'Good Mornings',
        muscle: 'Hamstrings',
        equipment: 'Barbell'),
    Exercise(
        id: 'hamstrings_4',
        name: 'Stiff-Legged Deadlifts',
        muscle: 'Hamstrings',
        equipment: 'Barbell'),
    Exercise(
        id: 'hamstrings_5',
        name: 'Glute Ham Raises',
        muscle: 'Hamstrings',
        equipment: 'Bodyweight'),

    // 12. Lats
    Exercise(
        id: 'lats_1',
        name: 'Lat Pulldowns',
        muscle: 'Lats',
        equipment: 'Cable'),
    Exercise(id: 'lats_2', name: 'Pullups', muscle: 'Lats', equipment: 'Bar'),
    Exercise(
        id: 'lats_3',
        name: 'Barbell Rows',
        muscle: 'Lats',
        equipment: 'Barbell'),
    Exercise(
        id: 'lats_4',
        name: 'One-Arm Dumbbell Rows',
        muscle: 'Lats',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'lats_5', name: 'T-Bar Rows', muscle: 'Lats', equipment: 'Barbell'),

    // 13. Lower Back
    Exercise(
        id: 'lowerback_1',
        name: 'Hyperextensions',
        muscle: 'Lower Back',
        equipment: 'Machine'),
    Exercise(
        id: 'lowerback_2',
        name: 'Back Extensions',
        muscle: 'Lower Back',
        equipment: 'Machine'),
    Exercise(
        id: 'lowerback_3',
        name: 'Superman',
        muscle: 'Lower Back',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'lowerback_4',
        name: 'Bird-Dog',
        muscle: 'Lower Back',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'lowerback_5',
        name: 'Rack Pulls',
        muscle: 'Lower Back',
        equipment: 'Barbell'),

    // 14. Neck
    Exercise(
        id: 'neck_1',
        name: 'Neck Curls',
        muscle: 'Neck',
        equipment: 'Weight Plate'),
    Exercise(
        id: 'neck_2',
        name: 'Neck Extensions',
        muscle: 'Neck',
        equipment: 'Weight Plate'),
    Exercise(
        id: 'neck_3',
        name: 'Lateral Neck Flexion',
        muscle: 'Neck',
        equipment: 'Weight Plate'),
    Exercise(
        id: 'neck_4',
        name: 'Neck Iso-Hold',
        muscle: 'Neck',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'neck_5',
        name: 'Neck Harness Pulls',
        muscle: 'Neck',
        equipment: 'Harness'),

    // 15. Quadriceps
    Exercise(
        id: 'quads_1',
        name: 'Barbell Squats',
        muscle: 'Quadriceps',
        equipment: 'Barbell'),
    Exercise(
        id: 'quads_2',
        name: 'Leg Press',
        muscle: 'Quadriceps',
        equipment: 'Machine'),
    Exercise(
        id: 'quads_3',
        name: 'Leg Extensions',
        muscle: 'Quadriceps',
        equipment: 'Machine'),
    Exercise(
        id: 'quads_4',
        name: 'Walking Lunges',
        muscle: 'Quadriceps',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'quads_5',
        name: 'Hack Squats',
        muscle: 'Quadriceps',
        equipment: 'Machine'),

    // 16. Shoulders
    Exercise(
        id: 'shoulders_1',
        name: 'Overhead Press',
        muscle: 'Shoulders',
        equipment: 'Barbell'),
    Exercise(
        id: 'shoulders_2',
        name: 'Lateral Raises',
        muscle: 'Shoulders',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'shoulders_3',
        name: 'Front Raises',
        muscle: 'Shoulders',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'shoulders_4',
        name: 'Rear Delt Flys',
        muscle: 'Shoulders',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'shoulders_5',
        name: 'Arnold Press',
        muscle: 'Shoulders',
        equipment: 'Dumbbell'),

    // 17. Traps
    Exercise(
        id: 'traps_1',
        name: 'Barbell Shrugs',
        muscle: 'Traps',
        equipment: 'Barbell'),
    Exercise(
        id: 'traps_2',
        name: 'Dumbbell Shrugs',
        muscle: 'Traps',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'traps_3',
        name: 'Upright Rows',
        muscle: 'Traps',
        equipment: 'Barbell'),
    Exercise(
        id: 'traps_4', name: 'Face Pulls', muscle: 'Traps', equipment: 'Cable'),
    Exercise(
        id: 'traps_5',
        name: 'Farmer\'s Carry',
        muscle: 'Traps',
        equipment: 'Dumbbell'),

    // 18. Triceps
    Exercise(
        id: 'triceps_1',
        name: 'Tricep Pushdowns',
        muscle: 'Triceps',
        equipment: 'Cable'),
    Exercise(
        id: 'triceps_2',
        name: 'Skullcrushers',
        muscle: 'Triceps',
        equipment: 'Barbell'),
    Exercise(
        id: 'triceps_3',
        name: 'Dips',
        muscle: 'Triceps',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'triceps_4',
        name: 'Overhead Extension',
        muscle: 'Triceps',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'triceps_5',
        name: 'Close-Grip Bench Press',
        muscle: 'Triceps',
        equipment: 'Barbell'),

    // 19. Upper Back
    Exercise(
        id: 'upperback_1',
        name: 'Rear Delt Machine Flys',
        muscle: 'Upper Back',
        equipment: 'Machine'),
    Exercise(
        id: 'upperback_2',
        name: 'Face Pulls (Upper Back Focus)',
        muscle: 'Upper Back',
        equipment: 'Cable'),
    Exercise(
        id: 'upperback_3',
        name: 'Chest Supported Rows',
        muscle: 'Upper Back',
        equipment: 'Dumbbell'),
    Exercise(
        id: 'upperback_4',
        name: 'Pendlay Rows',
        muscle: 'Upper Back',
        equipment: 'Barbell'),
    Exercise(
        id: 'upperback_5',
        name: 'Reverse Flys',
        muscle: 'Upper Back',
        equipment: 'Cable'),

    // 20. Obliques
    Exercise(
        id: 'obliques_1',
        name: 'Side Plank',
        muscle: 'Obliques',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'obliques_2',
        name: 'Bicycle Crunches',
        muscle: 'Obliques',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'obliques_3',
        name: 'Woodchoppers',
        muscle: 'Obliques',
        equipment: 'Cable'),
    Exercise(
        id: 'obliques_4',
        name: 'Heel Touches',
        muscle: 'Obliques',
        equipment: 'Bodyweight'),
    Exercise(
        id: 'obliques_5',
        name: 'Side Crunches',
        muscle: 'Obliques',
        equipment: 'Bodyweight'),
  ];
}
