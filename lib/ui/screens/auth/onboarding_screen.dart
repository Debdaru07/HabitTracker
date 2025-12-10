import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app_router.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../bloc/auth/auth_event.dart';
import '../../../core/services/user_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/spacing.dart';
import '../../widgets/app_time_picker.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final TextEditingController nameController = TextEditingController(text: "");

  TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 0);

  List<String> goals = [
    "Build Good Habits",
    "Track My Progress",
    "Stay Accountable",
  ];

  String selectedGoal = "Build Good Habits";

  Future<void> pickTime() async {
    final picked = await showAppTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  String formatTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final suffix = t.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $suffix";
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme();

    return Scaffold(
      backgroundColor: AppColors.white,

      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TOP BAR
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, size: 24),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            "Just a few details",
                            textAlign: TextAlign.center,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 40),
                      ],
                    ),
                  ),

                  /// ILLUSTRATION
                  Center(
                    child: Container(
                      height: 140,
                      width: 140,
                      decoration: BoxDecoration(
                        color: AppColors.green.withOpacity(0.10),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.eco, color: AppColors.green, size: 64),
                    ),
                  ),

                  Space.h16,

                  /// HEADLINE
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Let's Get You Set Up",
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 32,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  /// BODY TEXT
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: Text(
                      "Tell us a bit about yourself to get started.",
                      style: textTheme.bodyLarge?.copyWith(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                  ),

                  Space.h16,

                  /// FORM FIELDS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// NAME FIELD
                        Text(
                          "Your Name",
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Space.h8,
                        TextField(
                          controller: nameController,
                          cursorColor: AppColors.primary,
                          selectionHeightStyle: BoxHeightStyle.tight,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.primary.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(28),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 18,
                            ),
                            hintText: "Enter your name",
                            hintStyle: textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),

                        Space.h24,

                        /// TIME PICKER
                        Text(
                          "When should we remind you?",
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Space.h8,

                        InkWell(
                          borderRadius: BorderRadius.circular(28),
                          onTap: pickTime,
                          child: Container(
                            height: 56,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(28),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formatTime(selectedTime),
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                ),
                                Icon(
                                  Icons.schedule,
                                  color: Colors.black.withOpacity(0.4),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Space.h24,

                        /// GOALS
                        Text(
                          "What brings you here?",
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Space.h12,

                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children:
                              goals.map((goal) {
                                final isSelected = goal == selectedGoal;

                                return GestureDetector(
                                  onTap:
                                      () => setState(() => selectedGoal = goal),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          isSelected
                                              ? AppColors.green.withOpacity(
                                                0.20,
                                              )
                                              : Colors.transparent,
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(
                                        color:
                                            isSelected
                                                ? AppColors.green.withOpacity(
                                                  0.5,
                                                )
                                                : Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Text(
                                      goal,
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color:
                                            isSelected
                                                ? AppColors.green
                                                : Colors.black.withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// BOTTOM CTA BUTTON
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: AppColors.white,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () async {
                      final currentUser = context.read<AuthBloc>().state.user;

                      if (currentUser != null) {
                        final updatedUser = currentUser.copyWith(
                          name: nameController.text.trim(),
                          goal: selectedGoal,
                          reminderTime: formatTime(selectedTime),
                          onboardingCompleted: true,
                        );

                        context.read<AuthBloc>().add(
                          UpdateUserRequested(updatedUser),
                        );

                        await UserService().createOrUpdateUser(updatedUser);
                      }

                      Navigator.pushNamed(context, AppRoutes.dashboard);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      elevation: 4,
                    ),
                    child: Text(
                      "Complete Setup",
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
