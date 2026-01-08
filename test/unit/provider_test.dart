import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker_flutter/core/workout_provider.dart';
import 'package:gym_tracker_flutter/core/settings_provider.dart';
import 'package:gym_tracker_flutter/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WorkoutProvider', () {
    late WorkoutProvider provider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      provider = WorkoutProvider();
    });

    test('Initial state should be inactive', () {
      expect(provider.isActive, false);
      expect(provider.exercises, isEmpty);
      expect(provider.elapsedTime, '00:00');
    });

    test('startWorkout should set isActive to true', () {
      provider.startWorkout();
      expect(provider.isActive, true);
    });

    test('finishWorkout should reset state', () {
      final settings = SettingsProvider();
      provider.startWorkout();
      provider.finishWorkout(settings);
      expect(provider.isActive, false);
      expect(provider.exercises, isEmpty);
    });

    test('addExercise should add to exercises list', () {
      final ex = Exercise(
        id: 'ex1',
        name: 'Pull Up',
        muscle: 'Back',
        equipment: 'Bodyweight',
      );
      provider.addExercise(ex);
      expect(provider.exercises.length, 1);
      expect(provider.exercises[0].name, 'Pull Up');
    });

    test('removeExercise should remove by id', () {
      final ex =
          Exercise(id: 'ex1', name: 'Test', muscle: 'Back', equipment: 'None');
      provider.addExercise(ex);
      final activeId = provider.exercises[0].id;
      provider.removeExercise(activeId);
      expect(provider.exercises, isEmpty);
    });

    test('addSet should add a set to an exercise', () {
      final ex =
          Exercise(id: 'ex1', name: 'Test', muscle: 'Back', equipment: 'None');
      provider.addExercise(ex);
      provider.addSet(0);
      expect(
          provider.exercises[0].sets.length, 2); // Initial ex comes with 1 set
    });

    test('updateSet should update values', () {
      final ex =
          Exercise(id: 'ex1', name: 'Test', muscle: 'Back', equipment: 'None');
      provider.addExercise(ex);
      provider.updateSet(0, 0, kg: '50', reps: '10');
      expect(provider.exercises[0].sets[0].kg, '50');
      expect(provider.exercises[0].sets[0].reps, '10');
    });

    test('toggleSetComplete should update completion and start rest timer', () {
      final ex =
          Exercise(id: 'ex1', name: 'Test', muscle: 'Back', equipment: 'None');
      provider.addExercise(ex);
      provider.toggleSetComplete(0, 0);
      expect(provider.exercises[0].sets[0].completed, true);
      expect(provider.isResting, true);
    });
  });
}
