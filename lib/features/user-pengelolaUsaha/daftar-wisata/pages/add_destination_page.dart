import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class AddDestinationPage extends StatefulWidget {
  const AddDestinationPage({super.key});

  @override
  State<AddDestinationPage> createState() => _AddDestinationPageState();
}

class _AddDestinationPageState extends State<AddDestinationPage> {
  // Current section index (0: Basic Information, 1: Location, 2: Operating Hours, 3: Tickets & Tours)
  int currentSection = 0;

  // Controllers for Basic Information
  final TextEditingController destinationNameController =
      TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Controllers for Location
  final TextEditingController fullAddressController = TextEditingController();
  String? selectedProvince;
  String? selectedCity;

  // Controllers for Operating Hours
  final TextEditingController openingHoursController = TextEditingController();
  final TextEditingController closingHoursController = TextEditingController();
  TimeOfDay? selectedOpeningTime;
  TimeOfDay? selectedClosingTime;

  // Lists for Tickets & Tours
  List<Map<String, dynamic>> ticketsList = [];
  List<Map<String, dynamic>> toursList = [];

  // Lists for Activities & Categories
  List<String> activitiesList = [];
  List<String> categoriesList = [];

  // 360° Experience option
  String? experience360Option; // null, 'skip', or 'request'

  // Selected images (for demo, using dummy data)
  List<Map<String, String>> selectedImages = [];

  // Dummy data for dropdowns
  final List<String> provinces = [
    'Bali',
    'Jawa Tengah',
    'Jawa Timur',
    'DKI Jakarta',
    'Jawa Barat',
  ];

  final Map<String, List<String>> cities = {
    'Bali': ['Denpasar', 'Badung', 'Gianyar', 'Tabanan'],
    'Jawa Tengah': ['Semarang', 'Solo', 'Magelang', 'Yogyakarta'],
    'Jawa Timur': ['Surabaya', 'Malang', 'Batu', 'Kediri'],
    'DKI Jakarta': ['Jakarta Pusat', 'Jakarta Selatan', 'Jakarta Utara'],
    'Jawa Barat': ['Bandung', 'Bogor', 'Bekasi', 'Depok'],
  };

  @override
  void dispose() {
    destinationNameController.dispose();
    descriptionController.dispose();
    fullAddressController.dispose();
    openingHoursController.dispose();
    closingHoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Color(0xFF212121)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Destinantion',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Section Stepper Card
          _buildSectionStepper(),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: currentSection == 0
                    ? _buildBasicInformationSection()
                    : currentSection == 1
                    ? _buildLocationSection()
                    : currentSection == 2
                    ? _buildOperatingHoursSection()
                    : currentSection == 3
                    ? _buildTicketsToursSection()
                    : currentSection == 4
                    ? _buildActivitiesCategoriesSection()
                    : _build360ExperienceSection(),
              ),
            ),
          ),

          // Bottom Action Button
          _buildBottomButton(),
        ],
      ),
    );
  }

  /// Section Stepper showing current step
  Widget _buildSectionStepper() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Section',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Step 1: Basic Information
                _buildStepItemCompact(
                  number: 1,
                  label: 'Basic Info',
                  isActive: currentSection == 0,
                  isCompleted: currentSection > 0,
                ),
                // Divider Line 1-2
                Container(
                  width: 16,
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  color: currentSection > 0
                      ? const Color(0xFF539DF3)
                      : const Color(0xFFE0E0E0),
                ),
                // Step 2: Location
                _buildStepItemCompact(
                  number: 2,
                  label: 'Location',
                  isActive: currentSection == 1,
                  isCompleted: currentSection > 1,
                ),
                // Divider Line 2-3
                Container(
                  width: 16,
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  color: currentSection > 1
                      ? const Color(0xFF539DF3)
                      : const Color(0xFFE0E0E0),
                ),
                // Step 3: Operating Hours
                _buildStepItemCompact(
                  number: 3,
                  label: 'Hours',
                  isActive: currentSection == 2,
                  isCompleted: currentSection > 2,
                ),
                // Divider Line 3-4
                Container(
                  width: 16,
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  color: currentSection > 2
                      ? const Color(0xFF539DF3)
                      : const Color(0xFFE0E0E0),
                ),
                // Step 4: Tickets & Tours
                _buildStepItemCompact(
                  number: 4,
                  label: 'Tickets',
                  isActive: currentSection == 3,
                  isCompleted: currentSection > 3,
                ),
                // Divider Line 4-5
                Container(
                  width: 16,
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  color: currentSection > 3
                      ? const Color(0xFF539DF3)
                      : const Color(0xFFE0E0E0),
                ),
                // Step 5: Activities & Categories
                _buildStepItemCompact(
                  number: 5,
                  label: 'Activities',
                  isActive: currentSection == 4,
                  isCompleted: currentSection > 4,
                ),
                // Divider Line 5-6
                Container(
                  width: 16,
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  color: currentSection > 4
                      ? const Color(0xFF539DF3)
                      : const Color(0xFFE0E0E0),
                ),
                // Step 6: 360° Experience
                _buildStepItemCompact(
                  number: 6,
                  label: '360°',
                  isActive: currentSection == 5,
                  isCompleted: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Compact Step Item for horizontal scrolling
  Widget _buildStepItemCompact({
    required int number,
    required String label,
    required bool isActive,
    required bool isCompleted,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Circle with number or check
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive || isCompleted
                ? const Color(0xFF539DF3)
                : const Color(0xFFE0E0E0),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(LucideIcons.check, size: 14, color: Colors.white)
                : Text(
                    '$number',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white : const Color(0xFF757575),
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 6),
        // Label
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive ? const Color(0xFF212121) : const Color(0xFF757575),
          ),
        ),
      ],
    );
  }

  /// Basic Information Section (Section 1)
  Widget _buildBasicInformationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        const Text(
          'Basic Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 20),

        // Destination Name
        const Text(
          'Destination Name',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: destinationNameController,
          decoration: InputDecoration(
            hintText: 'Nusa Dua Beach',
            hintStyle: const TextStyle(fontSize: 14, color: Color(0xFFBDBDBD)),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF539DF3), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // About the Destination
        const Text(
          'About the Destination',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: descriptionController,
          maxLines: 6,
          decoration: InputDecoration(
            hintText:
                'kawasan resor mewah di Bali Selatan yang terkenal dengan pasir putihnya, air laut tenang, dan fasilitas lengkap, ideal untuk keluarga dan liburan santai karena ombaknya aman untuk berenang',
            hintStyle: const TextStyle(fontSize: 14, color: Color(0xFFBDBDBD)),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF539DF3), width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),

        const SizedBox(height: 20),

        // Destination Photos
        const Text(
          'Destination Photos',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 8),

        // Upload Button
        GestureDetector(
          onTap: _pickImages,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF539DF3).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    LucideIcons.image,
                    size: 20,
                    color: Color(0xFF539DF3),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Upload high-quality images',
                  style: TextStyle(fontSize: 14, color: Color(0xFF757575)),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Selected Images List
        if (selectedImages.isNotEmpty)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: selectedImages.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return _buildImageItem(selectedImages[index], index);
            },
          ),

        const SizedBox(height: 20),
      ],
    );
  }

  /// Location Section (Section 2)
  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        const Text(
          'Location',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 20),

        // Full Address
        const Text(
          'Full Address',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: fullAddressController,
          decoration: InputDecoration(
            hintText: 'Street name, area, or landmark',
            hintStyle: const TextStyle(fontSize: 14, color: Color(0xFFBDBDBD)),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF539DF3), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Province Dropdown
        const Text(
          'Province',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedProvince,
          hint: const Text(
            'Select province',
            style: TextStyle(fontSize: 14, color: Color(0xFFBDBDBD)),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF539DF3), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          items: provinces.map((province) {
            return DropdownMenuItem(value: province, child: Text(province));
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedProvince = value;
              selectedCity = null; // Reset city when province changes
            });
          },
        ),

        const SizedBox(height: 20),

        // City Dropdown
        const Text(
          'City',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedCity,
          hint: const Text(
            'Select city',
            style: TextStyle(fontSize: 14, color: Color(0xFFBDBDBD)),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF539DF3), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          items: selectedProvince != null
              ? cities[selectedProvince!]!.map((city) {
                  return DropdownMenuItem(value: city, child: Text(city));
                }).toList()
              : [],
          onChanged: selectedProvince != null
              ? (value) {
                  setState(() {
                    selectedCity = value;
                  });
                }
              : null,
        ),

        const SizedBox(height: 20),

        // Pin Location
        const Text(
          'Pin Location',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 8),

        // Show map preview if location data is filled
        if (_isLocationFilled())
          _buildMapPreview()
        else
          GestureDetector(
            onTap: () {
              // TODO: Open map to select location
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Open map to select location')),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Adjust the pin on the map',
                    style: TextStyle(fontSize: 14, color: Color(0xFFBDBDBD)),
                  ),
                  const Icon(
                    LucideIcons.mapPin,
                    size: 20,
                    color: Color(0xFF757575),
                  ),
                ],
              ),
            ),
          ),

        const SizedBox(height: 20),
      ],
    );
  }

  /// Operating Hours Section (Section 3)
  Widget _buildOperatingHoursSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        const Text(
          'Operating Hours',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 20),

        // Opening Hours and Closing Hours in a Row
        Row(
          children: [
            // Opening Hours
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Opening Hours',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _selectTime(context, isOpening: true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedOpeningTime != null
                                ? _formatTime(selectedOpeningTime!)
                                : 'e.g. 07:00',
                            style: TextStyle(
                              fontSize: 14,
                              color: selectedOpeningTime != null
                                  ? const Color(0xFF212121)
                                  : const Color(0xFFBDBDBD),
                            ),
                          ),
                          const Icon(
                            LucideIcons.clock,
                            size: 18,
                            color: Color(0xFF757575),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Closing Hours
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Closing Hours',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _selectTime(context, isOpening: false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedClosingTime != null
                                ? _formatTime(selectedClosingTime!)
                                : 'e.g. 17:00',
                            style: TextStyle(
                              fontSize: 14,
                              color: selectedClosingTime != null
                                  ? const Color(0xFF212121)
                                  : const Color(0xFFBDBDBD),
                            ),
                          ),
                          const Icon(
                            LucideIcons.clock,
                            size: 18,
                            color: Color(0xFF757575),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  /// Tickets & Tours Section (Section 4)
  Widget _buildTicketsToursSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        const Text(
          'Tickets & Tours',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 20),

        // Ticket Pricing
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Ticket Pricing',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF212121),
              ),
            ),
            TextButton(
              onPressed: _showAddTicketDialog,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Add Ticket',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF539DF3),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Tickets List
        if (ticketsList.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: const Text(
              'No tickets added yet',
              style: TextStyle(fontSize: 14, color: Color(0xFF9E9E9E)),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ticketsList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return _buildTicketItem(ticketsList[index], index);
            },
          ),

        const SizedBox(height: 24),

        // Available Tours
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Available Tours',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF212121),
              ),
            ),
            TextButton(
              onPressed: _showAddTourDialog,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Add Tours',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF539DF3),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Tours List
        if (toursList.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: const Text(
              'No tours added yet',
              style: TextStyle(fontSize: 14, color: Color(0xFF9E9E9E)),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: toursList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return _buildTourItem(toursList[index], index);
            },
          ),

        const SizedBox(height: 20),
      ],
    );
  }

  /// Activities & Categories Section (Section 5)
  Widget _buildActivitiesCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        const Text(
          'Activities & Categories',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 20),

        // Activities & Attractions
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Activities & Attractions',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF212121),
              ),
            ),
            TextButton(
              onPressed: _showAddActivityDialog,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Add Activities & Attractions',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF539DF3),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Activities List
        if (activitiesList.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: const Text(
              'No activities added yet',
              style: TextStyle(fontSize: 14, color: Color(0xFF9E9E9E)),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activitiesList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              return _buildActivityItem(activitiesList[index], index);
            },
          ),

        const SizedBox(height: 24),

        // Categories
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF212121),
              ),
            ),
            TextButton(
              onPressed: _showAddCategoryDialog,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Add Categories',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF539DF3),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Categories List (Badges)
        if (categoriesList.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: const Text(
              'No categories added yet',
              style: TextStyle(fontSize: 14, color: Color(0xFF9E9E9E)),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: categoriesList.asMap().entries.map((entry) {
              return _buildCategoryBadge(entry.value, entry.key);
            }).toList(),
          ),

        const SizedBox(height: 20),
      ],
    );
  }

  /// 360° Experience Section (Section 6)
  Widget _build360ExperienceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        const Text(
          '360° Experience',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 12),

        // Description
        const Text(
          'Give visitors an immersive preview of your destination.',
          style: TextStyle(fontSize: 14, color: Color(0xFF757575), height: 1.5),
        ),
        const SizedBox(height: 32),

        // Two Buttons: Skip and Request 360°
        Row(
          children: [
            // Skip Button
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    experience360Option = 'skip';
                  });
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(
                    color: experience360Option == 'skip'
                        ? const Color(0xFF539DF3)
                        : const Color(0xFFE0E0E0),
                    width: experience360Option == 'skip' ? 2 : 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: experience360Option == 'skip'
                      ? const Color(0xFF539DF3).withOpacity(0.05)
                      : Colors.white,
                ),
                child: Text(
                  'Skip',
                  style: TextStyle(
                    fontSize: 15,
                    color: experience360Option == 'skip'
                        ? const Color(0xFF539DF3)
                        : const Color(0xFF757575),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Request 360° Button
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    experience360Option = 'request';
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: experience360Option == 'request'
                      ? const Color(0xFF539DF3)
                      : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: experience360Option == 'request'
                          ? const Color(0xFF539DF3)
                          : const Color(0xFFE0E0E0),
                      width: experience360Option == 'request' ? 0 : 1,
                    ),
                  ),
                  elevation: experience360Option == 'request' ? 0 : 0,
                ),
                child: Text(
                  'Request 360°',
                  style: TextStyle(
                    fontSize: 15,
                    color: experience360Option == 'request'
                        ? Colors.white
                        : const Color(0xFF757575),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  /// Build Activity Item
  Widget _buildActivityItem(String activity, int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              activity,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF212121),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Delete Button
          GestureDetector(
            onTap: () {
              setState(() {
                activitiesList.removeAt(index);
              });
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEF4444),
              ),
              child: const Icon(LucideIcons.x, size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// Build Category Badge
  Widget _buildCategoryBadge(String category, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF539DF3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            category,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                categoriesList.removeAt(index);
              });
            },
            child: const Icon(LucideIcons.x, size: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }

  /// Show Add Activity Dialog
  void _showAddActivityDialog() {
    final activityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add activities & attractions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 20),

                // Description Activities
                const Text(
                  'Description Activities',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: activityController,
                  decoration: InputDecoration(
                    hintText: 'Details Activities',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFBDBDBD),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Color(0xFFE0E0E0)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF757575),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (activityController.text.isNotEmpty) {
                            setState(() {
                              activitiesList.add(activityController.text);
                            });
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF539DF3),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Add activities',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Show Add Category Dialog
  void _showAddCategoryDialog() {
    final categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 20),

                // Categories
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(
                    hintText: 'e.g. Culinary',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFBDBDBD),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Color(0xFFE0E0E0)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF757575),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (categoryController.text.isNotEmpty) {
                            setState(() {
                              categoriesList.add(categoryController.text);
                            });
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF539DF3),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Add categories',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build Ticket Item
  Widget _buildTicketItem(Map<String, dynamic> ticket, int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        ticket['name'] ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF212121),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF539DF3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        ticket['type'] ?? 'Weekday',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  ticket['price'] ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Delete Button
          OutlinedButton(
            onPressed: () {
              setState(() {
                ticketsList.removeAt(index);
              });
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              side: const BorderSide(color: Color(0xFFEF4444)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              minimumSize: Size.zero,
            ),
            child: const Text(
              'Delete',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Edit Button
          ElevatedButton(
            onPressed: () {
              _showEditTicketDialog(ticket, index);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF539DF3),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              minimumSize: Size.zero,
              elevation: 0,
            ),
            child: const Text(
              'Edit',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build Tour Item
  Widget _buildTourItem(Map<String, dynamic> tour, int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        tour['title'] ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF212121),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${tour['destinations'] ?? 0} Destinations',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  tour['price'] ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Delete Button
          OutlinedButton(
            onPressed: () {
              setState(() {
                toursList.removeAt(index);
              });
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              side: const BorderSide(color: Color(0xFFEF4444)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              minimumSize: Size.zero,
            ),
            child: const Text(
              'Delete',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFEF4444),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Edit Button
          ElevatedButton(
            onPressed: () {
              _showEditTourDialog(tour, index);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF539DF3),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              minimumSize: Size.zero,
              elevation: 0,
            ),
            child: const Text(
              'Edit',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show Add Ticket Dialog
  void _showAddTicketDialog() {
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    String selectedType = 'Weekday';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add ticket price',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Ticket Type Dropdown
                    const Text(
                      'Ticket Type',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: InputDecoration(
                        hintText: 'e.g. weekday / weekend',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFBDBDBD),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      items: ['Weekday', 'Weekend'].map((type) {
                        return DropdownMenuItem(value: type, child: Text(type));
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedType = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // Description
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Short ticket details',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFBDBDBD),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Price
                    const Text(
                      'Price (Incl. tax)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'e.g. Rp 25.000',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFBDBDBD),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: Color(0xFFE0E0E0)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF757575),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (descriptionController.text.isNotEmpty &&
                                  priceController.text.isNotEmpty) {
                                setState(() {
                                  ticketsList.add({
                                    'name': descriptionController.text,
                                    'type': selectedType,
                                    'price': 'IDR ${priceController.text}',
                                  });
                                });
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF539DF3),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Add Ticket',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Show Edit Ticket Dialog
  void _showEditTicketDialog(Map<String, dynamic> ticket, int index) {
    final descriptionController = TextEditingController(text: ticket['name']);
    final priceController = TextEditingController(
      text: ticket['price']?.toString().replaceAll('IDR ', ''),
    );
    String selectedType = ticket['type'] ?? 'Weekday';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add ticket price',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Ticket Type
                    const Text(
                      'Ticket Type',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      items: ['Weekday', 'Weekend'].map((type) {
                        return DropdownMenuItem(value: type, child: Text(type));
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedType = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // Description
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Price
                    const Text(
                      'Price (Incl. tax)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: Color(0xFFE0E0E0)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF757575),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (descriptionController.text.isNotEmpty &&
                                  priceController.text.isNotEmpty) {
                                setState(() {
                                  ticketsList[index] = {
                                    'name': descriptionController.text,
                                    'type': selectedType,
                                    'price': 'IDR ${priceController.text}',
                                  };
                                });
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF539DF3),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Add Ticket',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Show Add Tour Dialog
  void _showAddTourDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final priceController = TextEditingController();
    int destinations = 8;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add tours',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Tour Title
                    const Text(
                      'Tour Title',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'e.g. Sunrise tour',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFBDBDBD),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Tour Description
                    const Text(
                      'Tour Description',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: descriptionController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'Short tour details',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFBDBDBD),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Price
                    const Text(
                      'Price (Incl. tax)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'e.g. Rp 150.000',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFBDBDBD),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: Color(0xFFE0E0E0)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF757575),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (titleController.text.isNotEmpty &&
                                  priceController.text.isNotEmpty) {
                                setState(() {
                                  toursList.add({
                                    'title': titleController.text,
                                    'description': descriptionController.text,
                                    'price': 'IDR ${priceController.text}',
                                    'destinations': destinations,
                                  });
                                });
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF539DF3),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Add tours',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Show Edit Tour Dialog
  void _showEditTourDialog(Map<String, dynamic> tour, int index) {
    final titleController = TextEditingController(text: tour['title']);
    final descriptionController = TextEditingController(
      text: tour['description'],
    );
    final priceController = TextEditingController(
      text: tour['price']?.toString().replaceAll('IDR ', ''),
    );

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add tours',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 20),

                // Tour Title
                const Text(
                  'Tour Title',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Tour Description
                const Text(
                  'Tour Description',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),

                const SizedBox(height: 16),

                // Price
                const Text(
                  'Price (Incl. tax)',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Color(0xFFE0E0E0)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF757575),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (titleController.text.isNotEmpty &&
                              priceController.text.isNotEmpty) {
                            setState(() {
                              toursList[index] = {
                                'title': titleController.text,
                                'description': descriptionController.text,
                                'price': 'IDR ${priceController.text}',
                                'destinations': tour['destinations'],
                              };
                            });
                            Navigator.pop(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF539DF3),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Add tours',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Select time picker
  Future<void> _selectTime(
    BuildContext context, {
    required bool isOpening,
  }) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isOpening
          ? (selectedOpeningTime ?? const TimeOfDay(hour: 7, minute: 0))
          : (selectedClosingTime ?? const TimeOfDay(hour: 17, minute: 0)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteTextColor: const Color(0xFF212121),
              dialHandColor: const Color(0xFF539DF3),
              dialBackgroundColor: const Color(0xFF539DF3).withOpacity(0.1),
              dayPeriodTextColor: const Color(0xFF212121),
              dayPeriodColor: const Color(0xFF539DF3).withOpacity(0.2),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isOpening) {
          selectedOpeningTime = picked;
        } else {
          selectedClosingTime = picked;
        }
      });
    }
  }

  /// Format TimeOfDay to HH:mm string
  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Image Item with thumbnail and remove button
  Widget _buildImageItem(Map<String, String> image, int index) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          // Image Thumbnail (placeholder)
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: const Color(0xFF539DF3).withOpacity(0.1),
            ),
            child: const Icon(
              LucideIcons.image,
              color: Color(0xFF539DF3),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          // Image Name
          Expanded(
            child: Text(
              image['name'] ?? 'Image ${index + 1}',
              style: const TextStyle(fontSize: 14, color: Color(0xFF212121)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          // Remove Button
          GestureDetector(
            onTap: () {
              setState(() {
                selectedImages.removeAt(index);
              });
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEF4444),
              ),
              child: const Icon(LucideIcons.x, size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// Check if location fields are filled to show map preview
  bool _isLocationFilled() {
    return fullAddressController.text.isNotEmpty &&
        selectedProvince != null &&
        selectedCity != null;
  }

  /// Build Map Preview Widget
  Widget _buildMapPreview() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            // Map placeholder image (static)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(0xFFE8F4FD),
              child: Image.network(
                // Using static map image for demo
                'https://maps.googleapis.com/maps/api/staticmap?center=${_getLocationQuery()}&zoom=14&size=600x400&markers=color:red%7C${_getLocationQuery()}&key=YOUR_API_KEY',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to custom drawn map if network image fails
                  return _buildCustomMapPlaceholder();
                },
              ),
            ),

            // Pin marker at center
            Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  LucideIcons.mapPin,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),

            // Location label at bottom
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      LucideIcons.mapPin,
                      size: 16,
                      color: Color(0xFFEF4444),
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '${selectedCity ?? ''}, ${selectedProvince ?? ''}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF212121),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Edit button at top right
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Open map to adjust pin location'),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    LucideIcons.pencil,
                    size: 16,
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

  /// Build custom map placeholder with simple design
  Widget _buildCustomMapPlaceholder() {
    return Stack(
      children: [
        // Background with light blue/gray
        Container(color: const Color(0xFFF0F0F0)),

        // Draw simple roads/streets pattern
        CustomPaint(size: Size.infinite, painter: _MapPatternPainter()),

        // Water/beach area (cyan/blue on right side - like Nusa Dua Beach)
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          width: 180,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  const Color(0xFFBAE6FD).withOpacity(0.4),
                  const Color(0xFF7DD3FC).withOpacity(0.7),
                  const Color(0xFF38BDF8),
                  const Color(0xFF0EA5E9),
                ],
              ),
            ),
          ),
        ),

        // Purple icon marker at top right (matching design)
        const Positioned(
          top: 30,
          right: 35,
          child: Icon(LucideIcons.music, size: 18, color: Color(0xFFA855F7)),
        ),

        // Location marker labels (matching design layout)
        Positioned(
          bottom: 75,
          right: 110,
          child: _buildMapLabel('Nusa Gede', icon: LucideIcons.music),
        ),
        Positioned(
          bottom: 110,
          left: 30,
          child: _buildMapLabel('Devdan Show at Bali', isSmall: true),
        ),
        Positioned(
          bottom: 90,
          left: 35,
          child: _buildMapLabel('Nusa Dua Theatre', isSmall: true),
        ),
        Positioned(
          bottom: 75,
          left: 45,
          child: _buildMapLabel('Bali Paragliding', isSmall: true),
        ),
      ],
    );
  }

  /// Small map label with optional icon
  Widget _buildMapLabel(String text, {bool isSmall = false, IconData? icon}) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 4 : 6,
        vertical: isSmall ? 2 : 3,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: isSmall ? 8 : 10, color: const Color(0xFFA855F7)),
            SizedBox(width: isSmall ? 2 : 3),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: isSmall ? 7 : 9,
              color: const Color(0xFF424242),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Get location query string for map
  String _getLocationQuery() {
    return '${selectedCity ?? ''},${selectedProvince ?? ''},Indonesia';
  }

  /// Bottom Button (Next section or Fill out the form)
  Widget _buildBottomButton() {
    // Check if current section is complete
    final bool isSection1Complete =
        currentSection == 0 &&
        destinationNameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        selectedImages.isNotEmpty;

    final bool isSection2Complete = currentSection == 1 && _isLocationFilled();

    final bool isSection3Complete =
        currentSection == 2 &&
        selectedOpeningTime != null &&
        selectedClosingTime != null;

    // Section 4 and 5 are optional, always enabled
    final bool isSection4Optional = currentSection == 3;
    final bool isSection5Optional = currentSection == 4;

    // Section 6 requires selection
    final bool isSection6Complete =
        currentSection == 5 && experience360Option != null;

    final bool isButtonEnabled =
        isSection1Complete ||
        isSection2Complete ||
        isSection3Complete ||
        isSection4Optional ||
        isSection5Optional ||
        isSection6Complete;

    // Button text changes based on section
    String buttonText = 'Next section';
    if (currentSection == 5) {
      buttonText = 'Submit all section'; // Last section
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isButtonEnabled ? _handleBottomButtonPress : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isButtonEnabled
                ? const Color(0xFF539DF3)
                : const Color(0xFFE0E0E0),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
            disabledBackgroundColor: const Color(0xFFE0E0E0),
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isButtonEnabled ? Colors.white : const Color(0xFF757575),
            ),
          ),
        ),
      ),
    );
  }

  /// Handle bottom button press
  void _handleBottomButtonPress() {
    if (currentSection == 0) {
      // Validate Basic Information
      if (destinationNameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter destination name')),
        );
        return;
      }
      if (descriptionController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter description')),
        );
        return;
      }
      if (selectedImages.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload at least one image')),
        );
        return;
      }

      // Go to next section
      setState(() {
        currentSection = 1;
      });
    } else if (currentSection == 1) {
      // Validate Location
      if (fullAddressController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter full address')),
        );
        return;
      }
      if (selectedProvince == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please select province')));
        return;
      }
      if (selectedCity == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please select city')));
        return;
      }

      // Go to next section (Operating Hours)
      setState(() {
        currentSection = 2;
      });
    } else if (currentSection == 2) {
      // Validate Operating Hours
      if (selectedOpeningTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select opening hours')),
        );
        return;
      }
      if (selectedClosingTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select closing hours')),
        );
        return;
      }

      // Go to next section (Tickets & Tours)
      setState(() {
        currentSection = 3;
      });
    } else if (currentSection == 3) {
      // Section 3 - Tickets & Tours validation (optional, can proceed without adding items)
      // Go to next section (Activities & Categories)
      setState(() {
        currentSection = 4;
      });
    } else if (currentSection == 4) {
      // Section 4 - Activities & Categories validation (optional)
      // Go to next section (360° Experience)
      setState(() {
        currentSection = 5;
      });
    } else {
      // Section 5 - 360° Experience validation (must select Skip or Request)
      if (experience360Option == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please choose Skip or Request 360°')),
        );
        return;
      }

      // Show confirmation dialog before submitting
      _showSubmitConfirmationDialog();
    }
  }

  /// Pick images from gallery (demo version)
  Future<void> _pickImages() async {
    // TODO: Integrate with actual image picker
    // For now, add dummy images
    setState(() {
      selectedImages.add({
        'name': '20250629_135330.jpg',
        'path': 'assets/image/bawah_laut.png',
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image picker will be integrated')),
    );
  }

  /// Show Submit Confirmation Dialog
  void _showSubmitConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Ready to Add This Destination?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Take a quick look to make sure everything\'s good before adding it to your list.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF757575),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Color(0xFFE0E0E0)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Not Yet',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF757575),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                          _submitForm(); // Submit the form
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF539DF3),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Add Destination',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Submit form and navigate back
  void _submitForm() {
    // TODO: Implement actual form submission logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Destination created successfully!')),
    );

    // Navigate back to destinations list
    Navigator.pop(context);
  }
}

/// Custom painter for drawing simple road/street patterns on map
class _MapPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw horizontal lines (roads)
    for (int i = 0; i < 5; i++) {
      final y = size.height / 5 * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw vertical lines (streets)
    for (int i = 0; i < 6; i++) {
      final x = size.width / 6 * i;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
