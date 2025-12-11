import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/habit_completion_model.dart';

class HabitService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> createHabit(
    String userId,
    Map<String, dynamic> habitData,
  ) async {
    final doc = _db.collection("users").doc(userId).collection("habits").doc();

    await doc.set({
      ...habitData,
      "created_at": FieldValue.serverTimestamp(),
      "habit_id": doc.id,
    });

    return doc.id;
  }

  Future<void> updateHabit(
    String userId,
    String habitId,
    Map<String, dynamic> updates,
  ) async {
    await _db
        .collection("users")
        .doc(userId)
        .collection("habits")
        .doc(habitId)
        .update(updates);
  }

  Future<void> deleteHabit(String userId, String habitId) async {
    await _db
        .collection("users")
        .doc(userId)
        .collection("habits")
        .doc(habitId)
        .delete();
  }

  Stream<List<HabitCompletionModel>> listenToCompletions(String userId) {
    return FirebaseFirestore.instance
        .collection("habit_completions")
        .where("user_id", isEqualTo: userId)
        .snapshots()
        .map(
          (snap) =>
              snap.docs
                  .map((d) => HabitCompletionModel.fromMap(d.id, d.data()))
                  .toList(),
        );
  }

  Stream<List<Map<String, dynamic>>> listenToHabits(String userId) {
    return _db
        .collection("users")
        .doc(userId)
        .collection("habits")
        .orderBy("created_at", descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data["habit_id"] = doc.id; // important
            return data;
          }).toList();
        });
  }

  Future<void> toggleCompletion(
    String userId,
    String habitId,
    DateTime date,
    bool completed,
  ) async {
    final String dayId = date.toIso8601String().substring(0, 10);
    final String docId = "${habitId}_$dayId";

    await FirebaseFirestore.instance
        .collection("habit_completions")
        .doc(docId)
        .set({
          "habit_id": habitId,
          "user_id": userId,
          "completed": completed,
          "date": DateTime(date.year, date.month, date.day),
          "timestamp": DateTime.now(),
        }, SetOptions(merge: true));
  }
}
