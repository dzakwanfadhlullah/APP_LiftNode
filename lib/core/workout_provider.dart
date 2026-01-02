import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../models/models.dart';

class WorkoutProvider with ChangeNotifier {
  bool _isActive = false;
  int? _startTime;
  String _elapsedTime = '00:00';

  int? _restStartTime;
  String _restElapsedTime = '00:00';

  List<ActiveExercise> _exercises = [];
  Timer? _timer;

  WorkoutProvider() {
    _loadState();
  }

  bool get isActive => _isActive;
  String get elapsedTime => _elapsedTime;
  String get restElapsedTime => _restElapsedTime;
  bool get isResting => _restStartTime != null;
  List<ActiveExercise> get exercises => _exercises;

  void startWorkout() {
    _isActive = true;
    _startTime = DateTime.now().millisecondsSinceEpoch;
    _exercises = [];
    _startTimer();
    _saveState();
    notifyListeners();
  }

  void finishWorkout() {
    _isActive = false;
    _startTime = null;
    _restStartTime = null;
    _timer?.cancel();
    _elapsedTime = '00:00';
    _restElapsedTime = '00:00';
    _exercises = [];
    _saveState();
    notifyListeners();
  }

  Future<void> _loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('workout_state');
      if (data != null) {
        final decoded = jsonDecode(data);
        _isActive = decoded['isActive'] ?? false;
        _startTime = decoded['startTime'];
        _restStartTime = decoded['restStartTime'];
        if (decoded['exercises'] != null) {
          _exercises = (decoded['exercises'] as List)
              .map((e) => ActiveExercise.fromJson(e))
              .toList();
        }
        if (_isActive) _startTimer();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading state: $e');
    }
  }

  Future<void> _saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = jsonEncode({
        'isActive': _isActive,
        'startTime': _startTime,
        'restStartTime': _restStartTime,
        'exercises': _exercises.map((e) => e.toJson()).toList(),
      });
      await prefs.setString('workout_state', data);
    } catch (e) {
      debugPrint('Error saving state: $e');
    }
  }

  void stopRest() {
    _restStartTime = null;
    _restElapsedTime = '00:00';
    notifyListeners();
  }

  void toggleMinimize() {
    // UI handled via isActive check in main scaffold
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      bool changed = false;
      if (_startTime != null) {
        final now = DateTime.now().millisecondsSinceEpoch;
        final diff = (now - _startTime!) ~/ 1000;
        final m = (diff ~/ 60).toString().padLeft(2, '0');
        final s = (diff % 60).toString().padLeft(2, '0');
        _elapsedTime = '$m:$s';
        changed = true;
      }

      if (_restStartTime != null) {
        final now = DateTime.now().millisecondsSinceEpoch;
        final diff = (now - _restStartTime!) ~/ 1000;
        final m = (diff ~/ 60).toString().padLeft(2, '0');
        final s = (diff % 60).toString().padLeft(2, '0');
        _restElapsedTime = '$m:$s';
        changed = true;
      }

      if (changed) notifyListeners();
    });
  }

  void addExercise(Exercise exercise) {
    final newActive = ActiveExercise(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      exerciseId: exercise.id,
      name: exercise.name,
      sets: [WorkoutSet(id: 's1', kg: '', reps: '', completed: false)],
    );
    _exercises.add(newActive);
    _saveState();
    notifyListeners();
  }

  void addSet(int exerciseIndex) {
    final exercise = _exercises[exerciseIndex];
    final prevSet = exercise.sets.isNotEmpty ? exercise.sets.last : null;

    final newSet = WorkoutSet(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      kg: prevSet?.kg ?? '',
      reps: '',
      completed: false,
    );

    _exercises[exerciseIndex] = exercise.copyWith(
      sets: [...exercise.sets, newSet],
    );
    _saveState();
    notifyListeners();
  }

  void updateSet(int exIndex, int setIndex, {String? kg, String? reps}) {
    final sets = List<WorkoutSet>.from(_exercises[exIndex].sets);
    sets[setIndex] = sets[setIndex].copyWith(
      kg: kg ?? sets[setIndex].kg,
      reps: reps ?? sets[setIndex].reps,
    );

    _exercises[exIndex] = _exercises[exIndex].copyWith(sets: sets);
    _saveState();
    notifyListeners();
  }

  void toggleSetComplete(int exIndex, int setIndex) {
    final sets = List<WorkoutSet>.from(_exercises[exIndex].sets);
    final isNowComplete = !sets[setIndex].completed;

    sets[setIndex] = sets[setIndex].copyWith(completed: isNowComplete);
    _exercises[exIndex] = _exercises[exIndex].copyWith(sets: sets);

    if (isNowComplete) {
      _restStartTime = DateTime.now().millisecondsSinceEpoch;
      Vibration.vibrate(duration: 20);
    }

    _saveState();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
