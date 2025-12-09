import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class HabitCard extends StatelessWidget {
  final String title;
  final bool completed;
  final VoidCallback onTap;

  const HabitCard({
    super.key,
    required this.title,
    required this.completed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(
              completed ? Icons.check_circle : Icons.circle_outlined,
              color: completed ? AppColors.green : AppColors.grey,
            ),
            const SizedBox(width: 16),
            Text(title, style: AppTypography.body),
          ],
        ),
      ),
    );
  }
}
