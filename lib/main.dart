import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grow_habit/firebase_options.dart';
import 'app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Habit Tracker",
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme,
      routes: AppRoutes.routes,
      initialRoute: AppRoutes.login,
    );
  }
}
