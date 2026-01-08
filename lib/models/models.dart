import 'package:flutter/material.dart';

class WorkoutSet {
  final String id;
  final SetType type;
  final String kg;
  final String reps;
  final String? rpe;
  final String? note;
  final bool completed;

  WorkoutSet({
    required this.id,
    this.type = SetType.normal,
    required this.kg,
    required this.reps,
    this.rpe,
    this.note,
    this.completed = false,
  });

  WorkoutSet copyWith({
    String? id,
    SetType? type,
    String? kg,
    String? reps,
    String? rpe,
    String? note,
    bool? completed,
  }) {
    return WorkoutSet(
      id: id ?? this.id,
      type: type ?? this.type,
      kg: kg ?? this.kg,
      reps: reps ?? this.reps,
      rpe: rpe ?? this.rpe,
      note: note ?? this.note,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.index,
        'kg': kg,
        'reps': reps,
        'rpe': rpe,
        'note': note,
        'completed': completed,
      };

  factory WorkoutSet.fromJson(Map<String, dynamic> json) => WorkoutSet(
        id: json['id'],
        type: SetType.values[json['type'] ?? 1],
        kg: json['kg'],
        reps: json['reps'],
        rpe: json['rpe'],
        note: json['note'],
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
  final String muscle; // Added for muscle group tracking
  final String equipment;
  final List<WorkoutSet> sets;

  ActiveExercise({
    required this.id,
    required this.exerciseId,
    required this.name,
    required this.muscle,
    this.equipment = 'N/A', // Default for migration
    required this.sets,
  });

  ActiveExercise copyWith({
    String? id,
    String? exerciseId,
    String? name,
    String? muscle,
    String? equipment,
    List<WorkoutSet>? sets,
  }) {
    return ActiveExercise(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      name: name ?? this.name,
      muscle: muscle ?? this.muscle,
      equipment: equipment ?? this.equipment,
      sets: sets ?? this.sets,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'exerciseId': exerciseId,
        'name': name,
        'muscle': muscle,
        'equipment': equipment,
        'sets': sets.map((s) => s.toJson()).toList(),
      };

  factory ActiveExercise.fromJson(Map<String, dynamic> json) => ActiveExercise(
        id: json['id'],
        exerciseId: json['exerciseId'],
        name: json['name'],
        muscle: json['muscle'] ?? 'Full Body',
        equipment: json['equipment'] ?? 'N/A',
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
  final List<ActiveExercise>?
      details; // V1.3 Upgrade: Full details for repeat functionality

  WorkoutHistory({
    required this.id,
    required this.name,
    required this.date,
    required this.duration,
    required this.totalVolume,
    required this.exercises,
    required this.muscleGroups,
    this.prCount = 0,
    this.details,
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
        'details': details?.map((e) => e.toJson()).toList(),
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
        details: json['details'] != null
            ? (json['details'] as List)
                .map((e) => ActiveExercise.fromJson(e))
                .toList()
            : null,
      );
}

enum SetType { warmup, normal, failure }

class WorkoutTemplate {
  final String id;
  final String name;
  final String? description;
  final List<ActiveExercise> exercises;
  final DateTime lastUsed;

  WorkoutTemplate({
    required this.id,
    required this.name,
    this.description,
    required this.exercises,
    required this.lastUsed,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'exercises': exercises.map((e) => e.toJson()).toList(),
        'lastUsed': lastUsed.toIso8601String(),
      };

  factory WorkoutTemplate.fromJson(Map<String, dynamic> json) =>
      WorkoutTemplate(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        exercises: (json['exercises'] as List)
            .map((e) => ActiveExercise.fromJson(e))
            .toList(),
        lastUsed: DateTime.parse(json['lastUsed']),
      );

  WorkoutTemplate copyWith({
    String? id,
    String? name,
    String? description,
    List<ActiveExercise>? exercises,
    DateTime? lastUsed,
  }) {
    return WorkoutTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      exercises: exercises ?? this.exercises,
      lastUsed: lastUsed ?? this.lastUsed,
    );
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.unlockedAt,
  });

  bool get isUnlocked => unlockedAt != null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'icon': icon.codePoint,
        'color': color.toARGB32(),
        'unlockedAt': unlockedAt?.toIso8601String(),
      };

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        icon: IconData(json['icon'],
            fontFamily: 'LucideIcons', fontPackage: 'lucide_icons_flutter'),
        color: Color(json['color']),
        unlockedAt: json['unlockedAt'] != null
            ? DateTime.parse(json['unlockedAt'])
            : null,
      );
}
