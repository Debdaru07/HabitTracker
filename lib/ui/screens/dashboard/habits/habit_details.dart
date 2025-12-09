import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/spacing.dart';

class HabitDetailsScreen extends StatefulWidget {
  const HabitDetailsScreen({super.key});

  @override
  State<HabitDetailsScreen> createState() => _HabitDetailsScreenState();
}

class _HabitDetailsScreenState extends State<HabitDetailsScreen> {
  final List<int> completedDays = [
    5,
    7,
    8,
    9,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    22,
    23,
    27,
    28,
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme();

    return Scaffold(
      backgroundColor: AppColors.screenBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(textTheme),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(textTheme),
                    Space.h12,
                    _buildStatsRow(textTheme),
                    Space.h12,
                    _buildCalendar(textTheme),
                    Space.h12,
                    _buildHistory(textTheme),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------
  // APP BAR
  // -------------------------------------------------------------------
  Widget _buildAppBar(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.black,
              size: 24,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              "Habit Details",
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.black,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------
  // HEADER (ICON + TITLE + SUBTITLE)
  // -------------------------------------------------------------------
  Widget _buildHeader(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 90,
            width: 90,
            decoration: BoxDecoration(
              color: AppColors.greenLight,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.auto_stories, color: AppColors.green, size: 44),
            ),
          ),
          Space.w16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Read Daily",
                  style: textTheme.titleMedium?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.black,
                  ),
                ),
                Space.h4,
                Text(
                  "Read for 15 minutes every day",
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.greyDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------
  // STATS ROW — 3 CARDS
  // -------------------------------------------------------------------
  Widget _buildStatsRow(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _statItem("Current Streak", "12 Days", AppColors.green, textTheme),
          _statItem("Completion Rate", "90%", AppColors.black, textTheme),
          _statItem("Longest Streak", "25 Days", AppColors.black, textTheme),
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
          Text(
            title,
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
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

  // -------------------------------------------------------------------
  // CALENDAR SECTION
  // -------------------------------------------------------------------
  Widget _buildCalendar(TextTheme textTheme) {
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
            _calendarHeader(textTheme),
            Space.h8,
            _calendarWeekdays(textTheme),
            Space.h4,
            _calendarDays(textTheme),
          ],
        ),
      ),
    );
  }

  Widget _calendarHeader(TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _iconButton(Icons.chevron_left),
        Text(
          "November 2023",
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.black,
            fontSize: 16,
          ),
        ),
        _iconButton(Icons.chevron_right),
      ],
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      height: 36,
      width: 36,
      alignment: Alignment.center,
      child: Icon(icon, size: 20, color: AppColors.black),
    );
  }

  Widget _calendarWeekdays(TextTheme textTheme) {
    final days = ["S", "M", "T", "W", "T", "F", "S"];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          days
              .map(
                (d) => SizedBox(
                  width: 40,
                  child: Center(
                    child: Text(
                      d,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }

  Widget _calendarDays(TextTheme textTheme) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 30,
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
                  fontSize: 14,
                  color: done ? AppColors.white : AppColors.black,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // -------------------------------------------------------------------
  // HISTORY SECTION
  // -------------------------------------------------------------------
  Widget _buildHistory(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "History",
            style: textTheme.titleLarge?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Space.h12,
          _historyFilters(textTheme),
          Space.h12,
          _historyRow("Today", "Completed", true, textTheme),
          _historyRow("Yesterday", "Missed", false, textTheme),
          _historyRow("Nov 28, 2023", "Completed", true, textTheme),
          _historyRow("Nov 27, 2023", "Completed", true, textTheme),
        ],
      ),
    );
  }

  Widget _historyFilters(TextTheme textTheme) {
    return Row(
      children: [
        _chip("This Week", true),
        Space.w12,
        _chip("This Month", false),
        Space.w12,
        _chip("All Time", false),
      ],
    );
  }

  Widget _chip(String text, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? AppColors.green : AppColors.greyLight,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: selected ? AppColors.white : AppColors.black,
        ),
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
            style: textTheme.bodyLarge?.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
          ),
          Row(
            children: [
              Text(
                status,
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
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
