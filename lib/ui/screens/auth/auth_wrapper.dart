import 'dart:developer' as console;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app_router.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/auth/auth_state.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    console.log("AuthWrapper build() called — waiting for AuthState updates");

    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (prev, curr) {
        console.log(
          "listenWhen triggered → prev.user=${prev.user?.uid}, curr.user=${curr.user?.uid}",
        );
        return prev.user != curr.user || prev.isLoading != curr.isLoading;
      },

      listener: (context, state) {
        console.log(
          "AuthWrapper listener → user=${state.user?.uid}, "
          "isFirstTime=${state.user?.isFirstTime}, "
          "isLoading=${state.isLoading}",
        );

        if (state.user == null) {
          console.log("➡ Navigating → LOGIN");
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        } else if (state.user!.isFirstTime) {
          console.log("➡ Navigating → ONBOARDING");
          Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
        } else {
          console.log("➡ Navigating → DASHBOARD");
          Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
        }
      },

      builder: (context, state) {
        console.log(
          "AuthWrapper builder → isLoading=${state.isLoading}, "
          "user=${state.user?.uid}",
        );

        if (state.isLoading) {
          console.log("Showing loading indicator...");
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        console.log("Returning empty shell while listener handles navigation");
        return const Scaffold(body: Center(child: SizedBox.shrink()));
      },
    );
  }
}
