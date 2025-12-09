import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      backgroundColor: const Color(0xFFF6F7F6),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(textTheme),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHabitHeader(textTheme),
                    _buildStatsRow(textTheme),
                    _buildCalendarContainer(textTheme),
                    _buildHistorySection(textTheme),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // TOP APPBAR
  // ------------------------------------------------------------
  Widget _buildAppBar(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 24,
              color: Color(0xFF111811),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              "Habit Details",
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF111811),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              size: 24,
              color: Color(0xFF111811),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // HEADER: HABIT ICON + NAME + SUBTITLE
  // ------------------------------------------------------------
  Widget _buildHabitHeader(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            height: 72,
            width: 72,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAE4F).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_stories,
              color: Color(0xFF4CAE4F),
              size: 40,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Read Daily",
                  style: textTheme.titleLarge?.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF111811),
                  ),
                ),
                Text(
                  "Read for 15 minutes every day",
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 15,
                    color: const Color(0xFF608562),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // STATS ROW: Streak, Completion Rate, Longest Streak
  // ------------------------------------------------------------
  Widget _buildStatsRow(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _statsCard("Current Streak", "12 Days", Colors.green, textTheme),
          _statsCard("Completion Rate", "90%", Colors.black87, textTheme),
          _statsCard("Longest Streak", "25 Days", Colors.black87, textTheme),
        ],
      ),
    );
  }

  Widget _statsCard(
    String title,
    String value,
    Color valueColor,
    TextTheme textTheme,
  ) {
    return Container(
      width: 160,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // CALENDAR GRID (Exactly as design)
  // ------------------------------------------------------------
  Widget _buildCalendarContainer(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [_buildCalendarHeader(textTheme), _buildCalendarGrid()],
        ),
      ),
    );
  }

  Widget _buildCalendarHeader(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chevron_left, size: 22),
          ),
          Expanded(
            child: Text(
              "November 2023",
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF111811),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chevron_right, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final List<String> days = ["S", "M", "T", "W", "T", "F", "S"];

    return Column(
      children: [
        // Weekdays
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (var d in days)
              Center(
                child: Text(
                  d,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: const Color(0xFF111811),
                  ),
                ),
              ),
          ],
        ),

        // Day Cells
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 30,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
          ),
          itemBuilder: (_, index) {
            final day = index + 1;
            final isCompleted = completedDays.contains(day);

            return Center(
              child: Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  color:
                      isCompleted
                          ? const Color(0xFF4CAE4F)
                          : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    "$day",
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      color:
                          isCompleted ? Colors.white : const Color(0xFF111811),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // HISTORY SECTION
  // ------------------------------------------------------------
  Widget _buildHistorySection(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "History",
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _chip("This Week", true),
                const SizedBox(width: 12),
                _chip("This Month", false),
                const SizedBox(width: 12),
                _chip("All Time", false),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // History List
          _historyRow("Today", "Completed", true),
          _historyRow("Yesterday", "Missed", false),
          _historyRow("Nov 28, 2023", "Completed", true),
          _historyRow("Nov 27, 2023", "Completed", true),
        ],
      ),
    );
  }

  Widget _chip(String text, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF4CAE4F) : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          color: selected ? Colors.white : const Color(0xFF111811),
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _historyRow(String date, String status, bool completed) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: const Color(0xFF111811),
            ),
          ),
          Row(
            children: [
              Text(
                status,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  color:
                      completed
                          ? const Color(0xFF4CAE4F)
                          : Colors.grey.shade500,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                completed ? Icons.check_circle : Icons.cancel,
                size: 20,
                color:
                    completed ? const Color(0xFF4CAE4F) : Colors.grey.shade500,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
