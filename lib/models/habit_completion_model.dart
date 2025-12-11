import 'package:cloud_firestore/cloud_firestore.dart';

class HabitCompletionModel {
  final String id;
  final String habitId;
  final String userId;
  final DateTime date;
  final bool completed;

  HabitCompletionModel({
    required this.id,
    required this.habitId,
    required this.userId,
    required this.date,
    required this.completed,
  });

  String get dateId => date.toIso8601String().substring(0, 10);

  factory HabitCompletionModel.fromMap(String id, Map<String, dynamic> map) {
    return HabitCompletionModel(
      id: id,
      habitId: map['habit_id'],
      userId: map['user_id'],
      date: (map['date'] as Timestamp).toDate(),
      completed: map['completed'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'habit_id': habitId,
      'user_id': userId,
      'date': date,
      'completed': completed,
      'timestamp': DateTime.now(),
    };
  }
}
