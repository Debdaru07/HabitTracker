import 'package:equatable/equatable.dart';
import '../../models/habit_model.dart';

abstract class HabitEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadHabits extends HabitEvent {
  final String userId;

  LoadHabits(this.userId);

  @override
  List<Object?> get props => [userId];
}

// Internal event for streaming updates
class HabitsUpdated extends HabitEvent {
  final List<HabitModel> habits;

  HabitsUpdated(this.habits);

  @override
  List<Object?> get props => [habits];
}

class AddHabit extends HabitEvent {
  final String userId;
  final Map<String, dynamic> habitData;

  AddHabit(this.userId, this.habitData);
}

class UpdateHabit extends HabitEvent {
  final String userId;
  final String habitId;
  final Map<String, dynamic> updates;

  UpdateHabit(this.userId, this.habitId, this.updates);
}

class DeleteHabit extends HabitEvent {
  final String userId;
  final String habitId;

  DeleteHabit(this.userId, this.habitId);
}

class ToggleCompletion extends HabitEvent {
  final String userId;
  final String habitId;
  final DateTime date;
  final bool completed;

  ToggleCompletion({
    required this.userId,
    required this.habitId,
    required this.date,
    required this.completed,
  });

  @override
  List<Object?> get props => [userId, habitId, date, completed];
}
