import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user_model.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createOrUpdateUser(UserModel user) async {
    await _db
        .collection("users")
        .doc(user.uid)
        .set(user.toJson(), SetOptions(merge: true));
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection("users").doc(uid).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  }
}
