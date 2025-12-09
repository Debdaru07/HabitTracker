import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'habit_event.dart';
import 'habit_state.dart';
import '../../core/services/habit_service.dart';
import '../../models/habit_model.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  final HabitService habitService;
  StreamSubscription? _habitSubscription;

  HabitBloc(this.habitService) : super(const HabitState()) {
    on<LoadHabits>(_onLoadHabits);
    on<HabitsUpdated>(_onHabitsUpdated);

    on<AddHabit>(_onAddHabit);
    on<UpdateHabit>(_onUpdateHabit);
    on<DeleteHabit>(_onDeleteHabit);
    on<ToggleCompletion>(_onToggleCompletion);
  }

  // ---------------------------------------------------------------------------
  //  Load habits (starts a Firestore listener)
  // ---------------------------------------------------------------------------
  Future<void> _onLoadHabits(LoadHabits event, Emitter<HabitState> emit) async {
    emit(state.copyWith(isLoading: true));

    // Cancel old subscription if already listening
    await _habitSubscription?.cancel();

    _habitSubscription = habitService.listenToHabits(event.userId).listen((
      data,
    ) {
      final habits =
          data.map((map) => HabitModel.fromMap(map['habit_id'], map)).toList();

      add(HabitsUpdated(habits));
    });
  }

  void _onHabitsUpdated(HabitsUpdated event, Emitter<HabitState> emit) {
    emit(state.copyWith(habits: event.habits, isLoading: false));
  }

  // ---------------------------------------------------------------------------
  //  Add Habit
  // ---------------------------------------------------------------------------
  Future<void> _onAddHabit(AddHabit event, Emitter<HabitState> emit) async {
    await habitService.createHabit(event.userId, event.habitData);
  }

  // ---------------------------------------------------------------------------
  //  Update Habit
  // ---------------------------------------------------------------------------
  Future<void> _onUpdateHabit(
    UpdateHabit event,
    Emitter<HabitState> emit,
  ) async {
    await habitService.updateHabit(event.userId, event.habitId, event.updates);
  }

  // ---------------------------------------------------------------------------
  //  Delete Habit
  // ---------------------------------------------------------------------------
  Future<void> _onDeleteHabit(
    DeleteHabit event,
    Emitter<HabitState> emit,
  ) async {
    await habitService.deleteHabit(event.userId, event.habitId);
  }

  // ---------------------------------------------------------------------------
  //  Toggle Completion
  // ---------------------------------------------------------------------------
  Future<void> _onToggleCompletion(
    ToggleCompletion event,
    Emitter<HabitState> emit,
  ) async {
    await habitService.toggleCompletion(
      event.userId,
      event.habitId,
      event.date,
      event.completed,
    );
  }

  @override
  Future<void> close() {
    _habitSubscription?.cancel();
    return super.close();
  }
}
