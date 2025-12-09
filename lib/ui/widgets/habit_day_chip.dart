import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          boxShadow: [
            BoxShadow(
              color:
                  selected
                      ? Colors.black.withOpacity(0.12)
                      : Colors.black.withOpacity(0.02),
              blurRadius: selected ? 6 : 4,
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
