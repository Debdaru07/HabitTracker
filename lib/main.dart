import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/auth/auth_event.dart';
import 'bloc/habit/habit_bloc.dart';
import 'firebase_options.dart';
import 'app_router.dart';
import 'core/theme/app_theme.dart';

import 'core/services/auth_service.dart';
import 'core/services/habit_service.dart';

import 'bloc/auth/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
          create: (_) => AuthBloc(AuthService())..add(AuthCheckRequested()),
        ),
        BlocProvider<HabitBloc>(create: (_) => HabitBloc(HabitService())),
      ],
      child: MaterialApp(
        title: "Habit Tracker",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routes: AppRoutes.routes,
        initialRoute: AppRoutes.login,
      ),
    );
  }
}
