import 'package:equatable/equatable.dart';
import '../../models/habit_completion_model.dart';
import '../../models/habit_model.dart';

class HabitState extends Equatable {
  final List<HabitModel> habits;
  final List<HabitCompletionModel> completions;
  final bool isLoading;

  const HabitState({
    this.habits = const [],
    this.completions = const [],
    this.isLoading = false,
  });

  HabitState copyWith({
    List<HabitModel>? habits,
    List<HabitCompletionModel>? completions,
    bool? isLoading,
  }) {
    return HabitState(
      habits: habits ?? this.habits,
      completions: completions ?? this.completions,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [habits, completions, isLoading];
}
