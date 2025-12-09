import 'package:flutter/material.dart';
import 'app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
