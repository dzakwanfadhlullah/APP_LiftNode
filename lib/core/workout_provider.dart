import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class WorkoutProvider with ChangeNotifier {
  bool _isActive = false;
  int? _startTime;
  String _elapsedTime = '00:00';

  int? _restStartTime;
  String _restElapsedTime = '00:00';

  List<ActiveExercise> _exercises = [];
  List<Exercise> _customExercises = [];
  List<WorkoutHistory> _history = [];
  Timer? _timer;
  String? _errorMessage;

  WorkoutProvider() {
    _loadState();
  }

  bool get isActive => _isActive;
  String get elapsedTime => _elapsedTime;
  String get restElapsedTime => _restElapsedTime;
  bool get isResting => _restStartTime != null;
  List<ActiveExercise> get exercises => List.unmodifiable(_exercises);
  List<Exercise> get customExercises => List.unmodifiable(_customExercises);
  List<WorkoutHistory> get history => List.unmodifiable(_history);
  String? get errorMessage => _errorMessage;
  int get streak => _calculateStreak();
  WorkoutHistory? get lastSession =>
      _history.isNotEmpty ? _history.first : null;

  int _calculateStreak() {
    if (_history.isEmpty) return 0;
    // Simple streak calculation: count consecutive days starting from today or yesterday
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    var currentStreak = 0;

    // Check if the most recent workout was today or yesterday
    final firstWorkoutDate = DateTime(_history.first.date.year,
        _history.first.date.month, _history.first.date.day);

    if (firstWorkoutDate == today ||
        firstWorkoutDate == today.subtract(const Duration(days: 1))) {
      // Potentially in a streak
      Set<DateTime> uniqueDates = _history
          .map((w) => DateTime(w.date.year, w.date.month, w.date.day))
          .toSet();

      var checkDate = firstWorkoutDate;
      while (uniqueDates.contains(checkDate)) {
        currentStreak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      }
    }

    return currentStreak;
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void startWorkout() {
    _isActive = true;
    _startTime = DateTime.now().millisecondsSinceEpoch;
    _exercises = [];
    _startTimer();
    _saveState();
    notifyListeners();
  }

  void finishWorkout() {
    if (_isActive && _exercises.isNotEmpty) {
      final now = DateTime.now();
      final startTime = DateTime.fromMillisecondsSinceEpoch(
          _startTime ?? now.millisecondsSinceEpoch);
      final duration = now.difference(startTime).inMinutes;

      double totalVolume = 0;
      List<String> exerciseNames = [];
      Set<String> muscleGroups = {};

      for (var ex in _exercises) {
        exerciseNames.add(ex.name);
        for (var set in ex.sets) {
          if (set.completed) {
            final kg = double.tryParse(set.kg) ?? 0;
            final reps = int.tryParse(set.reps) ?? 0;
            totalVolume += kg * reps;
          }
        }
        // Simplified muscle group mapping
        muscleGroups.add('Full Body');
      }

      final newHistory = WorkoutHistory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Workout on ${now.day}/${now.month}',
        date: now,
        duration: duration,
        totalVolume: totalVolume,
        exercises: exerciseNames,
        muscleGroups: muscleGroups.toList(),
      );

      _history = [newHistory, ..._history];
    }

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

  void clearHistory() {
    _history = [];
    _saveState();
    notifyListeners();
  }

  void deleteHistoryEntry(String id) {
    _history = _history.where((entry) => entry.id != id).toList();
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
        if (decoded['customExercises'] != null) {
          _customExercises = (decoded['customExercises'] as List)
              .map((e) => Exercise.fromJson(e))
              .toList();
        }
        if (decoded['history'] != null) {
          _history = (decoded['history'] as List)
              .map((e) => WorkoutHistory.fromJson(e))
              .toList();
        }
        if (_isActive) _startTimer();
      }
    } catch (e) {
      _errorMessage = 'Failed to load workout data: $e';
      debugPrint('Error loading state: $e');
    }
    notifyListeners();
  }

  Future<void> _saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = jsonEncode({
        'isActive': _isActive,
        'startTime': _startTime,
        'restStartTime': _restStartTime,
        'exercises': _exercises.map((e) => e.toJson()).toList(),
        'customExercises': _customExercises.map((e) => e.toJson()).toList(),
        'history': _history.map((e) => e.toJson()).toList(),
      });
      await prefs.setString('workout_state', data);
    } catch (e) {
      _errorMessage = 'Failed to save workout data: $e';
      debugPrint('Error saving state: $e');
      notifyListeners();
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
    _exercises = [..._exercises, newActive];
    _saveState();
    notifyListeners();
  }

  void removeExercise(String id) {
    _exercises = _exercises.where((ex) => ex.id != id).toList();
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

    final newExercises = List<ActiveExercise>.from(_exercises);
    newExercises[exerciseIndex] = exercise.copyWith(
      sets: [...exercise.sets, newSet],
    );
    _exercises = newExercises;
    _saveState();
    notifyListeners();
  }

  void updateSet(int exIndex, int setIndex, {String? kg, String? reps}) {
    final sets = List<WorkoutSet>.from(_exercises[exIndex].sets);
    sets[setIndex] = sets[setIndex].copyWith(
      kg: kg ?? sets[setIndex].kg,
      reps: reps ?? sets[setIndex].reps,
    );

    final newExercises = List<ActiveExercise>.from(_exercises);
    newExercises[exIndex] = _exercises[exIndex].copyWith(sets: sets);
    _exercises = newExercises;
    _saveState();
    notifyListeners();
  }

  void toggleSetComplete(int exIndex, int setIndex) {
    final sets = List<WorkoutSet>.from(_exercises[exIndex].sets);
    final isNowComplete = !sets[setIndex].completed;

    sets[setIndex] = sets[setIndex].copyWith(completed: isNowComplete);

    final newExercises = List<ActiveExercise>.from(_exercises);
    newExercises[exIndex] = _exercises[exIndex].copyWith(sets: sets);
    _exercises = newExercises;

    if (isNowComplete) {
      _restStartTime = DateTime.now().millisecondsSinceEpoch;
      if (!kIsWeb) HapticFeedback.mediumImpact();
    }

    _saveState();
    notifyListeners();
  }

  void addCustomExercise(Exercise exercise) {
    _customExercises.add(exercise);
    _saveState();
    notifyListeners();
  }

  // Export all data as JSON string
  String getExportData() {
    final exportData = {
      'exportDate': DateTime.now().toIso8601String(),
      'appVersion': '1.2.0',
      'history': _history.map((h) => h.toJson()).toList(),
      'customExercises': _customExercises.map((e) => e.toJson()).toList(),
      'statistics': {
        'totalWorkouts': _history.length,
        'totalVolume':
            _history.fold<double>(0, (sum, h) => sum + h.totalVolume),
        'totalMinutes': _history.fold<int>(0, (sum, h) => sum + h.duration),
        'currentStreak': streak,
      },
    };
    return const JsonEncoder.withIndent('  ').convert(exportData);
  }

  // Import data from JSON string
  Future<bool> importData(String jsonData) async {
    try {
      final data = jsonDecode(jsonData) as Map<String, dynamic>;

      // Import history
      if (data['history'] != null) {
        final historyList = (data['history'] as List)
            .map((h) => WorkoutHistory.fromJson(h))
            .toList();
        _history = historyList..sort((a, b) => b.date.compareTo(a.date));
      }

      // Import custom exercises
      if (data['customExercises'] != null) {
        _customExercises = (data['customExercises'] as List)
            .map((e) => Exercise.fromJson(e))
            .toList();
      }

      await _saveState();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to import data: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
