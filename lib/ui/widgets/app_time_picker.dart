import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

Future<TimeOfDay?> showAppTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
}) {
  return showTimePicker(
    context: context,
    initialTime: initialTime,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.primary, // Header & active color
            onPrimary: Colors.white, // Text on header
            onSurface: Colors.black, // Body text
          ),
          timePickerTheme: TimePickerThemeData(
            backgroundColor: Colors.white,
            hourMinuteColor: AppColors.primary.withOpacity(0.1),
            hourMinuteTextColor: AppColors.primary,
            dialHandColor: AppColors.primary,
            dialBackgroundColor: Colors.white,
            dialTextColor: AppColors.primary,
            entryModeIconColor: AppColors.primary,
          ),
        ),
        child: child!,
      );
    },
  );
}
