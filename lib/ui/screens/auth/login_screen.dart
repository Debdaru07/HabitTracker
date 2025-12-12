import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/auth/auth_event.dart';
import '../../../bloc/auth/auth_state.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/spacing.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F6),
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listenWhen: (prev, curr) => prev.error != curr.error,

          listener: (context, state) {
            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error!),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },

          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // Image
                    Container(
                      width: 300,
                      height: 300,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            "https://lh3.googleusercontent.com/aida-public/AB6AXuAu2fPPZyaaFsaTzFx8bnufsygWzRTYVsBRmTpp2K62VsQHMBdOxuzaEHhE6Qh7cKpIM-jGabbX34ddMYLt1qqjL1BSicuhp-nW6G7eWejOobBuQLg2l0XfA4VP8QPsXp2VgSxLp3wLU8u47P87MuDLx_kb-kPPa-M0KkPOaelHDl-h1uoK1Bdp9CYrajifjtJEElBKq-PnSrqijjz3dSdCdMt4TR3R_53ntcMTh1CmZY3vTdcN3Jf9c2rqrSRYScLJCwm9kBF-BoYv",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Space.h24,

                    Text(
                      "Let's get started",
                      textAlign: TextAlign.center,
                      style: textTheme.headlineLarge?.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0D1B0E),
                      ),
                    ),

                    Space.h8,

                    Text(
                      "Begin your journey to building better habits today.",
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                        color: const Color(0xFF4C9A4E),
                      ),
                    ),

                    Space.h32,

                    // GOOGLE SIGN-IN BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed:
                            state.isLoading
                                ? null
                                : () {
                                  context.read<AuthBloc>().add(
                                    SignInWithGoogleRequested(),
                                  );
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF13EC1A),
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        child:
                            state.isLoading
                                ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                    strokeWidth: 2,
                                  ),
                                )
                                : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      "https://developers.google.com/identity/images/g-logo.png",
                                      width: 24,
                                    ),
                                    Space.w12,
                                    Text(
                                      "Continue with Google",
                                      style: textTheme.headlineMedium?.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF0D1B0E),
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                    ),

                    Space.h16,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
