import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class IconCircle extends StatelessWidget {
  final IconData icon;
  final bool selected;

  const IconCircle({super.key, required this.icon, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 26,
      backgroundColor: selected ? AppColors.greenLight : AppColors.white,
      child: Icon(icon, color: selected ? AppColors.green : AppColors.greyDark),
    );
  }
}
