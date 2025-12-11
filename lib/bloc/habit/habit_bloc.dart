import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'habit_event.dart';
import 'habit_state.dart';
import '../../core/services/habit_service.dart';
import '../../models/habit_model.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  final HabitService habitService;

  StreamSubscription? _habitSubscription;
  StreamSubscription? _completionSubscription;

  HabitBloc(this.habitService) : super(const HabitState()) {
    on<LoadHabits>(_onLoadHabits);
    on<HabitsUpdated>(_onHabitsUpdated);

    on<CompletionsUpdated>(_onCompletionsUpdated);

    on<AddHabit>(_onAddHabit);
    on<UpdateHabit>(_onUpdateHabit);
    on<DeleteHabit>(_onDeleteHabit);
    on<ToggleCompletion>(_onToggleCompletion);
  }

  // ---------------------------------------------------------------------------
  //  Load habits and completions (Firestore real-time listeners)
  // ---------------------------------------------------------------------------
  Future<void> _onLoadHabits(LoadHabits event, Emitter<HabitState> emit) async {
    emit(state.copyWith(isLoading: true));

    // Cancel old listeners
    await _habitSubscription?.cancel();
    await _completionSubscription?.cancel();

    // HABITS LISTENER
    _habitSubscription = habitService.listenToHabits(event.userId).listen((
      data,
    ) {
      final habits =
          data.map((map) {
            return HabitModel.fromMap(map['habit_id'], map);
          }).toList();

      add(HabitsUpdated(habits));
    });

    // COMPLETIONS LISTENER
    _completionSubscription = habitService
        .listenToCompletions(event.userId)
        .listen((data) {
          add(CompletionsUpdated(data));
        });
  }

  // Handle habit updates
  void _onHabitsUpdated(HabitsUpdated event, Emitter<HabitState> emit) {
    emit(state.copyWith(habits: event.habits, isLoading: false));
  }

  // Handle completion updates
  void _onCompletionsUpdated(
    CompletionsUpdated event,
    Emitter<HabitState> emit,
  ) {
    emit(state.copyWith(completions: event.completions));
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
  //  Toggle Completion (creates or updates daily completion entry)
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
    _completionSubscription?.cancel();
    return super.close();
  }
}
