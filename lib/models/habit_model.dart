import 'package:cloud_firestore/cloud_firestore.dart';

class HabitModel {
  final String id;
  final String userId;
  final String name;
  final int iconCodePoint;
  final bool isDaily;
  final List<int> selectedDays; // 0–6 (Sun–Sat)
  final String? dailyTime;
  final String? selectiveTime;

  final bool reminderEnabled;
  final String? reminderTime;

  final DateTime createdAt;

  const HabitModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.iconCodePoint,
    required this.isDaily,
    required this.selectedDays,
    required this.dailyTime,
    required this.selectiveTime,
    required this.reminderEnabled,
    required this.reminderTime,
    required this.createdAt,
  });

  // ---------------------------------------------------------------------------
  //  Factory: From Firestore
  // ---------------------------------------------------------------------------
  factory HabitModel.fromMap(String id, Map<String, dynamic> map) {
    return HabitModel(
      id: id,
      userId: map['user_id'] ?? '',
      name: map['name'] ?? '',
      iconCodePoint: map['icon'] ?? 0,
      isDaily: map['is_daily'] ?? true,
      selectedDays: List<int>.from(map['selected_days'] ?? []),
      dailyTime: map['daily_time'],
      selectiveTime: map['selective_time'],
      reminderEnabled: map['reminder_enabled'] ?? false,
      reminderTime: map['reminder_time'],
      createdAt: (map['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // ---------------------------------------------------------------------------
  //  Serialize: To Firestore
  // ---------------------------------------------------------------------------
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'name': name,
      'icon': iconCodePoint,
      'is_daily': isDaily,
      'selected_days': selectedDays,
      'daily_time': dailyTime,
      'selective_time': selectiveTime,
      'reminder_enabled': reminderEnabled,
      'reminder_time': reminderTime,
      'created_at': createdAt,
    };
  }

  // ---------------------------------------------------------------------------
  //  CopyWith (helpful for updating)
  // ---------------------------------------------------------------------------
  HabitModel copyWith({
    String? name,
    int? iconCodePoint,
    bool? isDaily,
    List<int>? selectedDays,
    String? dailyTime,
    String? selectiveTime,
    bool? reminderEnabled,
    String? reminderTime,
  }) {
    return HabitModel(
      id: id,
      userId: userId,
      name: name ?? this.name,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      isDaily: isDaily ?? this.isDaily,
      selectedDays: selectedDays ?? this.selectedDays,
      dailyTime: dailyTime ?? this.dailyTime,
      selectiveTime: selectiveTime ?? this.selectiveTime,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      createdAt: createdAt,
    );
  }
}
