import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'bloc/notification/notification_bloc.dart';
import 'core/services/notification_local.dart';
import 'core/services/notification_service.dart';
import 'firebase_options.dart';
import 'app_router.dart';
import 'core/theme/app_theme.dart';

import 'core/services/auth_service.dart';
import 'core/services/habit_service.dart';

import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'bloc/habit/habit_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('habit_notifications');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create:
              (_) =>
                  AuthBloc(AuthService(), NotificationLocalStore())
                    ..add(AuthCheckRequested()),
        ),
        BlocProvider<HabitBloc>(
          create:
              (_) => HabitBloc(
                HabitService(),
                NotificationService(),
                NotificationLocalStore(),
              ),
        ),
        BlocProvider<NotificationBloc>(
          create: (_) => NotificationBloc(NotificationService()),
        ),
      ],
      child: MaterialApp(
        title: "Habit Tracker",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.authWrapper,
        routes: AppRoutes.routes,
      ),
    );
  }
}

// Source code to make the entry point as the AuthWrapper - Check the file, Will Handle it later, currently throwing error
// MaterialApp(
//   title: "Habit Tracker",
//   debugShowCheckedModeBanner: false,
//   theme: AppTheme.lightTheme,

//   // ⭐ FIX: Remove initialRoute — Use home instead
//   home: const AuthWrapper(),

//   routes: AppRoutes.routes,
// ),
