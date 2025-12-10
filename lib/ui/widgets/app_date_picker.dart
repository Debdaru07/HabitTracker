import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

Future<DateTime?> showAppDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) {
  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate ?? DateTime(2000),
    lastDate: lastDate ?? DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
          dialogBackgroundColor: Colors.white,
          datePickerTheme: DatePickerThemeData(
            headerBackgroundColor: AppColors.primary,
            headerForegroundColor: Colors.white,
            dayForegroundColor: MaterialStateProperty.all(AppColors.primary),
            todayForegroundColor: MaterialStateProperty.all(AppColors.primary),
            todayBackgroundColor: MaterialStateProperty.all(
              AppColors.primary.withOpacity(0.1),
            ),
          ),
        ),
        child: child!,
      );
    },
  );
}
