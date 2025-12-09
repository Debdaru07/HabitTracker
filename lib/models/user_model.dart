class UserModel {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final bool isFirstTime;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.isFirstTime,
  });

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "name": name,
    "email": email,
    "photoUrl": photoUrl,
    "isFirstTime": isFirstTime,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    uid: json["uid"],
    name: json["name"],
    email: json["email"],
    photoUrl: json["photoUrl"],
    isFirstTime: json["isFirstTime"] ?? false,
  );
}
