import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import 'constants.dart'; // Required for recent exercise lookup

class WorkoutProvider with ChangeNotifier {
  bool _isActive = false;
  int? _startTime;
  String _elapsedTime = '00:00';

  int? _restStartTime;
  String _restElapsedTime = '00:00';

  List<ActiveExercise> _exercises = [];
  List<Exercise> _customExercises = [];
  List<String> _favoriteIds = [];
  List<WorkoutHistory> _history = [];
  Timer? _timer;
  String? _errorMessage;

  // Debounce timer for save operations
  Timer? _saveDebounce;
  static const _saveDebounceMs = 500;

  // Best streak tracking
  int _bestStreak = 0;

  // Undo stack for set operations (limited to last action)
  Map<String, dynamic>? _lastAction;

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
  int get bestStreak => _bestStreak;
  bool get canUndo => _lastAction != null;
  WorkoutHistory? get lastSession =>
      _history.isNotEmpty ? _history.first : null;
  List<String> get favoriteIds => List.unmodifiable(_favoriteIds);

  List<Exercise> getRecentExercises() {
    final recentNames = <String>{};
    for (var h in _history) {
      if (recentNames.length >= 20) break;
      // Reverse iterate exercises in history for correctness (first is first done)
      // but typically we want insertion order. History stores List.
      // Assuming new to old history iteration:
      for (var name in h.exercises.reversed) {
        recentNames.add(name);
      }
    }

    final allExercises = [...AppConstants.exerciseDb, ..._customExercises];
    final recentEx = <Exercise>[];

    for (var name in recentNames) {
      try {
        final ex = allExercises.firstWhere((e) => e.name == name);
        recentEx.add(ex);
      } catch (_) {
        // Exercise might have been renamed or deleted
      }
      if (recentEx.length >= 10) break;
    }
    return recentEx;
  }

  bool isFavorite(String id) => _favoriteIds.contains(id);

  void toggleFavorite(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    _saveState(); // Not debounced to instant persist UI
    notifyListeners();
  }

  int _calculateStreak() {
    if (_history.isEmpty) return 0;
    // Streak calculation: count consecutive days starting from today or yesterday
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

    // Update best streak if current exceeds it
    if (currentStreak > _bestStreak) {
      _bestStreak = currentStreak;
      _saveStateDebounced(); // Save best streak
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
      int prCount = 0;

      // Track exercise PRs (max volume per exercise)
      Map<String, double> exerciseMaxVolume = {};

      // Get previous max volumes from history
      for (var h in _history) {
        for (int i = 0; i < h.exercises.length; i++) {
          final exName = h.exercises[i];
          // Simple estimation: totalVolume / numExercises as per-exercise volume
          final estVolume = h.totalVolume / h.exercises.length;
          exerciseMaxVolume[exName] =
              (exerciseMaxVolume[exName] ?? 0) > estVolume
                  ? exerciseMaxVolume[exName]!
                  : estVolume;
        }
      }

      for (var ex in _exercises) {
        exerciseNames.add(ex.name);
        muscleGroups.add(ex.muscle); // Use actual muscle from exercise

        double exVolume = 0;
        for (var set in ex.sets) {
          if (set.completed) {
            final kg = double.tryParse(set.kg) ?? 0;
            final reps = int.tryParse(set.reps) ?? 0;
            final setVolume = kg * reps;
            totalVolume += setVolume;
            exVolume += setVolume;
          }
        }

        // Check if this is a PR for this exercise
        final prevMax = exerciseMaxVolume[ex.name] ?? 0;
        if (exVolume > prevMax && exVolume > 0) {
          prCount++;
        }
      }

      final newHistory = WorkoutHistory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Workout on ${now.day}/${now.month}',
        date: now,
        duration: duration,
        totalVolume: totalVolume,
        exercises: exerciseNames,
        muscleGroups: muscleGroups.toList(),
        prCount: prCount,
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
        if (decoded['favorites'] != null) {
          _favoriteIds = List<String>.from(decoded['favorites']);
        }
        _bestStreak = decoded['bestStreak'] ?? 0;
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
        'favorites': _favoriteIds,
        'history': _history.map((e) => e.toJson()).toList(),
        'bestStreak': _bestStreak,
      });
      await prefs.setString('workout_state', data);
    } catch (e) {
      _errorMessage = 'Failed to save workout data: $e';
      debugPrint('Error saving state: $e');
      notifyListeners();
    }
  }

  /// Debounced version of _saveState - prevents too many writes
  void _saveStateDebounced() {
    _pruneHistory(); // Ensure limits are respected
    _saveDebounce?.cancel();
    _saveDebounce = Timer(
      const Duration(milliseconds: _saveDebounceMs),
      () => _saveState(),
    );
  }

  void _pruneHistory() {
    if (_history.length > 500) {
      // Keep only the 500 most recent items
      _history = _history.sublist(0, 500);
    }
  }

  /// Undo last set action (if available)
  void undo() {
    if (_lastAction == null) return;

    final action = _lastAction!;
    final type = action['type'] as String;

    switch (type) {
      case 'updateSet':
        // Restore previous set values
        final exIndex = action['exerciseIndex'] as int;
        final setIndex = action['setIndex'] as int;
        final previousKg = action['previousKg'] as String;
        final previousReps = action['previousReps'] as String;

        if (exIndex < _exercises.length) {
          final sets = List<WorkoutSet>.from(_exercises[exIndex].sets);
          if (setIndex < sets.length) {
            sets[setIndex] = sets[setIndex].copyWith(
              kg: previousKg,
              reps: previousReps,
            );
            final newExercises = List<ActiveExercise>.from(_exercises);
            newExercises[exIndex] = _exercises[exIndex].copyWith(sets: sets);
            _exercises = newExercises;
          }
        }
        break;
      case 'toggleSet':
        // Restore previous completion state
        final exIndex = action['exerciseIndex'] as int;
        final setIndex = action['setIndex'] as int;
        final wasCompleted = action['wasCompleted'] as bool;

        if (exIndex < _exercises.length) {
          final sets = List<WorkoutSet>.from(_exercises[exIndex].sets);
          if (setIndex < sets.length) {
            sets[setIndex] = sets[setIndex].copyWith(completed: wasCompleted);
            final newExercises = List<ActiveExercise>.from(_exercises);
            newExercises[exIndex] = _exercises[exIndex].copyWith(sets: sets);
            _exercises = newExercises;
            if (!wasCompleted) {
              _restStartTime = null;
              _restElapsedTime = '00:00';
            }
          }
        }
        break;
    }

    _lastAction = null;
    _saveStateDebounced();
    notifyListeners();
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
      muscle: exercise.muscle,
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

  void updateSet(int exIndex, int setIndex,
      {String? kg, String? reps, String? rpe, SetType? type}) {
    final sets = List<WorkoutSet>.from(_exercises[exIndex].sets);
    final currentSet = sets[setIndex];

    // Record for undo
    _lastAction = {
      'type': 'updateSet',
      'exerciseIndex': exIndex,
      'setIndex': setIndex,
      'previousKg': currentSet.kg,
      'previousReps': currentSet.reps,
      'previousRpe': currentSet.rpe,
      'previousType': currentSet.type,
    };

    sets[setIndex] = currentSet.copyWith(
      kg: kg ?? currentSet.kg,
      reps: reps ?? currentSet.reps,
      rpe: rpe ?? currentSet.rpe,
      type: type ?? currentSet.type,
    );

    final newExercises = List<ActiveExercise>.from(_exercises);
    newExercises[exIndex] = _exercises[exIndex].copyWith(sets: sets);
    _exercises = newExercises;
    _saveStateDebounced();
    notifyListeners();
  }

  void removeSet(int exIndex, int setIndex) {
    if (_exercises[exIndex].sets.length <= 1) return; // Don't remove last set

    final sets = List<WorkoutSet>.from(_exercises[exIndex].sets);
    final removedSet = sets[setIndex];

    // Record for undo
    _lastAction = {
      'type': 'removeSet',
      'exerciseIndex': exIndex,
      'setIndex': setIndex,
      'removedSet': removedSet,
    };

    sets.removeAt(setIndex);

    final newExercises = List<ActiveExercise>.from(_exercises);
    newExercises[exIndex] = _exercises[exIndex].copyWith(sets: sets);
    _exercises = newExercises;
    _saveStateDebounced();
    notifyListeners();
  }

  void toggleSetComplete(int exIndex, int setIndex,
      {int? restDurationSeconds}) {
    final sets = List<WorkoutSet>.from(_exercises[exIndex].sets);
    final currentSet = sets[setIndex];
    final isNowComplete = !currentSet.completed;

    // Record for undo
    _lastAction = {
      'type': 'toggleSet',
      'exerciseIndex': exIndex,
      'setIndex': setIndex,
      'wasCompleted': currentSet.completed,
    };

    sets[setIndex] = currentSet.copyWith(completed: isNowComplete);

    final newExercises = List<ActiveExercise>.from(_exercises);
    newExercises[exIndex] = _exercises[exIndex].copyWith(sets: sets);
    _exercises = newExercises;

    if (isNowComplete) {
      _restStartTime = DateTime.now().millisecondsSinceEpoch;
      // Use config duration if provided
      if (restDurationSeconds != null) {
        // We might want to store target rest time in future for countdown
        // For now, we just start the timer (which is count up).
        // To implement countdown, we'd need _restDuration field.
      }
      if (!kIsWeb) HapticFeedback.mediumImpact();
    }

    _saveStateDebounced();
    notifyListeners();
  }

  void addCustomExercise(Exercise exercise) {
    _customExercises.add(exercise);
    _saveState();
    notifyListeners();
  }

  void deleteCustomExercise(String id) {
    _customExercises.removeWhere((ex) => ex.id == id);
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
