import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/services/habit_service.dart';
import '../../core/services/notification_local.dart';
import '../../core/services/notification_service.dart';

import '../../models/habit_model.dart';
import 'habit_event.dart';
import 'habit_state.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  final HabitService habitService;
  final NotificationService notificationService;
  final NotificationLocalStore notificationStore;

  StreamSubscription? _habitSubscription;
  StreamSubscription? _completionSubscription;

  HabitBloc(this.habitService, this.notificationService, this.notificationStore)
    : super(const HabitState()) {
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
    // 🛑 SAFETY GUARD #1: invalid user
    if (event.userId.isEmpty) {
      return;
    }

    // 🛑 SAFETY GUARD #2: already listening
    if (_habitSubscription != null || _completionSubscription != null) {
      return;
    }

    emit(state.copyWith(isLoading: true));

    // HABITS LISTENER
    _habitSubscription = habitService
        .listenToHabits(event.userId)
        .listen(
          (data) {
            final habits =
                data.map((map) {
                  return HabitModel.fromMap(map['habit_id'], map);
                }).toList();
            add(HabitsUpdated(habits));
          },
          onError: (e) {
            debugPrint('Habit stream error: $e');
            emit(state.copyWith(isLoading: false));
          },
        );

    // COMPLETIONS LISTENER
    _completionSubscription = habitService
        .listenToCompletions(event.userId)
        .listen(
          (data) {
            add(CompletionsUpdated(data));
          },
          onError: (e) {
            debugPrint('Completion stream error: $e');
          },
        );
  }

  // ---------------------------------------------------------------------------
  //  Handle habit updates + notification reconciliation
  // ---------------------------------------------------------------------------
  Future<void> _onHabitsUpdated(
    HabitsUpdated event,
    Emitter<HabitState> emit,
  ) async {
    final habits = event.habits;

    // 🔔 RECONCILE LOCAL NOTIFICATIONS
    for (final habit in habits) {
      // Schedule if enabled but not scheduled locally
      if (habit.reminderEnabled && habit.reminderTime != null) {
        // Always reset when habit config changes
        await notificationService.cancelNotification(habit.id.hashCode);
        await notificationStore.markUnscheduled(habit.id);

        await _scheduleFromHabit(habit);
        await notificationStore.markScheduled(habit.id);
      }

      // Cancel if reminder turned off
      if (!habit.reminderEnabled && notificationStore.isScheduled(habit.id)) {
        await notificationService.cancelNotification(habit.id.hashCode);
        await notificationStore.markUnscheduled(habit.id);
      }
    }

    emit(state.copyWith(habits: habits, isLoading: false));
  }

  // ---------------------------------------------------------------------------
  //  Handle completion updates
  // ---------------------------------------------------------------------------
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

    // Clean up local notification state
    await notificationService.cancelNotification(event.habitId.hashCode);
    await notificationStore.clearHabit(event.habitId);
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

  // ---------------------------------------------------------------------------
  //  Helper: Schedule notification from habit
  // ---------------------------------------------------------------------------
  Future<void> _scheduleFromHabit(HabitModel habit) async {
    final timeString = habit.reminderTime;

    // 🛑 SAFETY GUARD
    if (timeString == null || !timeString.contains(':')) {
      debugPrint(
        'Skipping notification for habit ${habit.id} — invalid time: $timeString',
      );
      return;
    }

    final parts = timeString.split(':');

    final time = TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );

    if (habit.isDaily) {
      await notificationService.scheduleDailyNotification(
        id: habit.id.hashCode,
        title: 'Habit Reminder',
        body: habit.name,
        time: time,
      );
    } else {
      await _scheduleWeeklyHabit(habit);
    }
  }

  Future<void> _scheduleWeeklyHabit(HabitModel habit) async {
    final timeString = habit.reminderTime;

    // 🛑 SAFETY GUARD
    if (timeString == null || !timeString.contains(':')) {
      debugPrint(
        'Skipping notification for habit ${habit.id} — invalid time: $timeString',
      );
      return;
    }

    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    for (final day in habit.selectedDays) {
      final dartWeekday = day == 0 ? DateTime.sunday : day;

      final notificationId = '${habit.id}_$day'.hashCode; // unique per weekday

      await notificationService.scheduleWeeklyNotification(
        id: notificationId,
        title: 'Habit Reminder',
        body: habit.name,
        weekday: dartWeekday,
        hour: hour,
        minute: minute,
      );
    }
  }

  @override
  Future<void> close() {
    _habitSubscription?.cancel();
    _completionSubscription?.cancel();
    return super.close();
  }
}
