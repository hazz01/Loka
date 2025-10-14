import 'package:flutter/material.dart';

class DayTabSelector extends StatelessWidget {
  final int selectedDay;
  final int totalDays;
  final Function(int) onDaySelected;

  const DayTabSelector({
    super.key,
    required this.selectedDay,
    required this.totalDays,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final dayFontSize = screenWidth < 360 ? 13.0 : 16.0;
    final dividerLineHeight = screenWidth < 360 ? 2.0 : 3.0;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: Text(
              'Day $selectedDay',
              style: TextStyle(
                fontSize: dayFontSize,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF539DF3),
              ),
            ),
          ),
        ),
        Container(height: dividerLineHeight, color: const Color(0xFF539DF3)),
      ],
    );
  }
}
