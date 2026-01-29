import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../services/trip_service.dart';
import '../models/trip_request_model.dart';
import '../widgets/trip_error_dialog.dart';

class KategoriCityPage extends StatefulWidget {
  const KategoriCityPage({super.key});

  @override
  State<KategoriCityPage> createState() => _KategoriCityPageState();
}

class _KategoriCityPageState extends State<KategoriCityPage> {
  // --- Data & Controller ---
  final List<String> cities = [
    'Surabaya',
    'Bandung',
    'Semarang',
    'Yogyakarta',
    'Solo',
    'Denpasar',
    'Malang',
    'Batu',
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

  // Controller untuk cost input
  final TextEditingController _costController = TextEditingController();

  @override
  void dispose() {
    _costController.dispose();
    super.dispose();
  }

  // Format number dengan pemisah ribuan (titik)
  String formatCurrency(String value) {
    if (value.isEmpty) return '';

    // Hapus semua karakter non-digit
    final number = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (number.isEmpty) return '';

    // Parse ke integer
    final intValue = int.parse(number);

    // Format dengan pemisah ribuan
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(intValue).replaceAll(',', '.');
  }

  // --- Form validation ---
  bool _hasTimeError() {
    if (startDate == null || endDate == null || startTime == null || endTime == null) {
      return false;
    }

    final isSameDay = startDate!.year == endDate!.year &&
        startDate!.month == endDate!.month &&
        startDate!.day == endDate!.day;
    
    if (isSameDay) {
      final timeOrder = ['Morning', 'Noon', 'Evening', 'Night'];
      final startIndex = timeOrder.indexOf(startTime!);
      final endIndex = timeOrder.indexOf(endTime!);
      
      return startIndex > endIndex;
    }

    return false;
  }

  String? _validateForm() {
    // 1. Check if all required fields are filled
    if (selectedCity == null) return 'Please select a city';
    if (selectedCity != 'Malang') return 'Only Malang is available';
    if (startDate == null) return 'Please select start date';
    if (endDate == null) return 'Please select end date';
    if (startTime == null) return 'Please select start time of day';
    if (endTime == null) return 'Please select end time of day';
    if (cost == null || cost! <= 0) return 'Please enter your budget';
    if (!categories.values.any((selected) => selected)) {
      return 'Please select at least one category';
    }

    // 2. Validate start date is before or equal to end date
    if (startDate!.isAfter(endDate!)) {
      return 'Start date must be before or equal to end date';
    }

    // 3. Validate time of day if it's a single day trip
    final isSameDay = startDate!.year == endDate!.year &&
        startDate!.month == endDate!.month &&
        startDate!.day == endDate!.day;
    
    if (isSameDay) {
      final timeOrder = ['Morning', 'Noon', 'Evening', 'Night'];
      final startIndex = timeOrder.indexOf(startTime!);
      final endIndex = timeOrder.indexOf(endTime!);
      
      if (startIndex > endIndex) {
        return 'For same-day trips, start time must be before end time';
      }
    }

    // 4. Validate minimum cost (100,000 IDR)
    if (cost! < 100000) {
      return 'Minimum budget is IDR 100,000';
    }

    // 5. Validate number of people (1-10)
    if (people < 1) {
      return 'Number of people must be at least 1';
    }
    if (people > 10) {
      return 'Number of people cannot exceed 10';
    }

    return null; // Form is valid
  }

  bool get isFormValid => _validateForm() == null;

  // --- Date picker helper ---
  Future<void> pickDate({required bool isStart}) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (selected != null) {
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
      if (value && key != 'All') {
        // Map frontend category to API format (lowercase)
        String apiCategory = key
            .toLowerCase()
            .replaceAll(' & ', '_')
            .replaceAll(' ', '_');
        if (apiCategory == 'natural') {
          apiCategory = 'nature';
        }
        selected.add(apiCategory);
      }
    });
    return selected;
  }

  // --- Handle "All" checkbox ---
  void handleAllCheckbox(bool? value) {
    setState(() {
      if (value == true) {
        // Check all categories
        categories.forEach((key, _) {
          categories[key] = true;
        });
      } else {
        // Uncheck all categories
        categories.forEach((key, _) {
          categories[key] = false;
        });
      }
    });
  }

  // --- Handle individual category checkbox ---
  void handleCategoryCheckbox(String key, bool? value) {
    setState(() {
      if (key == 'All') {
        handleAllCheckbox(value);
      } else {
        categories[key] = value!;
        // If any category is unchecked, uncheck "All"
        if (!value) {
          categories['All'] = false;
        } else {
          // Check if all other categories are checked
          bool allOthersChecked = true;
          categories.forEach((k, v) {
            if (k != 'All' && !v) {
              allOthersChecked = false;
            }
          });
          if (allOthersChecked) {
            categories['All'] = true;
          }
        }
      }
    });
  }

  // --- Submit trip plan ---
  Future<void> submitTripPlan() async {
    // Validate form and show error if invalid
    final validationError = _validateForm();
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(LucideIcons.info, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  validationError,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          backgroundColor: Color(0xFFEF4444),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: Duration(seconds: 4),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Calculate trip duration
      final duration = endDate!.difference(startDate!).inDays + 1;

      // Create trip request
      final request = TripRequest(
        userId: "user123", // TODO: Replace with actual user ID from auth
        tripType: TripType(type: "city", name: selectedCity!),
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
      );

      // Debug print (remove in production)
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
      }
    } catch (e) {
      // Debug print (remove in production)
      debugPrint('Error creating trip: $e');

      // Show error dialog with platform-aware message
      if (mounted) {
        TripErrorDialog.show(context, e.toString());
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final horizontalPadding = isSmallScreen ? 16.0 : 30.0;
    final titleFontSize = isSmallScreen ? 18.0 : 20.0;
    final labelFontSize = isSmallScreen ? 13.0 : 14.0;
    final inputFontSize = isSmallScreen ? 14.0 : 15.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        title: Text(
          'Trip Planner AI City',
          style: TextStyle(
            fontSize: isSmallScreen ? 15.0 : 16.0,
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
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Make your plan",
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: isSmallScreen ? 20 : 25),

            // === City Destination ===
            Text(
              "City Destinations",
              style: TextStyle(
                fontSize: labelFontSize,
                fontWeight: FontWeight.w400,
                color: Color(0xFF4d4d4d),
              ),
            ),
            const SizedBox(height: 9),
            DropdownButtonFormField<String>(
              value: selectedCity,
              hint: Text(
                "Choose city",
                style: TextStyle(
                  fontSize: inputFontSize,
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
              onChanged: (val) {
                if (val != null && val != 'Malang') {
                  // Show alert dialog if city is not Malang
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: Row(
                        children: [
                          Icon(
                            LucideIcons.mapPin,
                            color: Color(0xFF539DF3),
                            size: 24,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Service Limitation',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      content: Text(
                        'Loka is currently only available for destinations in Malang Raya. Please select \'Malang\' as your city destination.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Reset to null or set to Malang
                            setState(() => selectedCity = null);
                          },
                          child: Text(
                            'OK',
                            style: TextStyle(
                              color: Color(0xFF539DF3),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  setState(() => selectedCity = val);
                }
              },
            ),
            
            // Info banner for Malang-only service
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFEEF5FE),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Color(0xFF539DF3).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    LucideIcons.info,
                    color: Color(0xFF539DF3),
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Currently, Loka services are exclusively available for Malang Raya destinations.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1E40AF),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: isSmallScreen ? 20 : 25),

            // === Travel Dates ===
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Travel Dates",
                        style: TextStyle(
                          fontSize: labelFontSize,
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
                            border: Border.all(
                              color: (startDate != null && endDate != null && startDate!.isAfter(endDate!))
                                  ? Color(0xFFEF4444)
                                  : Color(0xFFB5B5B5),
                              width: 0.5,
                            ),
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
                              fontSize: inputFontSize,
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
                      Text(
                        "Until",
                        style: TextStyle(
                          fontSize: labelFontSize,
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
                            border: Border.all(
                              color: (startDate != null && endDate != null && startDate!.isAfter(endDate!))
                                  ? Color(0xFFEF4444)
                                  : Colors.grey.shade300,
                            ),
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
                              fontSize: inputFontSize,
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
            // Show error message if dates are invalid
            if (startDate != null && endDate != null && startDate!.isAfter(endDate!))
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  children: [
                    Icon(LucideIcons.info, size: 14, color: Color(0xFFEF4444)),
                    SizedBox(width: 4),
                    Text(
                      'Start date must be before or equal to end date',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: isSmallScreen ? 20 : 25),

            // === Time Picker ===
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Start Time of Day",
                        style: TextStyle(
                          fontSize: labelFontSize,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF4d4d4d),
                        ),
                      ),
                      const SizedBox(height: 9),
                      DropdownButtonFormField<String>(
                        value: startTime,
                        hint: Text(
                          "Choose time",
                          style: TextStyle(
                            fontSize: inputFontSize,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: _hasTimeError() ? Color(0xFFEF4444) : Color(0xFFB5B5B5),
                              width: 0.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: _hasTimeError() ? Color(0xFFEF4444) : Color(0xFFB5B5B5),
                              width: 0.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: _hasTimeError() ? Color(0xFFEF4444) : Color(0xFFB5B5B5),
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
                      Text(
                        "End Time of Day",
                        style: TextStyle(
                          fontSize: labelFontSize,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF4d4d4d),
                        ),
                      ),
                      const SizedBox(height: 9),
                      DropdownButtonFormField<String>(
                        value: endTime,
                        hint: Text(
                          "Choose time",
                          style: TextStyle(
                            fontSize: inputFontSize,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: _hasTimeError() ? Color(0xFFEF4444) : Color(0xFFB5B5B5),
                              width: 0.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: _hasTimeError() ? Color(0xFFEF4444) : Color(0xFFB5B5B5),
                              width: 0.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: _hasTimeError() ? Color(0xFFEF4444) : Color(0xFFB5B5B5),
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
            // Show error message if time order is invalid for same-day trips
            if (_hasTimeError())
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  children: [
                    Icon(LucideIcons.info, size: 14, color: Color(0xFFEF4444)),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'For same-day trips, start time must be before end time',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  ],
                ),
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
                        controller: _costController,
                        decoration: InputDecoration(
                          hintText: "IDR",
                          hintStyle: const TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                          helperText: 'Min: IDR 100,000',
                          helperStyle: TextStyle(
                            fontSize: 11,
                            color: (cost != null && cost! > 0 && cost! < 100000) 
                                ? Color(0xFFEF4444) 
                                : Colors.grey.shade600,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: (cost != null && cost! > 0 && cost! < 100000)
                                  ? Color(0xFFEF4444)
                                  : Color(0xFFB5B5B5),
                              width: 0.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: (cost != null && cost! > 0 && cost! < 100000)
                                  ? Color(0xFFEF4444)
                                  : Color(0xFFB5B5B5),
                              width: 0.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: (cost != null && cost! > 0 && cost! < 100000)
                                  ? Color(0xFFEF4444)
                                  : Color(0xFFB5B5B5),
                              width: 0.5,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          // Hapus semua karakter non-digit untuk mendapatkan nilai asli
                          final cleanValue = val.replaceAll(
                            RegExp(r'[^0-9]'),
                            '',
                          );

                          if (cleanValue.isNotEmpty) {
                            // Update nilai cost (untuk backend)
                            setState(() {
                              cost = double.tryParse(cleanValue) ?? 0;
                            });

                            // Format untuk tampilan
                            final formattedValue = formatCurrency(cleanValue);

                            // Update text field dengan format
                            _costController.value = TextEditingValue(
                              text: formattedValue,
                              selection: TextSelection.collapsed(
                                offset: formattedValue.length,
                              ),
                            );
                          } else {
                            setState(() {
                              cost = 0;
                            });
                          }
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
                      Text(
                        "Number of People",
                        style: TextStyle(
                          fontSize: isSmallScreen ? 11.0 : 12.0,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF4d4d4d),
                        ),
                      ),
                      const SizedBox(height: 9),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "People + 1",
                          hintStyle: TextStyle(
                            fontSize: inputFontSize,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                          ),
                          helperText: '1-10 people',
                          helperStyle: TextStyle(
                            fontSize: 11,
                            color: (people < 1 || people > 10) 
                                ? Color(0xFFEF4444) 
                                : Colors.grey.shade600,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: (people < 1 || people > 10)
                                  ? Color(0xFFEF4444)
                                  : Color(0xFFB5B5B5),
                              width: 0.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: (people < 1 || people > 10)
                                  ? Color(0xFFEF4444)
                                  : Color(0xFFB5B5B5),
                              width: 0.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: (people < 1 || people > 10)
                                  ? Color(0xFFEF4444)
                                  : Color(0xFFB5B5B5),
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
            SizedBox(height: isSmallScreen ? 30 : 40),

            // === Category Selection ===
            Text(
              "Choose your category",
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: isSmallScreen ? 20 : 25),

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
                          fontSize: labelFontSize,
                          fontWeight: selected
                              ? FontWeight.w500
                              : FontWeight.w400,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  onChanged: (val) => handleCategoryCheckbox(key, val),
                  activeColor: Colors.blue,
                  controlAffinity: ListTileControlAffinity.trailing,
                ),
              );
            }).toList(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        margin: EdgeInsets.all(isSmallScreen ? 16 : 30),
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
                      fontSize: isSmallScreen ? 11 : 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    selectedCity ?? 'Choose City',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 11 : 12,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF797979),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: isSmallScreen ? 8 : 12),
            Expanded(
              flex: 3,
              child: SizedBox(
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
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 12 : 16,
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
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          "Next Process",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
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
