import 'package:equatable/equatable.dart';
import '../../models/habit_model.dart';

class HabitState extends Equatable {
  final List<HabitModel> habits;
  final bool isLoading;

  const HabitState({this.habits = const [], this.isLoading = false});

  HabitState copyWith({List<HabitModel>? habits, bool? isLoading}) {
    return HabitState(
      habits: habits ?? this.habits,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [habits, isLoading];
}
