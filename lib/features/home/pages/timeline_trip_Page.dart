import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:toastification/toastification.dart';
import '../models/trip_destination_model.dart';
import '../widgets/day_tab_selector.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/trip_timeline_card.dart';

class TimelineTripPage extends StatefulWidget {
  const TimelineTripPage({super.key});

  @override
  State<TimelineTripPage> createState() => _TimelineTripPageState();
}

class _TimelineTripPageState extends State<TimelineTripPage> {
  void showSuccessNotification(
    BuildContext context,
    String message,
    String title,
  ) {
    toastification.show(
      context: context,
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      description: Text(
        message,
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
      ),
      icon: const Icon(Icons.check_circle, color: Colors.white, size: 24),
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 5),
      alignment: Alignment.topCenter,
      borderRadius: BorderRadius.circular(12),
      closeButtonShowType: CloseButtonShowType.always,
      primaryColor: Color(0xFF3BB758),
    );
  }

  // Load dummy data
  final List<DayTrip> tripDays = TripDummyData.getMalangTrip();
  late DateTime selectedDate;
  late int selectedDay;

  @override
  void initState() {
    super.initState();
    // Initialize with first day
    selectedDate = tripDays[0].date!;
    selectedDay = 1;
  }

  DayTrip get currentDayTrip {
    return tripDays.firstWhere((trip) => trip.day == selectedDay);
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
      // Find the day number based on selected date
      final trip = tripDays.firstWhere(
        (trip) =>
            trip.date?.day == date.day &&
            trip.date?.month == date.month &&
            trip.date?.year == date.year,
        orElse: () => tripDays[0],
      );
      selectedDay = trip.day;
    });
  }

  void _onDaySelected(int day) {
    setState(() {
      selectedDay = day;
      selectedDate = tripDays.firstWhere((trip) => trip.day == day).date!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTrip = currentDayTrip;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive font sizes
    final titleFontSize = screenWidth < 360 ? 14.0 : 16.0;
    final cityFontSize = screenWidth < 360 ? 22.0 : 26.0;
    final subtitleFontSize = screenWidth < 360 ? 12.0 : 14.0;
    final dayTitleFontSize = screenWidth < 360 ? 16.0 : 18.0;
    final buttonFontSize = screenWidth < 360 ? 14.0 : 16.0;
    final iconSize = screenWidth < 360 ? 22.0 : 25.0;
    final popButtonSize = screenWidth < 360 ? 10.0 : 12.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: Text(
          'Travel Recommendations',
          style: TextStyle(
            fontSize: titleFontSize,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            LucideIcons.chevronLeft,
            color: Colors.black,
            size: iconSize,
          ),
          onPressed: () => context.go('/trip-ai-planner/greater-city'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Day Tab Selector
            DayTabSelector(
              selectedDay: selectedDay,
              totalDays: tripDays.length,
              onDaySelected: _onDaySelected,
            ),
            const SizedBox(height: 10),

            // Calendar Widget

            // Trip Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CalendarWidget(
                    selectedDate: selectedDate,
                    availableDates: tripDays
                        .map((trip) => trip.date)
                        .where((date) => date != null)
                        .cast<DateTime>()
                        .toList(),
                    onDateSelected: _onDateSelected,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Malang",
                    style: TextStyle(
                      fontSize: cityFontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${tripDays.length} Day Trip",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      fontSize: subtitleFontSize,
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Day Title
                  Text(
                    "Day ${currentTrip.day}",
                    style: TextStyle(
                      fontSize: dayTitleFontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Timeline Cards
                  ...currentTrip.destinations.asMap().entries.map((entry) {
                    final index = entry.key;
                    final activity = entry.value;
                    final isLast = index == currentTrip.destinations.length - 1;

                    return TripTimelineCard(
                      destination: activity.toDestination(),
                      isLast: isLast,
                    );
                  }).toList(),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.white,
                        title: const Text(
                          'Plan Saved',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        content: const Text(
                          'Your holiday plan has been successfully saved. You can still edit this plan anytime before booking tickets.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF666666),
                          ),
                        ),
                        actions: [
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    showSuccessNotification(
                                      context,
                                      "Plan successfully saved into your account",
                                      "Plan saved",
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF539DF3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: const Text(
                                    'Confirm',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10), // jarak antar tombol
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      side: const BorderSide(
                                        color: Color(0xFF539DF3),
                                      ),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    'Booking Ticket',
                                    style: TextStyle(
                                      color: const Color(0xFF539DF3),
                                      fontSize: popButtonSize,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF539DF3),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: buttonFontSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // Save functionality
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.white,
                        title: const Text(
                          'Booking Confirmation',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        content: const Text(
                          'You are about to proceed with booking tickets based on this plan. Please make sure everything is correct, as changes after booking may be limited.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF666666),
                          ),
                        ),
                        actions: [
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Booking tickets...'),
                                        backgroundColor: Color(0xFF539DF3),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF539DF3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: Text(
                                    'Booking Ticket',
                                    style: TextStyle(
                                      fontSize: popButtonSize,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10), // jarak antar tombol
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      side: const BorderSide(
                                        color: Color(0xFF539DF3),
                                      ),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Color(0xFF539DF3),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  side: const BorderSide(color: Color(0xFF539DF3), width: 1.5),
                ),
                child: Text(
                  'Booking Ticket',
                  style: TextStyle(
                    fontSize: buttonFontSize,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF539DF3),
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
