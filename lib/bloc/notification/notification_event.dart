import '../../models/habit_model.dart';

abstract class NotificationEvent {}

class SnoozeHabit extends NotificationEvent {
  final HabitModel habit;
  final int minutes;

  SnoozeHabit(this.habit, this.minutes);
}
