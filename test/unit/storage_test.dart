import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker_flutter/core/workout_provider.dart';
import 'package:gym_tracker_flutter/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Storage Persistence', () {
    late WorkoutProvider provider;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    test('should save state to SharedPreferences when workout is active',
        () async {
      provider = WorkoutProvider();
      provider.startWorkout();

      // Wait for async _saveState
      await Future.delayed(const Duration(milliseconds: 100));

      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('workout_state');
      expect(data, isNotNull);

      final decoded = jsonDecode(data!);
      expect(decoded['isActive'], true);
    });

    test('should load state from SharedPreferences on initialization',
        () async {
      final mockData = jsonEncode({
        'isActive': true,
        'startTime': 1000,
        'exercises': [
          {
            'id': 'ae1',
            'exerciseId': 'ex1',
            'name': 'Bench Press',
            'sets': [
              {
                'id': 's1',
                'type': 1,
                'kg': '100',
                'reps': '10',
                'completed': true
              }
            ]
          }
        ],
        'customExercises': []
      });

      SharedPreferences.setMockInitialValues({'workout_state': mockData});

      provider = WorkoutProvider();
      // Wait for _loadState
      await Future.delayed(const Duration(milliseconds: 100));

      expect(provider.isActive, true);
      expect(provider.exercises.length, 1);
      expect(provider.exercises[0].name, 'Bench Press');
      expect(provider.exercises[0].sets[0].completed, true);
    });

    test('should persist custom exercises correctly', () async {
      provider = WorkoutProvider();
      final customEx = Exercise(
        id: 'custom_1',
        name: 'My Lift',
        muscle: 'Legs',
        equipment: 'None',
        isCustom: true,
      );

      provider.addCustomExercise(customEx);
      await Future.delayed(const Duration(milliseconds: 100));

      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('workout_state')!;
      final decoded = jsonDecode(data);
      expect(decoded['customExercises'].length, 1);
      expect(decoded['customExercises'][0]['name'], 'My Lift');
    });
  });
}
