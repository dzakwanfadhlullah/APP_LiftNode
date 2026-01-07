import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker_flutter/models/models.dart';

void main() {
  group('WorkoutSet Model', () {
    test('toJson and fromJson should be consistent', () {
      final set = WorkoutSet(
        id: 's1',
        kg: '100',
        reps: '10',
        type: SetType.normal,
        completed: true,
      );

      final json = set.toJson();
      final fromJson = WorkoutSet.fromJson(json);

      expect(fromJson.id, set.id);
      expect(fromJson.kg, set.kg);
      expect(fromJson.reps, set.reps);
      expect(fromJson.type, set.type);
      expect(fromJson.completed, set.completed);
    });

    test('copyWith should work correctly', () {
      final set = WorkoutSet(id: 's1', kg: '100', reps: '10');
      final updated = set.copyWith(kg: '110', completed: true);

      expect(updated.kg, '110');
      expect(updated.reps, '10');
      expect(updated.completed, true);
      expect(updated.id, 's1');
    });
  });

  group('Exercise Model', () {
    test('toJson and fromJson should be consistent', () {
      final ex = Exercise(
        id: 'ex1',
        name: 'Bench Press',
        muscle: 'Chest',
        equipment: 'Barbell',
        isCustom: true,
      );

      final json = ex.toJson();
      final fromJson = Exercise.fromJson(json);

      expect(fromJson.id, ex.id);
      expect(fromJson.name, ex.name);
      expect(fromJson.muscle, ex.muscle);
      expect(fromJson.equipment, ex.equipment);
      expect(fromJson.isCustom, ex.isCustom);
    });
  });

  group('ActiveExercise Model', () {
    test('toJson and fromJson should be consistent', () {
      final activeEx = ActiveExercise(
        id: 'ae1',
        exerciseId: 'ex1',
        name: 'Bench Press',
        muscle: 'Chest',
        sets: [
          WorkoutSet(id: 's1', kg: '100', reps: '10'),
        ],
      );

      final json = activeEx.toJson();
      final fromJson = ActiveExercise.fromJson(json);

      expect(fromJson.id, activeEx.id);
      expect(fromJson.exerciseId, activeEx.exerciseId);
      expect(fromJson.name, activeEx.name);
      expect(fromJson.sets.length, 1);
      expect(fromJson.sets[0].kg, '100');
    });
  });
}
