import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedDateIndex = 2; // Wed 20
  int selectedFilterIndex = 0; // All

  final dateChips = [
    "Mon 18",
    "Tue 19",
    "Wed 20",
    "Thu 21",
    "Fri 22",
    "Sat 23",
    "Sun 24",
  ];

  final filters = ["All", "Morning", "Evening"];

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F6), // background-light
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              _buildTopBar(textTheme),
              const SizedBox(height: 12),
              _buildDateChips(textTheme),
              const SizedBox(height: 12),
              _buildProgressCard(textTheme),
              const SizedBox(height: 12),
              _buildFilterChips(textTheme),
              const SizedBox(height: 12),
              _buildHabitList(textTheme),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // TOP BAR
  // ----------------------------------------------------------
  Widget _buildTopBar(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Avatar
          Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                  "https://lh3.googleusercontent.com/aida-public/AB6AXuAqoGCjYhpML56SDVa3zMJa2mrJE_0kBis_NaEQD_9k6PVRJnUUXJEvAFiyj5z01pJVi-IFDiQLJTNe8xSi2LFYcQbWZGoBgbb8G7t90IzVOB2egELXpZpNKB1_jBx7hFgdJIEEiRoyzPlgiJUl0lkS6I_4XazAPNKMgsafzz05K8PUQCXdUnIOAYBGMIar3qyYPhBkZbIbbAdjmn8ALaEetDS5wn_Rp_6YWe66cxu1mK7D49-IpD4eU--WTRug3Er7CDVcWRPzLy-k",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Spacer(),

          Text(
            "Today",
            style: textTheme.titleMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111811),
            ),
          ),
          const Spacer(),

          // Add Habit Button
          IconButton(
            icon: const Icon(Icons.add_circle, size: 32),
            color: const Color(0xFF111811),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // DATE CHIPS
  // ----------------------------------------------------------
  Widget _buildDateChips(TextTheme textTheme) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: dateChips.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedDateIndex;

          return GestureDetector(
            onTap: () => setState(() => selectedDateIndex = index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? const Color(0xFF4CAE4F)
                        : const Color(0xFFEAF0EA),
                borderRadius: BorderRadius.circular(24),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 6,
                          ),
                        ]
                        : null,
              ),
              child: Text(
                dateChips[index],
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFF111811),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ----------------------------------------------------------
  // PROGRESS CARD
  // ----------------------------------------------------------
  Widget _buildProgressCard(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Habits Completed",
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                "3/5",
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Progress Bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: const Color(0xFFD6E1D6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: FractionallySizedBox(
              widthFactor: 0.6,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAE4F),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // FILTER CHIPS
  // ----------------------------------------------------------
  Widget _buildFilterChips(TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(filters.length, (index) {
        final selected = index == selectedFilterIndex;

        return Padding(
          padding: const EdgeInsets.only(left: 16),
          child: GestureDetector(
            onTap: () => setState(() => selectedFilterIndex = index),
            child: Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:
                    selected
                        ? const Color(0xFF4CAE4F)
                        : const Color(0xFFEAF0EA),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                filters[index],
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: selected ? Colors.white : const Color(0xFF111811),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // ----------------------------------------------------------
  // HABIT LIST
  // ----------------------------------------------------------
  Widget _buildHabitList(TextTheme textTheme) {
    return Column(
      children: [
        _habitCard(
          icon: Icons.water_drop,
          title: "Drink Water",
          subtitle: "8/8 glasses",
          done: true,
          textTheme: textTheme,
        ),
        _habitCard(
          icon: Icons.directions_run,
          title: "Morning Run",
          subtitle: "1/1 complete",
          done: true,
          textTheme: textTheme,
        ),
        _habitCard(
          icon: Icons.menu_book,
          title: "Read 10 pages",
          subtitle: "10/10 pages",
          done: true,
          textTheme: textTheme,
        ),
        _habitCard(
          icon: Icons.self_improvement,
          title: "Meditate",
          subtitle: "0/10 minutes",
          done: false,
          textTheme: textTheme,
        ),
        _habitCard(
          icon: Icons.edit_note,
          title: "Journal",
          subtitle: "0/1 session",
          done: false,
          textTheme: textTheme,
        ),
      ],
    );
  }

  // ----------------------------------------------------------
  // HABIT CARD REUSABLE WIDGET
  // ----------------------------------------------------------
  Widget _habitCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool done,
    required TextTheme textTheme,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAE4F).withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF4CAE4F)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111811),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: 13,
                    color: const Color(0xFF4CAE4F),
                  ),
                ),
              ],
            ),
          ),
          Checkbox(
            value: done,
            onChanged: (_) {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            activeColor: const Color(0xFF4CAE4F),
          ),
        ],
      ),
    );
  }
}
