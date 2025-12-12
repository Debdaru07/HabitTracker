import 'package:hive/hive.dart';

class NotificationLocalStore {
  static const String _boxName = 'habit_notifications';

  Box<bool>? _box;

  Future<void> init() async {
    _box = Hive.box<bool>(_boxName);
  }

  bool isScheduled(String habitId) {
    return _box?.get(habitId, defaultValue: false) ?? false;
  }

  Future<void> markScheduled(String habitId) async {
    await _box?.put(habitId, true);
  }

  Future<void> markUnscheduled(String habitId) async {
    await _box?.put(habitId, false);
  }

  Future<void> clearHabit(String habitId) async {
    await _box?.delete(habitId);
  }
}
