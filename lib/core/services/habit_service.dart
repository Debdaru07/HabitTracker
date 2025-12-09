import 'package:cloud_firestore/cloud_firestore.dart';

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

  Stream<List<Map<String, dynamic>>> listenToHabits(String userId) {
    return _db
        .collection("users")
        .doc(userId)
        .collection("habits")
        .orderBy("created_at", descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> toggleCompletion(
    String userId,
    String habitId,
    DateTime date,
    bool completed,
  ) async {
    final dateKey = "${date.year}-${date.month}-${date.day}";
    final doc = _db
        .collection("users")
        .doc(userId)
        .collection("habits")
        .doc(habitId);

    await doc.update({"history.$dateKey": completed});
  }
}
