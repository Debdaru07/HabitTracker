import 'package:flutter/material.dart';
import 'ui/screens/auth/auth_wrapper.dart';
import 'ui/screens/auth/login_screen.dart';
import 'ui/screens/auth/onboarding_screen.dart';
import 'ui/screens/dashboard/dashboard.dart';
import 'ui/screens/dashboard/habits/habit_details.dart';
import 'ui/screens/dashboard/settings/app_settings.dart';
import 'ui/screens/dashboard/habits/habit_creation.dart';

class AppRoutes {
  static const debug = '/debug';
  static const login = '/login';
  static const onboarding = '/onboarding';
  static const dashboard = '/dashboard';
  static const createHabit = '/createHabit';
  static const habitDetails = '/habitDetails';
  static const settings = '/settings';
  static const authWrapper = '/authWrapper';

  static Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    onboarding: (context) => const OnboardingScreen(),
    dashboard: (context) => const DashboardScreen(),
    createHabit: (context) => const CreateHabitScreen(),
    habitDetails: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      return HabitDetailsScreen(
        habit: args["habit"],
        completions: args["completions"],
      );
    },
    settings: (context) => const AppSettingsScreen(),
    authWrapper: (context) => const AuthWrapper(),
  };
}
