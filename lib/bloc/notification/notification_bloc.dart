import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../core/services/notification_service.dart';

import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService notificationService;

  NotificationBloc(this.notificationService)
    : super(const NotificationState()) {
    on<SnoozeHabit>(_onSnoozeHabit);
  }

  Future<void> _onSnoozeHabit(
    SnoozeHabit event,
    Emitter<NotificationState> emit,
  ) async {
    final now = tz.TZDateTime.now(tz.local);

    await notificationService.scheduleOneTimeNotification(
      id: '${event.habit.id}_snooze'.hashCode,
      title: 'Snoozed Habit',
      body: event.habit.name,
      scheduledTime: now.add(Duration(minutes: event.minutes)),
    );
  }
}
