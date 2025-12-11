import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../app_router.dart';
import '../../../bloc/habit/habit_bloc.dart';
import '../../../bloc/habit/habit_event.dart';
import '../../../bloc/habit/habit_state.dart';
import '../../../core/services/user_prefs.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/spacing.dart';
import '../../../models/habit_model.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<DateTime> _dateWindow = [];
  int selectedDateIndex = 7;
  int selectedFilterIndex = 0;
  final ScrollController _dateScrollController = ScrollController();

  final filters = ["All", "Morning", "Evening"];

  @override
  void initState() {
    super.initState();
    _generateDateWindow();

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToToday());

    Future.microtask(() async {
      final user = await UserPrefs.loadUser();
      final uid = user?.uid ?? '';
      context.read<HabitBloc>().add(LoadHabits(uid));
    });
  }

  // ---------------- Date Window & Scroller ----------------
  void _generateDateWindow() {
    final today = DateTime.now();
    _dateWindow = List.generate(
      14,
      (i) => today.subtract(Duration(days: 7 - i)),
    );
  }

  void _scrollToToday() {
    const double chipWidth = 80;
    final targetOffset = (selectedDateIndex * chipWidth) - 120;

    if (_dateScrollController.hasClients) {
      _dateScrollController.animateTo(
        targetOffset < 0 ? 0 : targetOffset,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  String _formatChipDate(DateTime date) {
    const w = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return "${w[date.weekday - 1]} ${date.day}";
  }

  // ---------------- Completion Helpers ----------------
  bool _isHabitCompleted(HabitState state, String habitId, DateTime date) {
    final id = date.toIso8601String().substring(0, 10);
    return state.completions.any(
      (c) => c.habitId == habitId && c.dateId == id && c.completed,
    );
  }

  int _completedCount(HabitState state, DateTime date) {
    final id = date.toIso8601String().substring(0, 10);
    return state.completions.where((c) => c.dateId == id && c.completed).length;
  }

  double _progressFactor(HabitState state, DateTime date) {
    if (state.habits.isEmpty) return 0.0;
    return _completedCount(state, date) / state.habits.length;
  }

  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F6),
      body: SafeArea(
        child: BlocBuilder<HabitBloc, HabitState>(
          builder: (context, state) {
            final selectedDate = _dateWindow[selectedDateIndex];

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildTopBar(textTheme),
                  Space.h12,
                  _buildDateChips(textTheme),
                  Space.h12,
                  _buildProgressCard(textTheme, state, selectedDate),
                  Space.h12,
                  _buildFilterChips(textTheme),
                  Space.h12,
                  _buildHabitList(textTheme, state, selectedDate),
                  Space.h16,
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ---------------- TOP BAR ----------------
  Widget _buildTopBar(TextTheme textTheme) {
    return FutureBuilder(
      future: UserPrefs.loadUser(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              InkWell(
                onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(
                        user?.photoUrl ??
                            "https://ui-avatars.com/api/?name=User",
                      ),
                      fit: BoxFit.cover,
                    ),
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
              IconButton(
                icon: const Icon(Icons.add_circle, size: 32),
                color: const Color(0xFF111811),
                onPressed:
                    () => Navigator.pushNamed(context, AppRoutes.createHabit),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------- DATE CHIPS ----------------
  Widget _buildDateChips(TextTheme textTheme) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        controller: _dateScrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => Space.w8,
        itemCount: _dateWindow.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedDateIndex;
          final label = _formatChipDate(_dateWindow[index]);

          return GestureDetector(
            onTap: () {
              setState(() => selectedDateIndex = index);
              _scrollToToday();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.green : const Color(0xFFEAF0EA),
                borderRadius: BorderRadius.circular(24),
                boxShadow:
                    isSelected
                        ? [BoxShadow(color: Colors.black26, blurRadius: 6)]
                        : null,
              ),
              child: Text(
                label,
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

  // ---------------- PROGRESS CARD ----------------
  Widget _buildProgressCard(
    TextTheme textTheme,
    HabitState state,
    DateTime date,
  ) {
    final completed = _completedCount(state, date);
    final total = state.habits.length;
    final factor = _progressFactor(state, date);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                "$completed/$total",
                style: textTheme.bodyMedium?.copyWith(color: Colors.black54),
              ),
            ],
          ),
          Space.h16,
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 8,
              width: double.infinity,
              color: AppColors.backgroundLight,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: factor,
                child: Container(color: AppColors.green),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- FILTER CHIPS ----------------
  Widget _buildFilterChips(TextTheme textTheme) {
    return Row(
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
                color: selected ? AppColors.green : const Color(0xFFEAF0EA),
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

  // ---------------- HABIT LIST ----------------
  Widget _buildHabitList(TextTheme textTheme, HabitState state, DateTime date) {
    if (state.isLoading) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.habits.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Icon(Icons.inbox, size: 70, color: Colors.grey.shade400),
            Space.h12,
            Text(
              "No habits yet",
              style: textTheme.bodyLarge?.copyWith(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children:
          state.habits.map((habit) {
            final icon = IconData(
              habit.iconCodePoint,
              fontFamily: "MaterialIcons",
            );
            final completed = _isHabitCompleted(state, habit.id, date);

            final subtitle =
                habit.isDaily
                    ? "Daily • ${habit.dailyTime}"
                    : "Weekly • ${habit.selectedDays.length} days • ${habit.selectiveTime}";

            return _habitCard(
              habit: habit,
              icon: icon,
              subtitle: subtitle,
              done: completed,
              selectedDate: date,
              textTheme: textTheme,
              state: state,
            );
          }).toList(),
    );
  }

  // ---------------- HABIT CARD ----------------
  Widget _habitCard({
    required HabitModel habit,
    required IconData icon,
    required String subtitle,
    required bool done,
    required DateTime selectedDate,
    required TextTheme textTheme,
    required HabitState state,
  }) {
    return InkWell(
      onTap:
          () => Navigator.pushNamed(
            context,
            AppRoutes.habitDetails,
            arguments: {"habit": habit, "completions": state.completions},
          ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: AppColors.greenLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.green),
            ),
            Space.w16,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  Space.h4,
                  Text(
                    subtitle,
                    style: textTheme.bodySmall?.copyWith(
                      fontSize: 13,
                      color: AppColors.green,
                    ),
                  ),
                ],
              ),
            ),
            Checkbox(
              value: done,
              onChanged: (v) async {
                final user = await UserPrefs.loadUser();
                final userId = user?.uid ?? '';

                context.read<HabitBloc>().add(
                  ToggleCompletion(
                    userId: userId,
                    habitId: habit.id,
                    date: selectedDate,
                    completed: v ?? false,
                  ),
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              activeColor: AppColors.green,
            ),
          ],
        ),
      ),
    );
  }
}
