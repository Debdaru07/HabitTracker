import 'dart:developer' as console;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_router.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/auth/auth_state.dart';
import '../../../bloc/habit/habit_bloc.dart';
import '../../../bloc/habit/habit_event.dart';
import '../../../core/theme/app_colors.dart';
import 'login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    console.log("AuthWrapper build()");

    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen:
          (prev, curr) => prev.user?.uid != curr.user?.uid && curr.user != null,

      listener: (context, state) {
        final user = state.user!;
        console.log("Auth confirmed → ${user.uid}");

        // Load habits ONCE
        context.read<HabitBloc>().add(LoadHabits(user.uid));

        if (user.isFirstTime) {
          Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
        }
      },

      builder: (context, state) {
        // 🔴 NOT LOGGED IN → SHOW LOGIN
        if (!state.isLoading && state.user == null) {
          return const LoginScreen();
        }

        // ⏳ LOADING
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        );
      },
    );
  }
}
