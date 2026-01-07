class WorkoutSet {
  final String id;
  final SetType type;
  final String kg;
  final String reps;
  final String? rpe;
  final bool completed;

  WorkoutSet({
    required this.id,
    this.type = SetType.normal,
    required this.kg,
    required this.reps,
    this.rpe,
    this.completed = false,
  });

  WorkoutSet copyWith({
    String? id,
    SetType? type,
    String? kg,
    String? reps,
    String? rpe,
    bool? completed,
  }) {
    return WorkoutSet(
      id: id ?? this.id,
      type: type ?? this.type,
      kg: kg ?? this.kg,
      reps: reps ?? this.reps,
      rpe: rpe ?? this.rpe,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.index,
        'kg': kg,
        'reps': reps,
        'rpe': rpe,
        'completed': completed,
      };

  factory WorkoutSet.fromJson(Map<String, dynamic> json) => WorkoutSet(
        id: json['id'],
        type: SetType.values[json['type'] ?? 1],
        kg: json['kg'],
        reps: json['reps'],
        rpe: json['rpe'],
        completed: json['completed'] ?? false,
      );
}

class Exercise {
  final String id;
  final String name;
  final String muscle;
  final String equipment;
  final bool isCustom;

  Exercise({
    required this.id,
    required this.name,
    required this.muscle,
    required this.equipment,
    this.isCustom = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'muscle': muscle,
        'equipment': equipment,
        'isCustom': isCustom,
      };

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        muscle: json['muscle'] ?? '',
        equipment: json['equipment'] ?? '',
        isCustom: json['isCustom'] ?? false,
      );
}

class ActiveExercise {
  final String id;
  final String exerciseId;
  final String name;
  final List<WorkoutSet> sets;

  ActiveExercise({
    required this.id,
    required this.exerciseId,
    required this.name,
    required this.sets,
  });

  ActiveExercise copyWith({
    String? id,
    String? exerciseId,
    String? name,
    List<WorkoutSet>? sets,
  }) {
    return ActiveExercise(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      name: name ?? this.name,
      sets: sets ?? this.sets,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'exerciseId': exerciseId,
        'name': name,
        'sets': sets.map((s) => s.toJson()).toList(),
      };

  factory ActiveExercise.fromJson(Map<String, dynamic> json) => ActiveExercise(
        id: json['id'],
        exerciseId: json['exerciseId'],
        name: json['name'],
        sets:
            (json['sets'] as List).map((s) => WorkoutSet.fromJson(s)).toList(),
      );
}

class WorkoutHistory {
  final String id;
  final String name;
  final DateTime date;
  final int duration;
  final double totalVolume;
  final List<String> exercises;
  final List<String> muscleGroups;
  final int prCount;

  WorkoutHistory({
    required this.id,
    required this.name,
    required this.date,
    required this.duration,
    required this.totalVolume,
    required this.exercises,
    required this.muscleGroups,
    this.prCount = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'date': date.toIso8601String(),
        'duration': duration,
        'totalVolume': totalVolume,
        'exercises': exercises,
        'muscleGroups': muscleGroups,
        'prCount': prCount,
      };

  factory WorkoutHistory.fromJson(Map<String, dynamic> json) => WorkoutHistory(
        id: json['id'],
        name: json['name'],
        date: DateTime.parse(json['date']),
        duration: json['duration'],
        totalVolume: (json['totalVolume'] as num).toDouble(),
        exercises: List<String>.from(json['exercises']),
        muscleGroups: List<String>.from(json['muscleGroups']),
        prCount: json['prCount'] ?? 0,
      );
}

enum SetType { warmup, normal, failure }
