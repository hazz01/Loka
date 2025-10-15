import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../services/trip_service.dart';
import '../models/trip_request_model.dart';

class KategoriGreaterCityPage extends StatefulWidget {
  const KategoriGreaterCityPage({super.key});

  @override
  State<KategoriGreaterCityPage> createState() =>
      _KategoriGreaterCityPageState();
}

class _KategoriGreaterCityPageState extends State<KategoriGreaterCityPage> {
  // --- Data & Controller ---
  final List<String> cities = [
    'Jakarta',
    'Bogor',
    'Depok',
    'Tangerang',
    'Bekasi',
    'Malang'
  ];
  final List<String> timesOfDay = ['Morning', 'Noon', 'Evening', 'Night'];
  final Map<String, bool> categories = {
    'All': false,
    'Recommended': false,
    'Culinary': false,
    'Souvenir': false,
    'Natural': false,
    'Art & Culture': false,
    'History': false,
  };

  final Map<String, IconData> categoryIcons = {
    'All': LucideIcons.layoutDashboard,
    'Recommended': LucideIcons.mapPin,
    'Culinary': LucideIcons.utensils,
    'Souvenir': LucideIcons.gift,
    'Natural': LucideIcons.flower2,
    'Art & Culture': LucideIcons.palette,
    'History': LucideIcons.landmark,
  };

  String? selectedCity;
  DateTime? startDate;
  DateTime? endDate;
  String? startTime;
  String? endTime;
  double? cost;
  int people = 1;
  bool isLoading = false;

  // --- Form validation ---
  bool get isFormValid {
    return selectedCity != null &&
        startDate != null &&
        endDate != null &&
        startTime != null &&
        endTime != null &&
        cost != null &&
        cost! > 0 &&
        people > 0 &&
        categories.values.any((selected) => selected);
  }
  // --- Date picker helper ---
  Future<void> pickDate({required bool isStart}) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );    if (selected != null) {
      setState(() {
        if (isStart) {
          startDate = selected;
        } else {
          endDate = selected;
        }
      });
    }
  }

  // --- Map time of day to API format ---
  String mapTimeOfDay(String timeOfDay) {
    switch (timeOfDay.toLowerCase()) {
      case 'morning':
        return 'morning';
      case 'noon':
        return 'noon';
      case 'evening':
        return 'evening';
      case 'night':
        return 'night';
      default:
        return 'morning';
    }
  }

  // --- Get selected categories ---
  List<String> getSelectedCategories() {
    List<String> selected = [];
    categories.forEach((key, value) {
      if (value) {
        // Map frontend category to API format (lowercase)
        String apiCategory = key.toLowerCase().replaceAll(' & ', '_').replaceAll(' ', '_');
        if (apiCategory == 'all') {
          apiCategory = 'general';
        } else if (apiCategory == 'natural') {
          apiCategory = 'nature';
        }
        selected.add(apiCategory);
      }
    });
    return selected;
  }

  // --- Submit trip plan ---
  Future<void> submitTripPlan() async {
    if (!isFormValid) return;

    setState(() {
      isLoading = true;
    });

    try {
      // Calculate trip duration
      final duration = endDate!.difference(startDate!).inDays + 1;

      // Create trip request
      final request = TripRequest(
        userId: "user123", // TODO: Replace with actual user ID from auth
        tripType: TripType(
          type: "greater_city",
          name: selectedCity!,
        ),
        targetCities: [selectedCity!],
        budget: cost!.toInt(),
        peopleCount: people,
        tripDuration: duration,
        tripStart: TripDateTime(
          date: DateFormat('yyyy-MM-dd').format(startDate!),
          daypart: mapTimeOfDay(startTime!),
        ),
        tripEnd: TripDateTime(
          date: DateFormat('yyyy-MM-dd').format(endDate!),
          daypart: mapTimeOfDay(endTime!),
        ),
        categories: getSelectedCategories(),
        preferences: TripPreferences(
          transportMode: "car", // Dummy data - TODO: Add to form
          restPreference: "moderate", // Dummy data - TODO: Add to form
          mealPreference: "local food", // Dummy data - TODO: Add to form
          pace: "balanced", // Dummy data - TODO: Add to form
        ),
      );      // Debug print (remove in production)
      debugPrint('Sending request to API...');
      debugPrint('City: $selectedCity');
      debugPrint('Budget: $cost');
      debugPrint('Duration: $duration days');

      // Call API
      final response = await TripService.createTrip(request);

      // Debug print (remove in production)
      debugPrint('Response received: ${response.tripPlanId}');

      // Navigate to timeline with response data
      if (mounted) {
        context.go('/trip-ai-planner/timeline', extra: response);
      }    } catch (e) {
      // Debug print (remove in production)
      debugPrint('Error creating trip: $e');

      // Show error dialog with better message
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red),
                SizedBox(width: 10),
                Text('Error'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Failed to create trip plan.'),
                SizedBox(height: 10),
                Text(
                  'Details: ${e.toString()}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                SizedBox(height: 10),
                Text(
                  'Please check your internet connection and try again.',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to timeline with dummy data as fallback
                  context.go('/trip-ai-planner/timeline');
                },
                child: const Text('View Sample'),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, d MMM yyyy');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        title: const Text(
          'Trip Planner AI Greater City',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            LucideIcons.chevronLeft,
            color: Colors.black,
            size: 25,
          ),
          onPressed: () => context.go('/trip-ai-planner'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Make your plan",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 25),

            // === Greater City Destination ===
            const Text(
              "Greater City Destinations",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF4d4d4d),
              ),
            ),
            const SizedBox(height: 9),
            DropdownButtonFormField<String>(
              value: selectedCity,
              hint: const Text(
                "Choose province",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                ),
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFFB5B5B5), width: 0.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFFB5B5B5), width: 0.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Color(0xFFB5B5B5), width: 0.5),
                ),
              ),
              icon: Icon(
                LucideIcons.chevronDown,
                color: Color(0xFFB5B5B5),
                size: 20,
              ),
              items: cities
                  .map(
                    (city) => DropdownMenuItem(value: city, child: Text(city)),
                  )
                  .toList(),
              onChanged: (val) => setState(() => selectedCity = val),
            ),
            const SizedBox(height: 25),

            // === Travel Dates ===
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Travel Dates",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF4d4d4d),
                        ),
                      ),
                      const SizedBox(height: 9),
                      GestureDetector(
                        onTap: () => pickDate(isStart: true),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFFB5B5B5)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            startDate != null
                                ? dateFormat.format(startDate!)
                                : 'Choose date',
                            style: TextStyle(
                              color: startDate != null
                                  ? Colors.black
                                  : Colors.black54,

                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Until",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF4d4d4d),
                        ),
                      ),
                      const SizedBox(height: 9),
                      GestureDetector(
                        onTap: () => pickDate(isStart: false),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            endDate != null
                                ? dateFormat.format(endDate!)
                                : 'Choose date',
                            style: TextStyle(
                              color: endDate != null
                                  ? Colors.black
                                  : Colors.black54,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // === Time Picker ===
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Start Time of Day",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF4d4d4d),
                        ),
                      ),
                      const SizedBox(height: 9),
                      DropdownButtonFormField<String>(
                        value: startTime,
                        hint: const Text(
                          "Choose time",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color(0xFFB5B5B5),
                              width: 0.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color(0xFFB5B5B5),
                              width: 0.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color(0xFFB5B5B5),
                              width: 0.5,
                            ),
                          ),
                        ),
                        icon: Icon(
                          LucideIcons.chevronDown,
                          color: Color(0xFFB5B5B5),
                          size: 20,
                        ),
                        items: timesOfDay
                            .map(
                              (t) => DropdownMenuItem(value: t, child: Text(t)),
                            )
                            .toList(),
                        onChanged: (val) => setState(() => startTime = val),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "End Time of Day",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF4d4d4d),
                        ),
                      ),
                      const SizedBox(height: 9),
                      DropdownButtonFormField<String>(
                        value: endTime,
                        hint: const Text(
                          "Choose time",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color(0xFFB5B5B5),
                              width: 0.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color(0xFFB5B5B5),
                              width: 0.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color(0xFFB5B5B5),
                              width: 0.5,
                            ),
                          ),
                        ),
                        icon: Icon(
                          LucideIcons.chevronDown,
                          color: Color(0xFFB5B5B5),
                          size: 20,
                        ),
                        items: timesOfDay
                            .map(
                              (t) => DropdownMenuItem(value: t, child: Text(t)),
                            )
                            .toList(),
                        onChanged: (val) => setState(() => endTime = val),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // === Cost & People ===
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Your Costs",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF4d4d4d),
                        ),
                      ),
                      const SizedBox(height: 9),
                      TextFormField(
                        decoration: InputDecoration(
                          hint: const Text(
                            "IDR",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color(0xFFB5B5B5),
                              width: 0.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color(0xFFB5B5B5),
                              width: 0.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color(0xFFB5B5B5),
                              width: 0.5,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          setState(() {
                            cost =
                                double.tryParse(
                                  val.replaceAll(RegExp(r'[^0-9]'), ''),
                                ) ??
                                0;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Number of People",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF4d4d4d),
                        ),
                      ),
                      const SizedBox(height: 9),
                      TextFormField(
                        decoration: InputDecoration(
                          hint: const Text(
                            "People +1",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color(0xFFB5B5B5),
                              width: 0.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color(0xFFB5B5B5),
                              width: 0.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Color(0xFFB5B5B5),
                              width: 0.5,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          setState(() {
                            people = int.tryParse(val) ?? 1;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // === Category Selection ===
            const Text(
              "Choose your category",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 25),

            ...categories.keys.map((key) {
              final selected = categories[key]!;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: selected ? Color(0xFFeef5fe) : Colors.transparent,
                  border: Border.all(
                    color: selected ? Color(0xFF539DF3) : Color(0xFFB5B5B5),
                    width: selected ? 1 : 0.5,
                  ),
                ),
                child: CheckboxListTile(
                  value: selected,
                  title: Row(
                    children: [
                      Icon(
                        categoryIcons[key],
                        size: 24,
                        color: Color(0xFF539DF3),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        key,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: selected
                              ? FontWeight.w500
                              : FontWeight.w400,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  onChanged: (val) => setState(() => categories[key] = val!),
                  activeColor: Colors.blue,
                  controlAffinity: ListTileControlAffinity.trailing,
                ),
              );
            }).toList(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50, // Set explicit height
        margin: const EdgeInsets.all(30),
        decoration: BoxDecoration(color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tourist Destination",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),                  Text(
                    selectedCity ?? 'Choose City',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF797979),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,              child: SizedBox(
                height: double.infinity,
                child: ElevatedButton(
                  onPressed: (isFormValid && !isLoading)
                      ? submitTripPlan
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (isFormValid && !isLoading)
                        ? const Color(0xFF539DF3)
                        : const Color(0xFFE5E7EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                    disabledBackgroundColor: const Color(0xFFE5E7EB),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          "Next Process",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: (isFormValid && !isLoading)
                                ? Colors.white
                                : const Color(0xFF6B7280),
                          ),
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
