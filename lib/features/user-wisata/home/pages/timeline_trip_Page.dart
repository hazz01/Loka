import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:toastification/toastification.dart';
import '../models/trip_destination_model.dart';
import '../models/trip_response_model.dart';
import '../widgets/day_tab_selector.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/trip_timeline_card.dart';

class TimelineTripPage extends StatefulWidget {
  final TripResponse? tripResponse;

  const TimelineTripPage({super.key, this.tripResponse});

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
  late List<DayTrip> tripDays;
  late DateTime selectedDate;
  late int selectedDay;
  late String cityName;
  late String tripSummary;
  late int totalCost;

  @override
  void initState() {
    super.initState();

    // Check if we have API response data
    if (widget.tripResponse != null) {
      // Use API data
      _loadApiData();
    } else {
      // Use dummy data as fallback
      _loadDummyData();
    }
  }

  void _loadApiData() {
    final response = widget.tripResponse!;

    // Convert API response to DayTrip model
    tripDays = response.days.map((daySchedule) {
      // Calculate date for this day
      DateTime dayDate = DateTime.now().add(
        Duration(days: daySchedule.dayNumber - 1),
      );

      // Convert activities to Activity model with dummy UI data
      List<Activity> activities = daySchedule.activities.map((
        activitySchedule,
      ) {
        return Activity(
          activityType: activitySchedule.activityType,
          destinationId: activitySchedule.destinationId,
          destinationName: activitySchedule.destinationName,
          startTime: activitySchedule.startTime,
          endTime: activitySchedule.endTime,
          notes: activitySchedule.notes,
          // Dummy UI data
          imagePath: 'assets/image/kayutangan.png',
          price: 'Free',
          address: activitySchedule.destinationName != null
              ? '${activitySchedule.destinationName} Area'
              : null,
        );
      }).toList();

      return DayTrip(
        dayNumber: daySchedule.dayNumber,
        activities: activities,
        date: dayDate,
      );
    }).toList();

    // Extract city name from originalRequest with robust fallbacks. The
    // backend may return the tripType as a Map, a plain String, or a
    // typed object. We also fall back to the first element of
    // targetCities. If nothing is available, default to 'Malang' to match
    // the greater-city flow (and avoid showing 'Unknown City').
    final original = response.originalRequest;
    String? derivedCity;

    try {
      final tripType = original['tripType'];
      if (tripType != null) {
        if (tripType is Map) {
          derivedCity = (tripType['name'] as String?)?.toString();
        } else if (tripType is String) {
          derivedCity = tripType;
        } else {
          // Handle typed object (may come from json decoding into a class)
          try {
            derivedCity = (tripType as dynamic).name as String?;
          } catch (_) {
            // ignore and continue to other fallbacks
          }
        }
      }
    } catch (_) {
      // ignore
    }

    // Fallback to targetCities array if tripType didn't yield a name
    if ((derivedCity == null || derivedCity.isEmpty) &&
        original['targetCities'] != null &&
        original['targetCities'] is List &&
        (original['targetCities'] as List).isNotEmpty) {
      final first = (original['targetCities'] as List)[0];
      derivedCity = first?.toString();
    }

    // Final fallback: prefer 'Malang' for greater-city flows to avoid
    // showing 'Unknown City' to the user.
    cityName = (derivedCity != null && derivedCity.isNotEmpty)
        ? derivedCity
        : 'Malang';

    tripSummary = response.summary;
    totalCost = response.totalEstimatedCost;

    // Initialize with first day
    if (tripDays.isNotEmpty) {
      selectedDate = tripDays[0].date!;
      selectedDay = 1;
    }
  }

  void _loadDummyData() {
    tripDays = TripDummyData.getMalangTrip();
    cityName = "Malang";
    tripSummary = "A wonderful trip to Malang";
    totalCost = 500000;

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
    final isSmallScreen = screenWidth < 600;

    // Responsive sizing
    final horizontalPadding = isSmallScreen ? 16.0 : 30.0;
    final verticalPadding = isSmallScreen ? 20.0 : 30.0;
    final titleFontSize = isSmallScreen ? 15.0 : 16.0;
    final cityFontSize = isSmallScreen ? 22.0 : 26.0;
    final subtitleFontSize = isSmallScreen ? 12.0 : 14.0;
    final dayTitleFontSize = isSmallScreen ? 16.0 : 18.0;
    final buttonFontSize = isSmallScreen ? 14.0 : 16.0;
    final iconSize = isSmallScreen ? 22.0 : 25.0;
    final popButtonSize = isSmallScreen ? 11.0 : 14.0;
    final summaryFontSize = isSmallScreen ? 11.0 : 12.0;
    final summaryTitleFontSize = isSmallScreen ? 13.0 : 14.0;
    final summaryIconSize = isSmallScreen ? 14.0 : 16.0;
    final summaryPadding = isSmallScreen ? 10.0 : 12.0;

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
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
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
                  SizedBox(height: isSmallScreen ? 16 : 20),
                  Text(
                    cityName,
                    style: TextStyle(
                      fontSize: cityFontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 4 : 5),
                  Text(
                    "${tripDays.length} Day Trip",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      fontSize: subtitleFontSize,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 10),

                  // Trip Summary (from API)
                  if (widget.tripResponse != null) ...[
                    Container(
                      padding: EdgeInsets.all(summaryPadding),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(isSmallScreen ? 5 : 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEBF5FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  LucideIcons.info,
                                  size: summaryIconSize,
                                  color: Color(0xFF539DF3),
                                ),
                                SizedBox(width: isSmallScreen ? 6 : 8),
                                Text(
                                  "Trip Summary",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: summaryTitleFontSize,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 10 : 12),
                          Text(
                            tripSummary,
                            style: TextStyle(
                              fontSize: summaryFontSize,
                              color: Colors.black54,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 10 : 12),
                          Row(
                            children: [
                              Icon(
                                LucideIcons.wallet,
                                size: summaryIconSize - 2,
                                color: Color(0xFF539DF3),
                              ),
                              SizedBox(width: isSmallScreen ? 5 : 6),
                              Flexible(
                                child: Text(
                                  "Estimated Budget: IDR ${totalCost.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                                  style: TextStyle(
                                    fontSize: summaryFontSize,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF539DF3),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 15),
                  ],

                  SizedBox(height: isSmallScreen ? 18 : 22),

                  // Day Title
                  Text(
                    "Day ${currentTrip.day}",
                    style: TextStyle(
                      fontSize: dayTitleFontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 18 : 24),

                  // Timeline Cards
                  ...currentTrip.destinations.asMap().entries.map((entry) {
                    final index = entry.key;
                    final activity = entry.value;
                    final isLast = index == currentTrip.destinations.length - 1;

                    return TripTimelineCard(activity: activity, isLast: isLast);
                  }).toList(),
                ],
              ),
            ),
            SizedBox(height: isSmallScreen ? 16 : 20),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
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
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 12 : 16,
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
            SizedBox(width: isSmallScreen ? 10 : 15),
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
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 12 : 16,
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
