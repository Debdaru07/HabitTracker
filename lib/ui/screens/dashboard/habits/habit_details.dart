import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/spacing.dart';
import '../../../../models/habit_model.dart';
import '../../../../models/habit_completion_model.dart';

class HabitDetailsScreen extends StatefulWidget {
  final HabitModel habit;
  final List<HabitCompletionModel> completions;

  const HabitDetailsScreen({
    super.key,
    required this.habit,
    required this.completions,
  });

  @override
  State<HabitDetailsScreen> createState() => _HabitDetailsScreenState();
}

class _HabitDetailsScreenState extends State<HabitDetailsScreen> {
  late DateTime month;
  late List<int> completedDays;

  @override
  void initState() {
    super.initState();
    month = DateTime(DateTime.now().year, DateTime.now().month);
    completedDays =
        widget.completions
            .where((c) => c.habitId == widget.habit.id)
            .where(
              (c) => c.date.year == month.year && c.date.month == month.month,
            )
            .map((c) => c.date.day)
            .toList();
  }

  int getCurrentStreak() {
    int streak = 0;
    DateTime check = DateTime.now();
    while (completedDays.contains(check.day)) {
      streak++;
      check = check.subtract(const Duration(days: 1));
    }
    return streak;
  }

  int getLongestStreak() {
    int longest = 0, current = 0;
    for (
      int i = 1;
      i <= DateUtils.getDaysInMonth(month.year, month.month);
      i++
    ) {
      if (completedDays.contains(i)) {
        current++;
        longest = current > longest ? current : longest;
      } else {
        current = 0;
      }
    }
    return longest;
  }

  double getCompletionRate() {
    final d = DateUtils.getDaysInMonth(month.year, month.month);
    return completedDays.isEmpty ? 0 : (completedDays.length / d);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme();

    return Scaffold(
      backgroundColor: AppColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            _appBar(textTheme),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(textTheme),
                    Space.h12,
                    _stats(textTheme),
                    Space.h12,
                    _calendar(textTheme),
                    Space.h12,
                    _history(textTheme),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBar(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.black),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              "Habit Details",
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _header(TextTheme textTheme) {
    final icon = IconData(
      widget.habit.iconCodePoint,
      fontFamily: "MaterialIcons",
    );

    final subtitle =
        widget.habit.isDaily
            ? "Daily • ${widget.habit.dailyTime}"
            : "Weekly • ${widget.habit.selectedDays.length} days • ${widget.habit.selectiveTime}";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            height: 90,
            width: 90,
            decoration: const BoxDecoration(
              color: AppColors.greenLight,
              shape: BoxShape.circle,
            ),
            child: Center(child: Icon(icon, size: 44, color: AppColors.green)),
          ),
          Space.w16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.habit.name,
                  style: textTheme.titleMedium?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Space.h4,
                Text(
                  subtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.greyDark,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stats(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _statItem(
            "Current Streak",
            "${getCurrentStreak()} Days",
            AppColors.green,
            textTheme,
          ),
          _statItem(
            "Completion Rate",
            "${(getCompletionRate() * 100).round()}%",
            AppColors.black,
            textTheme,
          ),
          _statItem(
            "Longest Streak",
            "${getLongestStreak()} Days",
            AppColors.black,
            textTheme,
          ),
        ],
      ),
    );
  }

  Widget _statItem(
    String title,
    String value,
    Color highlight,
    TextTheme textTheme,
  ) {
    return Container(
      width: 158,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textTheme.bodyMedium?.copyWith(fontSize: 14)),
          Space.h8,
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: highlight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _calendar(TextTheme textTheme) {
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.greyLight),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _iconBtn(Icons.chevron_left),
                Text(
                  DateFormat("MMMM yyyy").format(month),
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                _iconBtn(Icons.chevron_right),
              ],
            ),
            Space.h8,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
                  ["S", "M", "T", "W", "T", "F", "S"]
                      .map(
                        (e) => SizedBox(
                          width: 40,
                          child: Center(
                            child: Text(
                              e,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
            ),
            Space.h4,
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: daysInMonth,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisExtent: 42,
              ),
              itemBuilder: (_, index) {
                final day = index + 1;
                final done = completedDays.contains(day);

                return Center(
                  child: Container(
                    height: 34,
                    width: 34,
                    decoration: BoxDecoration(
                      color: done ? AppColors.green : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        "$day",
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: done ? AppColors.white : AppColors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconBtn(IconData i) => Container(
    height: 36,
    width: 36,
    alignment: Alignment.center,
    child: Icon(i),
  );

  Widget _history(TextTheme textTheme) {
    final history =
        widget.completions.where((c) => c.habitId == widget.habit.id).toList()
          ..sort((a, b) => b.date.compareTo(a.date));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "History",
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          Space.h12,
          Column(
            children:
                history.map((c) {
                  final d = DateFormat("MMM d, yyyy").format(c.date);
                  return _historyRow(
                    d,
                    c.completed ? "Completed" : "Missed",
                    c.completed,
                    textTheme,
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _historyRow(
    String date,
    String status,
    bool done,
    TextTheme textTheme,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date,
            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          Row(
            children: [
              Text(
                status,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: done ? AppColors.green : AppColors.grey,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                done ? Icons.check_circle : Icons.cancel,
                size: 20,
                color: done ? AppColors.green : AppColors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
