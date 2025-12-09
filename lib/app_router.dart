import 'package:flutter/material.dart';
import 'ui/screens/auth/login_screen.dart';
import 'ui/screens/auth/onboarding_screen.dart';
import 'ui/screens/dashboard/dashboard.dart';
import 'ui/screens/dashboard/habits/habit_creation.dart';
import 'ui/screens/dashboard/habits/habit_details.dart';
import 'ui/screens/dashboard/settings/app_settings.dart';

class AppRoutes {
  static const login = '/login';
  static const onboarding = '/onboarding';
  static const dashboard = '/dashboard';
  static const createHabit = '/createHabit';
  static const habitDetails = '/habitDetails';
  static const settings = '/settings';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    onboarding: (context) => const OnboardingScreen(),
    dashboard: (context) => const DashboardScreen(),
    // createHabit: (context) => const HabitCreationScreen(),
    // habitDetails: (context) => const HabitDetailsScreen(),
    settings: (context) => const AppSettingsScreen(),
  };
}
