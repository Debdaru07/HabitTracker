import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/spacing.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme();

    return Scaffold(
      backgroundColor: AppColors.screenBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// ===============================
                /// IMAGE
                /// ===============================
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        "https://lh3.googleusercontent.com/aida-public/AB6AXuAu2fPPZyaaFsaTzFx8bnufsygWzRTYVsBRmTpp2K62VsQHMBdOxuzaEHhE6Qh7cKpIM-jGabbX34ddMYLt1qqjL1BSicuhp-nW6G7eWejOobBuQLg2l0XfA4VP8QPsXp2VgSxLp3wLU8u47P87MuDLx_kb-kPPa-M0KkPOaelHDl-h1uoK1Bdp9CYrajifjtJEElBKq-PnSrqijjz3dSdCdMt4TR3R_53ntcMTh1CmZY3vTdcN3Jf9c2rqrSRYScLJCwm9kBF-BoYv",
                      ),
                    ),
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),

                Space.h24,

                /// ===============================
                /// TITLE + SUBTITLE
                /// ===============================
                Column(
                  children: [
                    Text(
                      "Let's get started",
                      textAlign: TextAlign.center,
                      style: textTheme.headlineLarge?.copyWith(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
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
                  ],
                ),

                Space.h32,

                /// ===============================
                /// GOOGLE SIGN-IN BUTTON
                /// ===============================
                SizedBox(
                  width: double.infinity,
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.onboarding);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.15),
                        backgroundColor: const Color(
                          0xFF13EC1A,
                        ), // Tailwind Primary
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            "https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg",
                            width: 24,
                            height: 24,
                          ),
                          Space.w12,
                          Text(
                            "Sign in with Google",
                            style: textTheme.labelLarge?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Space.h16,

                /// ===============================
                /// TERMS + POLICY TEXT
                /// ===============================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text.rich(
                    TextSpan(
                      text: "By continuing, you agree to our ",
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                      children: [
                        TextSpan(
                          text: "Terms of Service",
                          style: textTheme.bodySmall?.copyWith(
                            decoration: TextDecoration.underline,
                            color: AppColors.greenDark,
                          ),
                        ),
                        const TextSpan(text: " and "),
                        TextSpan(
                          text: "Privacy Policy",
                          style: textTheme.bodySmall?.copyWith(
                            decoration: TextDecoration.underline,
                            color: AppColors.greenDark,
                          ),
                        ),
                        const TextSpan(text: "."),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                Space.h24,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
