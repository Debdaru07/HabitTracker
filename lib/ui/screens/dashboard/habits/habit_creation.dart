import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/spacing.dart';
import '../../../widgets/habit_day_chip.dart';
import '../../../widgets/habit_rounded_card.dart';

class CreateHabitScreen extends StatefulWidget {
  const CreateHabitScreen({super.key});

  @override
  State<CreateHabitScreen> createState() => _CreateHabitScreenState();
}

class _CreateHabitScreenState extends State<CreateHabitScreen> {
  IconData selectedIcon = Icons.spa;
  Color selectedIconBg = const Color(0xFFEAF0EA);

  final TextEditingController nameController = TextEditingController();
  bool frequencyDaily = true;
  TimeOfDay dailyTime = const TimeOfDay(hour: 9, minute: 0);

  final List<bool> selectedWeekDays = List<bool>.filled(7, false);
  TimeOfDay selectiveTime = const TimeOfDay(hour: 9, minute: 0);

  bool reminderEnabled = true;
  TimeOfDay reminderTime = const TimeOfDay(hour: 9, minute: 0);

  final List<String> weekdayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  final List<IconData> iconChoices = [
    Icons.spa,
    Icons.water_drop,
    Icons.directions_run,
    Icons.menu_book,
    Icons.self_improvement,
    Icons.edit_note,
    Icons.local_florist,
    Icons.brightness_2,
    Icons.bakery_dining,
    Icons.sports_martial_arts,
  ];

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<TimeOfDay?> _pickTime(TimeOfDay initial) async {
    return showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: GoogleFonts.plusJakartaSansTextTheme(),
            timePickerTheme: TimePickerThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }

  void _openIconTray() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 6,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              Space.h16,
              Text(
                'Choose icon',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Space.h12,
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    iconChoices.map((ic) {
                      final isSelected = ic == selectedIcon;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIcon = ic;
                            selectedIconBg =
                                isSelected
                                    ? selectedIconBg
                                    : const Color(0xFFEAF0EA);
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 64,
                          width: 64,
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? const Color(0xFF4CAE4F).withOpacity(0.15)
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  isSelected
                                      ? const Color(0xFF4CAE4F)
                                      : Colors.grey.shade200,
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Icon(
                            ic,
                            size: 28,
                            color:
                                isSelected
                                    ? const Color(0xFF4CAE4F)
                                    : Colors.grey[700],
                          ),
                        ),
                      );
                    }).toList(),
              ),
              Space.h24,
            ],
          ),
        );
      },
    );
  }

  void _toggleWeekDay(int index) {
    setState(() => selectedWeekDays[index] = !selectedWeekDays[index]);
  }

  String _formatTimeOfDay(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minutes = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minutes $period';
  }

  void _onCreateHabit() {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name for the habit')),
      );
      return;
    }

    final selectedDays =
        List.generate(7, (i) => i).where((i) => selectedWeekDays[i]).toList();

    final habitData = {
      'icon': selectedIcon.codePoint,
      'name': name,
      'frequency': frequencyDaily ? 'daily' : 'selective',
      'daily_time': frequencyDaily ? _formatTimeOfDay(dailyTime) : null,
      'selective_days': frequencyDaily ? null : selectedDays,
      'selective_time': frequencyDaily ? null : _formatTimeOfDay(selectiveTime),
      'reminder_enabled': reminderEnabled,
      'reminder_time': reminderEnabled ? _formatTimeOfDay(reminderTime) : null,
    };

    debugPrint('Habit created: $habitData');

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Habit created')));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme();

    return Scaffold(
      backgroundColor: AppColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Create Habit',
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Space.h8,
                    Center(
                      child: GestureDetector(
                        onTap: _openIconTray,
                        child: Container(
                          height: 92,
                          width: 92,
                          decoration: BoxDecoration(
                            color: selectedIconBg,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              selectedIcon,
                              size: 40,
                              color: const Color(0xFF4CAE4F),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Space.h20,

                    Text(
                      'Name',
                      style: textTheme.headlineSmall?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Space.h8,
                    RoundedCard(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: nameController,
                        style: textTheme.bodyMedium,
                        decoration: InputDecoration(
                          hintText: 'e.g., Drink Water',
                          hintStyle: textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[500],
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    Space.h20,

                    Text(
                      'Frequency',
                      style: textTheme.headlineSmall?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Space.h12,

                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.toggleBg,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Row(
                        children: [
                          // DAILY TAB
                          Expanded(
                            child: GestureDetector(
                              onTap:
                                  () => setState(() => frequencyDaily = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      frequencyDaily
                                          ? AppColors.primary
                                          : Colors.transparent,
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                child: Text(
                                  'Daily',
                                  textAlign: TextAlign.center,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontSize: 14,
                                    fontWeight:
                                        frequencyDaily
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                    color:
                                        frequencyDaily
                                            ? Colors.white
                                            : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // WEEKLY TAB (Selective Days)
                          Expanded(
                            child: GestureDetector(
                              onTap:
                                  () => setState(() => frequencyDaily = false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      !frequencyDaily
                                          ? AppColors.primary
                                          : Colors.transparent,
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                child: Text(
                                  'Weekly',
                                  textAlign: TextAlign.center,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontSize: 14,
                                    fontWeight:
                                        !frequencyDaily
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                    color:
                                        !frequencyDaily
                                            ? Colors.white
                                            : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Space.h12,

                    if (frequencyDaily)
                      RoundedCard(
                        child: InkWell(
                          onTap: () async {
                            final picked = await _pickTime(dailyTime);
                            if (picked != null) {
                              setState(() => dailyTime = picked);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Time',
                                  style: textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      _formatTimeOfDay(dailyTime),
                                      style: textTheme.bodyLarge?.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      RoundedCard(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(7, (i) {
                                    final selected = selectedWeekDays[i];
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: DayChip(
                                        label: weekdayLabels[i],
                                        selected: selected,
                                        onTap: () => _toggleWeekDay(i),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              Space.h12,
                              InkWell(
                                onTap: () async {
                                  final picked = await _pickTime(selectiveTime);
                                  if (picked != null) {
                                    setState(() => selectiveTime = picked);
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Time',
                                      style: textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          _formatTimeOfDay(selectiveTime),
                                          style: textTheme.bodyLarge?.copyWith(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    Space.h20,

                    Text(
                      'Reminder',
                      style: textTheme.headlineSmall?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Space.h12,

                    RoundedCard(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Set a Reminder',
                                  style: textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Switch(
                                  value: reminderEnabled,
                                  activeColor: AppColors.primary,
                                  onChanged:
                                      (v) =>
                                          setState(() => reminderEnabled = v),
                                ),
                              ],
                            ),

                            const Divider(height: 12),

                            InkWell(
                              onTap:
                                  reminderEnabled
                                      ? () async {
                                        final picked = await _pickTime(
                                          reminderTime,
                                        );
                                        if (picked != null) {
                                          setState(() => reminderTime = picked);
                                        }
                                      }
                                      : null,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Time',
                                    style: textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        _formatTimeOfDay(reminderTime),
                                        style: textTheme.bodyLarge?.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 18,
                                        color:
                                            reminderEnabled
                                                ? Colors.grey
                                                : Colors.grey.shade300,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Space.h88,
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.screenBg,
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _onCreateHabit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      elevation: 6,
                      shadowColor: Colors.black.withOpacity(0.15),
                    ),
                    child: Text(
                      'Create Habit',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
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
