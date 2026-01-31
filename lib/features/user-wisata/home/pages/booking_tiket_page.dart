import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

class BookingTiketPage extends StatefulWidget {
  final String destinationId;

  const BookingTiketPage({super.key, required this.destinationId});

  @override
  State<BookingTiketPage> createState() => _BookingTiketPageState();
}

class _BookingTiketPageState extends State<BookingTiketPage> {
  DateTime? startDate;
  DateTime? endDate;

  // Passenger data
  List<Map<String, dynamic>> passengers = [];
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    super.dispose();
  }

  void addPassenger() {
    setState(() {
      passengers.add({
        'name': TextEditingController(),
        'gender': 'Mr.',
        'phone': TextEditingController(),
        'email': TextEditingController(),
        'countryCode': '+62',
      });
    });
  }

  void removePassenger(int index) {
    setState(() {
      passengers[index]['name'].dispose();
      passengers[index]['phone'].dispose();
      passengers[index]['email'].dispose();
      passengers.removeAt(index);
    });
  }

  bool get isFormValid {
    // Check if there's at least one passenger
    if (passengers.isEmpty) return false;

    // Check if from and date are filled
    if (fromController.text.trim().isEmpty) return false;
    if (startDate == null) return false;

    // Check if all passengers have complete data
    for (var passenger in passengers) {
      final name = passenger['name'] as TextEditingController;
      // final phone = passenger['phone'] as TextEditingController; // Phone validation disabled for now
      final email = passenger['email'] as TextEditingController;

      if (name.text.trim().isEmpty) return false;
      // if (phone.text.trim().isEmpty) return false; // Phone validation disabled for now
      if (email.text.trim().isEmpty) return false;

      // Basic email validation
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email.text.trim())) return false;
    }

    return true;
  }

  String _getValidationMessage() {
    List<String> issues = [];

    // Check origin
    if (fromController.text.trim().isEmpty) {
      issues.add('• Fill in "Where are you from?"');
    }

    // Check date
    if (startDate == null) {
      issues.add('• Select travel date');
    }

    // Check passengers
    if (passengers.isEmpty) {
      issues.add('• Add at least 1 passenger');
    } else {
      // Check each passenger
      for (int i = 0; i < passengers.length; i++) {
        final passenger = passengers[i];
        final name = passenger['name'] as TextEditingController;
        final email = passenger['email'] as TextEditingController;

        List<String> passengerIssues = [];

        if (name.text.trim().isEmpty) {
          passengerIssues.add('name');
        }

        if (email.text.trim().isEmpty) {
          passengerIssues.add('email');
        } else {
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailRegex.hasMatch(email.text.trim())) {
            passengerIssues.add('valid email');
          }
        }

        if (passengerIssues.isNotEmpty) {
          issues.add('• Passenger ${i + 1}: ${passengerIssues.join(", ")}');
        }
      }
    }

    return issues.isEmpty ? 'All fields are complete!' : issues.join('\n');
  }

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

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, d MMM yyyy');
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;
    final scale = isSmallScreen ? 0.85 : (screenWidth / 375).clamp(0.85, 1.1);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        toolbarHeight: isSmallScreen ? 56 : 70,
        backgroundColor: const Color(0xFFF4F4F4),
        title: Text(
          'Book Tickets',
          style: TextStyle(
            color: Colors.black,
            fontSize: (16 * scale).clamp(14.0, 18.0),
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            LucideIcons.chevronLeft,
            color: Colors.black,
            size: (25 * scale).clamp(22.0, 28.0),
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16 : 30,
          vertical: isSmallScreen ? 16 : 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Background Image with Curve
                ClipPath(
                  child: Container(
                    height: isSmallScreen
                        ? screenHeight * 0.18
                        : screenHeight * 0.22,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 8 : 12,
                      ),
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://abkistimewa.id/sekolah/assets/gallery/berita/42-20231102095419-13961295776543B81BC6EA9.jpeg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          isSmallScreen ? 8 : 12,
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.2),
                            Colors.black.withOpacity(0.5),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Content over image
                // Content over image
                Container(
                  height: isSmallScreen
                      ? screenHeight * 0.18
                      : screenHeight * 0.22,
                  padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "kampoeng Heritage Kajoetangan",
                      style: TextStyle(
                        fontSize: (24 * scale).clamp(20.0, 28.0),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: isSmallScreen ? 16 : 25),
            Text(
              "Destination",
              style: TextStyle(
                fontSize: (20 * scale).clamp(18.0, 24.0),
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: isSmallScreen ? 16 : 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Where are you from?",
                  style: TextStyle(
                    fontSize: (15 * scale).clamp(13.0, 17.0),
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 9),
                TextFormField(
                  controller: fromController,
                  decoration: InputDecoration(
                    hintText: "e.g. Surabaya",
                    hintStyle: TextStyle(
                      fontSize: (15 * scale).clamp(13.0, 17.0),
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                    suffixIcon: Icon(
                      LucideIcons.mapPin,
                      color: Colors.black54,
                      size: (20 * scale).clamp(18.0, 24.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
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
                  keyboardType: TextInputType.text,
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Travel Dates",
                  style: TextStyle(
                    fontSize: (14 * scale).clamp(12.0, 16.0),
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
                      vertical: 16,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFB5B5B5), width: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          startDate != null
                              ? dateFormat.format(startDate!)
                              : 'Choose date',
                          style: TextStyle(
                            color: startDate != null
                                ? Colors.black87
                                : Colors.black54,
                            fontSize: (15 * scale).clamp(13.0, 17.0),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Icon(
                          LucideIcons.calendar,
                          color: Colors.black54,
                          size: (20 * scale).clamp(18.0, 24.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Passenger List
            SizedBox(height: isSmallScreen ? 20 : 30),
            ...List.generate(passengers.length, (index) {
              return _buildPassengerForm(index, isSmallScreen);
            }),

            // Add Passenger Button
            if (passengers.isEmpty || passengers.length < 10)
              Padding(
                padding: EdgeInsets.only(top: isSmallScreen ? 12 : 20),
                child: ElevatedButton(
                  onPressed: addPassenger,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 8 : 12,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 12 : 14,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.userPlus,
                        color: Color(0xFF539DF3),
                        size: (20 * scale).clamp(18.0, 24.0),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Add Passenger',
                        style: TextStyle(
                          color: Color(0xFF539DF3),
                          fontSize: (15 * scale).clamp(13.0, 17.0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Validation Warning Message
            if (!isFormValid)
              Padding(
                padding: EdgeInsets.only(top: isSmallScreen ? 12 : 20),
                child: Container(
                  padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
                    border: Border.all(color: Color(0xFFFF9800), width: 1),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Color(0xFFFF9800),
                        size: (20 * scale).clamp(18.0, 24.0),
                      ),
                      SizedBox(width: isSmallScreen ? 8 : 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Complete the form to continue',
                              style: TextStyle(
                                fontSize: (14 * scale).clamp(12.0, 16.0),
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFE65100),
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              _getValidationMessage(),
                              style: TextStyle(
                                fontSize: (13 * scale).clamp(11.0, 15.0),
                                color: Color(0xFFE65100),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          final bottomScale = constraints.maxWidth / 375;
          final isSmallBottom = constraints.maxWidth < 600;
          return Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Container(
              height: isSmallBottom ? 44 : 50,
              margin: EdgeInsets.all(isSmallBottom ? 16 : 30),
              decoration: BoxDecoration(color: Colors.transparent),
              child: SizedBox(
                height: double.infinity,
                child: ElevatedButton(
                  onPressed: isFormValid
                      ? () {
                          _showBookingSummary();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF539DF3),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallBottom ? 10 : 16,
                      vertical: isSmallBottom ? 8 : 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        isSmallBottom ? 8 : 12,
                      ),
                    ),
                    elevation: 0,
                    disabledBackgroundColor: const Color(0xFFF3F4F6),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Booking Ticket",
                      style: TextStyle(
                        fontSize: (16 * bottomScale).clamp(
                          isSmallBottom ? 12.0 : 14.0,
                          18.0,
                        ),
                        fontWeight: FontWeight.w600,
                        color: isFormValid ? Colors.white : Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showBookingSummary() {
    final dateFormat = DateFormat('EEE, d MMM yyyy');
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final scale = isSmallScreen ? 0.85 : (screenWidth / 375).clamp(0.85, 1.1);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
          ),
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 14 : 20),
                  decoration: BoxDecoration(
                    color: Color(0xFF539DF3),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(isSmallScreen ? 12 : 16),
                      topRight: Radius.circular(isSmallScreen ? 12 : 16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.clipboardCheck,
                        color: Colors.white,
                        size: (24 * scale).clamp(20.0, 28.0),
                      ),
                      SizedBox(width: isSmallScreen ? 8 : 12),
                      Text(
                        'Booking Summary',
                        style: TextStyle(
                          fontSize: (18 * scale).clamp(16.0, 22.0),
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isSmallScreen ? 14 : 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Destination Info
                        _buildSummarySection('Destination', [
                          _buildSummaryItem('From', fromController.text),
                          _buildSummaryItem(
                            'Date',
                            dateFormat.format(startDate!),
                          ),
                        ]),

                        Divider(height: isSmallScreen ? 20 : 30, thickness: 1),

                        // Passengers List
                        Text(
                          'Passengers (${passengers.length})',
                          style: TextStyle(
                            fontSize: (16 * scale).clamp(14.0, 18.0),
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 8 : 12),

                        ...List.generate(passengers.length, (index) {
                          final passenger = passengers[index];
                          return Container(
                            margin: EdgeInsets.only(
                              bottom: isSmallScreen ? 8 : 12,
                            ),
                            padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                            decoration: BoxDecoration(
                              color: Color(0xFFF8F8F8),
                              borderRadius: BorderRadius.circular(
                                isSmallScreen ? 6 : 8,
                              ),
                              border: Border.all(
                                color: Color(0xFFE5E5E5),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isSmallScreen ? 6 : 8,
                                        vertical: isSmallScreen ? 3 : 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF539DF3),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'Passenger ${index + 1}',
                                        style: TextStyle(
                                          fontSize: (11 * scale).clamp(
                                            10.0,
                                            13.0,
                                          ),
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: isSmallScreen ? 6 : 8),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: Color(0xFF539DF3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        passenger['gender'],
                                        style: TextStyle(
                                          fontSize: (11 * scale).clamp(
                                            10.0,
                                            13.0,
                                          ),
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF539DF3),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: isSmallScreen ? 6 : 8),
                                Text(
                                  (passenger['name'] as TextEditingController)
                                      .text,
                                  style: TextStyle(
                                    fontSize: (14 * scale).clamp(12.0, 16.0),
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: isSmallScreen ? 3 : 4),
                                Row(
                                  children: [
                                    Icon(
                                      LucideIcons.phone,
                                      size: (12 * scale).clamp(11.0, 14.0),
                                      color: Colors.grey[600],
                                    ),
                                    SizedBox(width: isSmallScreen ? 3 : 4),
                                    Text(
                                      (passenger['phone']
                                              as TextEditingController)
                                          .text,
                                      style: TextStyle(
                                        fontSize: (12 * scale).clamp(
                                          11.0,
                                          14.0,
                                        ),
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: isSmallScreen ? 1 : 2),
                                Row(
                                  children: [
                                    Icon(
                                      LucideIcons.mail,
                                      size: (12 * scale).clamp(11.0, 14.0),
                                      color: Colors.grey[600],
                                    ),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        (passenger['email']
                                                as TextEditingController)
                                            .text,
                                        style: TextStyle(
                                          fontSize: (12 * scale).clamp(
                                            11.0,
                                            14.0,
                                          ),
                                          color: Colors.grey[600],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),

                // Actions
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 14 : 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Color(0xFFE5E5E5), width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: Color(0xFF539DF3),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                isSmallScreen ? 8 : 12,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: isSmallScreen ? 10 : 12,
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Color(0xFF539DF3),
                              fontSize: (14 * scale).clamp(12.0, 16.0),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 8 : 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            showSuccessNotification(
                              context,
                              "Your booking for ${passengers.length} passenger(s) to Kampoeng Heritage Kajoetangan has been confirmed",
                              "Booking Confirmed!",
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF539DF3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                isSmallScreen ? 8 : 12,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: isSmallScreen ? 10 : 12,
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Confirm',
                            style: TextStyle(
                              fontSize: (14 * scale).clamp(12.0, 16.0),
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummarySection(String title, List<Widget> items) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = screenWidth / 375;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: (16 * scale).clamp(14.0, 18.0),
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        ...items,
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = screenWidth / 375;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: (13 * scale).clamp(11.0, 15.0),
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            ': ',
            style: TextStyle(
              fontSize: (13 * scale).clamp(11.0, 15.0),
              color: Colors.grey[600],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: (13 * scale).clamp(11.0, 15.0),
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerForm(int index, bool isSmallScreen) {
    final passenger = passengers[index];
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = isSmallScreen ? 0.85 : (screenWidth / 375).clamp(0.85, 1.1);

    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 16 : 25),
      padding: EdgeInsets.all(isSmallScreen ? 14 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with passenger number and delete button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Passenger ${index + 1}',
                style: TextStyle(
                  fontSize: (18 * scale).clamp(16.0, 22.0),
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              if (passengers.length > 1)
                IconButton(
                  onPressed: () => removePassenger(index),
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: (24 * scale).clamp(20.0, 28.0),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
            ],
          ),

          SizedBox(height: 20),

          // Name
          Text(
            "Name",
            style: TextStyle(
              fontSize: (14 * scale).clamp(12.0, 16.0),
              fontWeight: FontWeight.w400,
              color: Color(0xFF4d4d4d),
            ),
          ),
          const SizedBox(height: 9),
          TextFormField(
            controller: passenger['name'],
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: "Enter passenger name",
              hintStyle: TextStyle(
                fontSize: (15 * scale).clamp(13.0, 17.0),
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
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
            keyboardType: TextInputType.name,
          ),

          SizedBox(height: isSmallScreen ? 12 : 20),

          // Gender Selection
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      passenger['gender'] = 'Mr.';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 10 : 12,
                    ),
                    decoration: BoxDecoration(
                      color: passenger['gender'] == 'Mr.'
                          ? Color(0xFF539DF3)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 8 : 12,
                      ),
                      border: Border.all(
                        color: passenger['gender'] == 'Mr.'
                            ? Color(0xFF539DF3)
                            : Color(0xFFB5B5B5),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: passenger['gender'] == 'Mr.'
                                ? Colors.white
                                : Colors.transparent,
                            border: Border.all(
                              color: passenger['gender'] == 'Mr.'
                                  ? Colors.white
                                  : Color(0xFFB5B5B5),
                              width: 1,
                            ),
                          ),
                          child: passenger['gender'] == 'Mr.'
                              ? Center(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF539DF3),
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Mr.',
                          style: TextStyle(
                            fontSize: (15 * scale).clamp(13.0, 17.0),
                            fontWeight: FontWeight.w500,
                            color: passenger['gender'] == 'Mr.'
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      passenger['gender'] = 'Mrs.';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 10 : 12,
                    ),
                    decoration: BoxDecoration(
                      color: passenger['gender'] == 'Mrs.'
                          ? Color(0xFF539DF3)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 8 : 12,
                      ),
                      border: Border.all(
                        color: passenger['gender'] == 'Mrs.'
                            ? Color(0xFF539DF3)
                            : Color(0xFFB5B5B5),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: passenger['gender'] == 'Mrs.'
                                ? Colors.white
                                : Colors.transparent,
                            border: Border.all(
                              color: passenger['gender'] == 'Mrs.'
                                  ? Colors.white
                                  : Color(0xFFB5B5B5),
                              width: 1,
                            ),
                          ),
                          child: passenger['gender'] == 'Mrs.'
                              ? Center(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF539DF3),
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Mrs.',
                          style: TextStyle(
                            fontSize: (15 * scale).clamp(13.0, 17.0),
                            fontWeight: FontWeight.w500,
                            color: passenger['gender'] == 'Mrs.'
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      passenger['gender'] = 'Ms.';
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 10 : 12,
                    ),
                    decoration: BoxDecoration(
                      color: passenger['gender'] == 'Ms.'
                          ? Color(0xFF539DF3)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 8 : 12,
                      ),
                      border: Border.all(
                        color: passenger['gender'] == 'Ms.'
                            ? Color(0xFF539DF3)
                            : Color(0xFFB5B5B5),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: passenger['gender'] == 'Ms.'
                                ? Colors.white
                                : Colors.transparent,
                            border: Border.all(
                              color: passenger['gender'] == 'Ms.'
                                  ? Colors.white
                                  : Color(0xFFB5B5B5),
                              width: 1,
                            ),
                          ),
                          child: passenger['gender'] == 'Ms.'
                              ? Center(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF539DF3),
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Ms.',
                          style: TextStyle(
                            fontSize: (15 * scale).clamp(13.0, 17.0),
                            fontWeight: FontWeight.w500,
                            color: passenger['gender'] == 'Ms.'
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: isSmallScreen ? 12 : 20),

          // Phone Number
          Text(
            "Number",
            style: TextStyle(
              fontSize: (14 * scale).clamp(12.0, 16.0),
              fontWeight: FontWeight.w400,
              color: Color(0xFF4d4d4d),
            ),
          ),
          SizedBox(height: isSmallScreen ? 6 : 9),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 10 : 12,
                  vertical: isSmallScreen ? 12 : 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFB5B5B5), width: 0.5),
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        image: DecorationImage(
                          image: NetworkImage('https://flagcdn.com/w80/id.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: passenger['phone'],
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: "+62 853-3573-3052",
                    hintStyle: TextStyle(
                      fontSize: (15 * scale).clamp(13.0, 17.0),
                      color: Colors.black54,
                      fontWeight: FontWeight.w400,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 12 : 16,
                      vertical: isSmallScreen ? 12 : 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 8 : 12,
                      ),
                      borderSide: BorderSide(
                        color: Color(0xFFB5B5B5),
                        width: 0.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 8 : 12,
                      ),
                      borderSide: BorderSide(
                        color: Color(0xFFB5B5B5),
                        width: 0.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 8 : 12,
                      ),
                      borderSide: BorderSide(
                        color: Color(0xFFB5B5B5),
                        width: 0.5,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
            ],
          ),

          SizedBox(height: isSmallScreen ? 12 : 20),

          // Email
          Text(
            "Email",
            style: TextStyle(
              fontSize: (14 * scale).clamp(12.0, 16.0),
              fontWeight: FontWeight.w400,
              color: Color(0xFF4d4d4d),
            ),
          ),
          SizedBox(height: isSmallScreen ? 6 : 9),
          TextFormField(
            controller: passenger['email'],
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: "Enter email address",
              hintStyle: TextStyle(
                fontSize: (15 * scale).clamp(13.0, 17.0),
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 12 : 16,
                vertical: isSmallScreen ? 12 : 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
                borderSide: BorderSide(color: Color(0xFFB5B5B5), width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
                borderSide: BorderSide(color: Color(0xFFB5B5B5), width: 0.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
                borderSide: BorderSide(color: Color(0xFFB5B5B5), width: 0.5),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }
}
