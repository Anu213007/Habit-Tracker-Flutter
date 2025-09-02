import 'package:flutter/material.dart';

enum HabitCategory {
  health,
  study,
  fitness,
  productivity,
  mentalHealth,
  others,
}

enum HabitFrequency {
  daily,
  weekly,
}

class HabitModel {
  final String id;
  final String title;
  final HabitCategory category;
  final HabitFrequency frequency;
  final DateTime? startDate;
  final String? notes;
  final DateTime createdAt;
  final int currentStreak;
  final List<DateTime> completionHistory;

  HabitModel({
    required this.id,
    required this.title,
    required this.category,
    required this.frequency,
    this.startDate,
    this.notes,
    required this.createdAt,
    this.currentStreak = 0,
    this.completionHistory = const [],
  });

  factory HabitModel.fromMap(Map<String, dynamic> map) {
    return HabitModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      category: HabitCategory.values.firstWhere(
            (e) => e.toString() == 'HabitCategory.${map['category']}',
        orElse: () => HabitCategory.others,
      ),
      frequency: HabitFrequency.values.firstWhere(
            (e) => e.toString() == 'HabitFrequency.${map['frequency']}',
        orElse: () => HabitFrequency.daily,
      ),
      startDate: map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt']),
      currentStreak: map['currentStreak'] ?? 0,
      completionHistory: map['completionHistory'] != null
          ? List<String>.from(map['completionHistory'])
          .map((d) => DateTime.parse(d))
          .toList()
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'category': category.toString().split('.').last,
      'frequency': frequency.toString().split('.').last,
      'startDate': startDate?.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'currentStreak': currentStreak,
      'completionHistory': completionHistory.map((d) => d.toIso8601String()).toList(),
    };
  }

  HabitModel copyWith({
    String? id,
    String? title,
    HabitCategory? category,
    HabitFrequency? frequency,
    DateTime? startDate,
    String? notes,
    DateTime? createdAt,
    int? currentStreak,
    List<DateTime>? completionHistory,
  }) {
    return HabitModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      currentStreak: currentStreak ?? this.currentStreak,
      completionHistory: completionHistory ?? this.completionHistory,
    );
  }

  bool isCompletedToday() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    return completionHistory.any((date) {
      final habitDate = DateTime(date.year, date.month, date.day);
      return habitDate.isAtSameMomentAs(todayDate);
    });
  }

  bool isCompletedThisWeek() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return completionHistory.any((date) {
      return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
          date.isBefore(endOfWeek.add(const Duration(days: 1)));
    });
  }

  String get categoryDisplayName {
    switch (category) {
      case HabitCategory.health:
        return 'Health';
      case HabitCategory.study:
        return 'Study';
      case HabitCategory.fitness:
        return 'Fitness';
      case HabitCategory.productivity:
        return 'Productivity';
      case HabitCategory.mentalHealth:
        return 'Mental Health';
      case HabitCategory.others:
        return 'Others';
    }
  }

  IconData get categoryIcon {
    switch (category) {
      case HabitCategory.health:
        return Icons.favorite;
      case HabitCategory.study:
        return Icons.school;
      case HabitCategory.fitness:
        return Icons.fitness_center;
      case HabitCategory.productivity:
        return Icons.work;
      case HabitCategory.mentalHealth:
        return Icons.psychology;
      case HabitCategory.others:
        return Icons.more_horiz;
    }
  }
}
