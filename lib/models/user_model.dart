class UserModel {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final bool isFirstTime;

  // NEW ONBOARDING FIELDS
  final String? goal;
  final String? reminderTime;
  final bool onboardingCompleted;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.isFirstTime,
    this.goal,
    this.reminderTime,
    this.onboardingCompleted = false,
  });

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "name": name,
    "email": email,
    "photoUrl": photoUrl,
    "isFirstTime": isFirstTime,
    "goal": goal,
    "reminderTime": reminderTime,
    "onboardingCompleted": onboardingCompleted,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    uid: json["uid"],
    name: json["name"],
    email: json["email"],
    photoUrl: json["photoUrl"],
    isFirstTime: json["isFirstTime"] ?? false,

    // NEW FIELDS
    goal: json["goal"],
    reminderTime: json["reminderTime"],
    onboardingCompleted: json["onboardingCompleted"] ?? false,
  );

  // Optional: Create copyWith (recommended for updates)
  UserModel copyWith({
    String? name,
    String? goal,
    String? reminderTime,
    bool? onboardingCompleted,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email,
      photoUrl: photoUrl,
      isFirstTime: isFirstTime,
      goal: goal ?? this.goal,
      reminderTime: reminderTime ?? this.reminderTime,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }
}
