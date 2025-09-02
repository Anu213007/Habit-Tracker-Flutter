import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum MoodType {
  happy,
  neutral,
  sad,
}

class MoodModel {
  final String id;
  final String userId;
  final MoodType mood;
  final DateTime date;
  final String? notes;

  MoodModel({
    required this.id,
    required this.userId,
    required this.mood,
    required this.date,
    this.notes,
  });

  factory MoodModel.fromMap(Map<String, dynamic> map, String id) {
    return MoodModel(
      id: id,
      userId: map['userId'] ?? '',
      mood: MoodType.values.firstWhere(
        (e) => e.toString() == 'MoodType.${map['mood']}',
        orElse: () => MoodType.neutral,
      ),
      date: (map['date'] as Timestamp).toDate(),
      notes: map['notes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'mood': mood.toString().split('.').last,
      'date': Timestamp.fromDate(date),
      'notes': notes,
    };
  }

  MoodModel copyWith({
    String? id,
    String? userId,
    MoodType? mood,
    DateTime? date,
    String? notes,
  }) {
    return MoodModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mood: mood ?? this.mood,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }

  String get moodDisplayName {
    switch (mood) {
      case MoodType.happy:
        return 'Happy';
      case MoodType.neutral:
        return 'Neutral';
      case MoodType.sad:
        return 'Sad';
    }
  }

  IconData get moodIcon {
    switch (mood) {
      case MoodType.happy:
        return Icons.sentiment_satisfied;
      case MoodType.neutral:
        return Icons.sentiment_neutral;
      case MoodType.sad:
        return Icons.sentiment_dissatisfied;
    }
  }

  Color get moodColor {
    switch (mood) {
      case MoodType.happy:
        return Colors.green;
      case MoodType.neutral:
        return Colors.orange;
      case MoodType.sad:
        return Colors.blue;
    }
  }
}
