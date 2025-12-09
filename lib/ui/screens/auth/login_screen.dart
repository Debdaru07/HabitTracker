import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app_router.dart';
import '../../../core/utils/spacing.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme();

    return Scaffold(
      backgroundColor: const Color(
        0xFFF6F8F6,
      ), // background-light from Tailwind
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// =================================
                /// Illustration Image
                /// =================================
                Container(
                  width: 300,
                  height: 300,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        "https://lh3.googleusercontent.com/aida-public/AB6AXuAu2fPPZyaaFsaTzFx8bnufsygWzRTYVsBRmTpp2K62VsQHMBdOxuzaEHhE6Qh7cKpIM-jGabbX34ddMYLt1qqjL1BSicuhp-nW6G7eWejOobBuQLg2l0XfA4VP8QPsXp2VgSxLp3wLU8u47P87MuDLx_kb-kPPa-M0KkPOaelHDl-h1uoK1Bdp9CYrajifjtJEElBKq-PnSrqijjz3dSdCdMt4TR3R_53ntcMTh1CmZY3vTdcN3Jf9c2rqrSRYScLJCwm9kBF-BoYv",
                      ),
                    ),
                  ),
                ),

                Space.h24,

                /// =================================
                /// Title + Subtitle
                /// =================================
                Text(
                  "Let's get started",
                  textAlign: TextAlign.center,
                  style: textTheme.headlineLarge?.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0D1B0E),
                    height: 1.15,
                    letterSpacing: -0.5,
                  ),
                ),

                Space.h8,

                Text(
                  "Begin your journey to building better habits today.",
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF4C9A4E),
                    height: 1.4,
                  ),
                ),

                Space.h32,

                /// =================================
                /// Google Sign-In Button
                /// =================================
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.onboarding);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 6,
                      backgroundColor: const Color(
                        0xFF13EC1A,
                      ), // Tailwind primary
                      shadowColor: Colors.black.withOpacity(0.18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          999,
                        ), // rounded-full
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          "https://developers.google.com/identity/images/g-logo.png",
                          width: 24,
                          height: 24,
                        ),
                        Space.w12,
                        Flexible(
                          child: Text(
                            "Sign in with Google",
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.labelLarge?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              letterSpacing: 0.15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Space.h16,

                /// =================================
                /// Terms + Privacy text
                /// =================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text.rich(
                    TextSpan(
                      text: "By continuing, you agree to our ",
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      children: [
                        TextSpan(
                          text: "Terms of Service",
                          style: textTheme.bodySmall?.copyWith(
                            decoration: TextDecoration.underline,
                            color: const Color(0xFF13EC1A),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(text: " and "),
                        TextSpan(
                          text: "Privacy Policy",
                          style: textTheme.bodySmall?.copyWith(
                            decoration: TextDecoration.underline,
                            color: const Color(0xFF13EC1A),
                            fontWeight: FontWeight.w600,
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
