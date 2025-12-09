import 'package:flutter/material.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isDisabled;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisabled ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled ? AppColors.grey : AppColors.green,
      ),
      child: Text(label, style: AppTypography.button),
    );
  }
}
