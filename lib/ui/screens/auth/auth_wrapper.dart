import 'dart:developer' as console;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_router.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/auth/auth_state.dart';
import '../../../bloc/habit/habit_bloc.dart';
import '../../../bloc/habit/habit_event.dart';
import '../../../core/theme/app_colors.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    console.log("AuthWrapper build() called — waiting for AuthState updates");

    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (prev, curr) {
        return prev.user?.uid != curr.user?.uid ||
            prev.isLoading != curr.isLoading;
      },

      listener: (context, state) {
        console.log(
          "AuthWrapper listener → user=${state.user?.uid}, "
          "isFirstTime=${state.user?.isFirstTime}, "
          "isLoading=${state.isLoading}",
        );

        if (state.user == null) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
          return;
        }

        // ✅ AUTH CONFIRMED HERE
        final uid = state.user!.uid;

        // 🔥 LOAD HABITS ONCE, SAFELY
        context.read<HabitBloc>().add(LoadHabits(uid));

        if (state.user!.isFirstTime) {
          Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
        }
      },

      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        return const Scaffold(body: Center(child: SizedBox.shrink()));
      },
    );
  }
}
