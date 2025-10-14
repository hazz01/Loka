import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime selectedDate;
  final List<DateTime> availableDates;
  final Function(DateTime) onDateSelected;

  const CalendarWidget({
    super.key,
    required this.selectedDate,
    required this.availableDates,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final monthFormat = DateFormat('MMMM yyyy');
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive sizes
    final monthFontSize = screenWidth < 360 ? 15.0 : 17.0;
    final dayHeaderFontSize = screenWidth < 360 ? 11.0 : 13.0;
    final dateFontSize = screenWidth < 360 ? 13.0 : 15.0;
    final dateBoxSize = screenWidth < 360 ? 36.0 : 40.0;
    final iconSize = screenWidth < 360 ? 20.0 : 22.0;
    final dayWidth = screenWidth < 360 ? 32.0 : 36.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFB4BCC9).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          // Month and Year with navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                monthFormat.format(selectedDate),
                style: TextStyle(
                  fontSize: monthFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.chevron_left,
                      size: iconSize,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // Navigate to previous week
                      final previousWeek = selectedDate.subtract(
                        const Duration(days: 7),
                      );
                      onDateSelected(previousWeek);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.chevron_right,
                      size: iconSize,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      // Navigate to next week
                      final nextWeek = selectedDate.add(
                        const Duration(days: 7),
                      );
                      onDateSelected(nextWeek);
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Week days header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
              return SizedBox(
                width: dayWidth,
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: dayHeaderFontSize,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          // Dates
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _buildWeekDates(dateBoxSize, dateFontSize),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildWeekDates(double boxSize, double fontSize) {
    // Get the start of the week (Sunday)
    final startOfWeek = selectedDate.subtract(
      Duration(days: selectedDate.weekday % 7),
    );

    List<Widget> dateWidgets = [];

    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
      final isSelected = _isSameDay(date, selectedDate);
      final isAvailable = availableDates.any((d) => _isSameDay(d, date));

      dateWidgets.add(
        GestureDetector(
          onTap: isAvailable ? () => onDateSelected(date) : null,
          child: Container(
            width: boxSize,
            height: boxSize,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF539DF3) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? Colors.white
                      : isAvailable
                      ? Colors.black
                      : const Color(0xFFD1D5DB),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return dateWidgets;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
