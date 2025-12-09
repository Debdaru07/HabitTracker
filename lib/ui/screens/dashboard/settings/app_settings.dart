import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  bool isDarkMode = false;
  bool dailyReminder = true;
  TimeOfDay reminderTime = const TimeOfDay(hour: 9, minute: 0);

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F6),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(textTheme),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildProfileCard(textTheme),
                    const SizedBox(height: 16),

                    _buildPreferencesCard(textTheme),
                    const SizedBox(height: 16),

                    _buildNotificationsCard(textTheme),
                    const SizedBox(height: 16),

                    _buildLogoutButton(textTheme),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // HEADER
  // ----------------------------------------------------------
  Widget _buildHeader(TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(color: Color(0xFFF6F7F6)),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, size: 22),
          ),

          Expanded(
            child: Text(
              "Settings",
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF111811),
              ),
            ),
          ),

          const SizedBox(width: 40), // To balance the back arrow
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // PROFILE CARD
  // ----------------------------------------------------------
  Widget _buildProfileCard(TextTheme textTheme) {
    return _cardContainer(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              Container(
                height: 56,
                width: 56,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://lh3.googleusercontent.com/aida-public/AB6AXuDhiqREHgw1T5a0B9uVI3G88s7l0sD7vwyYJVd7d-nDyY98UIka24ViAa0_TnGfQTjB4E4_QOI42ClGlnhXE5zHf6npuzqxKYl64-gSqXFGabY4-C2rZEqT_r6GezgewmC3Znkjqq5Msnh3ZCIzfUFjtciqErfp-9RZCyU5bH-1zin8JDAYCROHWE3xWK6aC_c9tBMUWrerXLWCt_UhySJCx7QaZS2_qZsryKQqHq_1g1ggH12_tfIvSOttfbxjppHjbWP1nqhTJ0Ty",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Name + Email
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Jordan Smith",
                      style: textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "jordan.smith@example.com",
                      style: textTheme.bodySmall?.copyWith(
                        fontSize: 13,
                        color: const Color(0xFF608562),
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
                color: Color(0xFF608562),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // PREFERENCES CARD
  // ----------------------------------------------------------
  Widget _buildPreferencesCard(TextTheme textTheme) {
    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Preferences", textTheme),
          _settingsTile(
            icon: Icons.dark_mode,
            title: "Dark Mode",
            trailing: Switch(
              value: isDarkMode,
              activeColor: const Color(0xFF4CAE4F),
              onChanged: (v) {
                setState(() => isDarkMode = v);
              },
            ),
          ),
          _divider(),
          _settingsTile(
            icon: Icons.today,
            title: "First Day of the Week",
            trailing: TextButton(
              onPressed: () {},
              child: Text(
                "Sunday",
                style: textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF608562),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // NOTIFICATIONS CARD
  // ----------------------------------------------------------
  Widget _buildNotificationsCard(TextTheme textTheme) {
    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle("Notifications", textTheme),
          _settingsTile(
            icon: Icons.notifications_active,
            title: "Daily Reminders",
            trailing: Switch(
              value: dailyReminder,
              activeColor: const Color(0xFF4CAE4F),
              onChanged: (v) {
                setState(() => dailyReminder = v);
              },
            ),
          ),
          _divider(),
          _settingsTile(
            icon: Icons.schedule,
            title: "Reminder Time",
            trailing: TextButton(
              onPressed: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: reminderTime,
                );
                if (picked != null) {
                  setState(() => reminderTime = picked);
                }
              },
              child: Text(
                _formatTime(reminderTime),
                style: textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF608562),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // LOGOUT BUTTON
  // ----------------------------------------------------------
  Widget _buildLogoutButton(TextTheme textTheme) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: TextButton(
        onPressed: () {},
        child: Text(
          "Log Out",
          style: textTheme.titleMedium?.copyWith(
            color: Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // REUSABLE HELPERS
  // ----------------------------------------------------------

  Widget _cardContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String title, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Text(
        title,
        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String title,
    required Widget trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF0EA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF111811)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF111811),
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 1,
      color: Colors.black.withOpacity(0.05),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }
}
