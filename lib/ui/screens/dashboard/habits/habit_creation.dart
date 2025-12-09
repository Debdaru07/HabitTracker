import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/spacing.dart';

class CreateHabitScreen extends StatefulWidget {
  const CreateHabitScreen({super.key});

  @override
  State<CreateHabitScreen> createState() => _CreateHabitScreenState();
}

class _CreateHabitScreenState extends State<CreateHabitScreen> {
  // Icon selection (use IconData from Material as placeholder icons)
  IconData selectedIcon = Icons.spa; // potted_plant equivalent
  Color selectedIconBg = const Color(0xFFEAF0EA);

  // Form state
  final TextEditingController nameController = TextEditingController();
  bool frequencyDaily = true; // Daily by default (Option A)
  TimeOfDay dailyTime = const TimeOfDay(hour: 9, minute: 0);

  // Selective days state (only used when frequencyDaily == false)
  final List<bool> selectedWeekDays = List<bool>.filled(7, false);
  TimeOfDay selectiveTime = const TimeOfDay(hour: 9, minute: 0);

  // Reminder
  bool reminderEnabled = true;
  TimeOfDay reminderTime = const TimeOfDay(hour: 9, minute: 0);

  // Weekday labels
  final List<String> weekdayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  // Emoji / icon options for tray
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
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        // Keep consistent font
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: GoogleFonts.plusJakartaSansTextTheme(),
            timePickerTheme: TimePickerThemeData(
              // Slightly rounded buttons
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    return picked;
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
                                ic == selectedIcon
                                    ? const Color(0xFF4CAE4F).withOpacity(0.15)
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border:
                                ic == selectedIcon
                                    ? Border.all(
                                      color: const Color(0xFF4CAE4F),
                                      width: 2,
                                    )
                                    : Border.all(color: Colors.grey.shade200),
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
                                ic == selectedIcon
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
    setState(() {
      selectedWeekDays[index] = !selectedWeekDays[index];
    });
  }

  // Format helper for time
  String _formatTimeOfDay(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minutes = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minutes $period';
  }

  void _onCreateHabit() {
    // Build habit payload (example)
    final name = nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name for the habit')),
      );
      return;
    }

    final selectedDays =
        List<int>.generate(
          7,
          (i) => i,
        ).where((i) => selectedWeekDays[i]).toList();

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

    // For now just print - replace with your save logic
    // e.g., call a provider or service to save to firestore/local db
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
            // Top Appbar
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
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon (tappable)
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

                    // Name
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 0,
                      ),
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

                    // Frequency Header
                    Text(
                      'Frequency',
                      style: textTheme.headlineSmall?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Space.h12,

                    // Toggle (Daily / Selective Days)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.toggleBg,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Row(
                        children: [
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
                                          ? AppColors.toggleBg
                                          : Colors.transparent,
                                  borderRadius: BorderRadius.circular(28),
                                ),
                                child: Text(
                                  'Selective Days',
                                  textAlign: TextAlign.center,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontSize: 14,
                                    fontWeight:
                                        !frequencyDaily
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                    color:
                                        !frequencyDaily
                                            ? AppColors.textPrimary
                                            : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Space.h12,

                    // Daily: show single time row
                    if (frequencyDaily) ...[
                      RoundedCard(
                        child: InkWell(
                          onTap: () async {
                            final picked = await _pickTime(dailyTime);
                            if (picked != null)
                              setState(() => dailyTime = picked);
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
                      ),
                    ] else ...[
                      // Selective days tray + common time picker
                      RoundedCard(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row with chips
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
                              // common time
                              InkWell(
                                onTap: () async {
                                  final picked = await _pickTime(selectiveTime);
                                  if (picked != null)
                                    setState(() => selectiveTime = picked);
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
                    ],

                    Space.h20,

                    // Reminder
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
                            // Toggle row
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

                            // Time row (enabled only if reminderEnabled)
                            InkWell(
                              onTap:
                                  reminderEnabled
                                      ? () async {
                                        final picked = await _pickTime(
                                          reminderTime,
                                        );
                                        if (picked != null)
                                          setState(() => reminderTime = picked);
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

                    Space.h88, // allow room for sticky CTA
                  ],
                ),
              ),
            ),

            // CTA Button sticky area
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

/// Small reusable rounded card used to keep consistent style
class RoundedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const RoundedCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8),
        ],
      ),
      child: child,
    );
  }
}

/// Day chip used in selective days tray
class DayChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const DayChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF4CAE4F) : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? Colors.transparent : Colors.grey.shade200,
          ),
          boxShadow:
              selected
                  ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 6,
                    ),
                  ]
                  : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 4,
                    ),
                  ],
        ),
        child: Center(
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : const Color(0xFF111811),
            ),
          ),
        ),
      ),
    );
  }
}
