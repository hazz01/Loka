import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';

class ManagerDashboardPage extends StatefulWidget {
  const ManagerDashboardPage({super.key});

  @override
  State<ManagerDashboardPage> createState() => _ManagerDashboardPageState();
}

class _ManagerDashboardPageState extends State<ManagerDashboardPage> {
  String selectedDestination = 'Nusa Pedina';
  bool isDropdownExpanded = false;

  // Data lokasi destinasi
  final List<Map<String, String>> destinationsDropdown = [
    {'name': 'Nusa Pedina', 'subtitle': 'Bali, Indonesia'},
    {'name': 'Lawang Sewu', 'subtitle': 'Semarang, Indonesia'},
    {'name': 'Nusa Dua Beach', 'subtitle': 'Bali, Indonesia'},
  ];

  // Dummy data for destinations list
  final List<Map<String, dynamic>> destinations = const [
    {
      'name': 'Nusa Pedina',
      'location': 'Bali, Indonesia',
      'views': '3K views',
      'image': 'assets/image/bawah_laut.png',
      'status': 'Active',
    },
    {
      'name': 'Lawang Sewu',
      'location': 'Semarang, Indonesia',
      'views': '1K views',
      'image': 'assets/image/kayutangan.png',
      'status': 'Active',
    },
    {
      'name': 'Nusa Dua Beach',
      'location': 'Bali, Indonesia',
      'views': '0.5K views',
      'image': 'assets/image/bawah_laut.png',
      'status': 'Active',
    },
    {
      'name': 'Taman Budaya Garu...',
      'location': 'Bali, Indonesia',
      'views': '0K views',
      'image': 'assets/image/bawah_laut.png',
      'status': 'Draft',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeader(),

              const SizedBox(height: 16),

              // Most Viewed Destination Hero Card
              _buildDestinationHeroCard(),

              const SizedBox(height: 16),

              // Stats Cards (Total Destinations & Total Views)
              _buildStatsSection(),

              const SizedBox(height: 24),

              // Your Destinations Section
              _buildDestinationsSection(),

              const SizedBox(height: 80), // Bottom padding for navigation
            ],
          ),
        ),
      ),
    );
  }

  /// Header with user profile and Dashboard button
  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Profile Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE0E0E0), width: 2),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/image/profile.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: const Color(0xFF539DF3).withOpacity(0.1),
                    child: const Icon(
                      LucideIcons.user,
                      color: Color(0xFF539DF3),
                      size: 24,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),

          // User Info & Destination Selector
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ryo Hariyono Anggwyn',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Manage your destinations',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Dashboard Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF212121),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Most Viewed Destination Hero Card with overlay (sama dengan analytics page)
  Widget _buildDestinationHeroCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Destination Dropdown with Overlay
          Padding(
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                // Main Dropdown Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isDropdownExpanded = !isDropdownExpanded;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedDestination,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF212121),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                destinationsDropdown.firstWhere(
                                  (dest) => dest['name'] == selectedDestination,
                                )['subtitle']!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        AnimatedRotation(
                          turns: isDropdownExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: const Icon(
                            LucideIcons.chevronDown,
                            size: 20,
                            color: Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Floating Dropdown Menu
                if (isDropdownExpanded)
                  Positioned(
                    top: 70,
                    left: 0,
                    right: 0,
                    child: Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                        ),
                        child: Column(
                          children: destinationsDropdown.map((destination) {
                            final isSelected =
                                selectedDestination == destination['name'];
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedDestination = destination['name']!;
                                  isDropdownExpanded = false;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            destination['name']!,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w500,
                                              color: isSelected
                                                  ? const Color(0xFF539DF3)
                                                  : const Color(0xFF212121),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            destination['subtitle']!,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isSelected)
                                      const Icon(
                                        LucideIcons.check,
                                        size: 18,
                                        color: Color(0xFF539DF3),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Hero Image with overlay
          Stack(
            children: [
              // Background Image
              Container(
                width: double.infinity,
                height: 212,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://nagantour.com/wp-content/uploads/2020/01/Jatim-Park-1.webp',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.65),
                        Colors.black.withOpacity(0.85),
                      ],
                    ),
                  ),
                ),
              ),

              // Area Chart Overlay
              Positioned(
                left: 16,
                right: 16,
                top: 40,
                bottom: 80,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 0,
                      right: 0,
                      top: 20,
                      bottom: 10,
                    ),
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: const FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: 19,
                        minY: 0,
                        maxY: 1,
                        lineBarsData: [
                          LineChartBarData(
                            spots: [
                              const FlSpot(0, 0.15),
                              const FlSpot(1, 0.18),
                              const FlSpot(2, 0.22),
                              const FlSpot(3, 0.28),
                              const FlSpot(4, 0.35),
                              const FlSpot(5, 0.45),
                              const FlSpot(6, 0.55),
                              const FlSpot(7, 0.48),
                              const FlSpot(8, 0.52),
                              const FlSpot(9, 0.6),
                              const FlSpot(10, 0.7),
                              const FlSpot(11, 0.65),
                              const FlSpot(12, 0.58),
                              const FlSpot(13, 0.5),
                              const FlSpot(14, 0.55),
                              const FlSpot(15, 0.62),
                              const FlSpot(16, 0.68),
                              const FlSpot(17, 0.75),
                              const FlSpot(18, 0.72),
                              const FlSpot(19, 0.68),
                            ],
                            isCurved: true,
                            curveSmoothness: 0.4,
                            color: const Color(0xFF64B5F6),
                            barWidth: 4,
                            isStrokeCapRound: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color(0xFF64B5F6).withOpacity(0.6),
                                  const Color(0xFF64B5F6).withOpacity(0.3),
                                  const Color(0xFF64B5F6).withOpacity(0.05),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // "Total viewed" Tag - Top Left
              Positioned(
                left: 32,
                top: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: const Text(
                    'Total viewed',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),

              // Destination Name - Bottom Left
              // Positioned(
              //   left: 32,
              //   bottom: 52,
              //   right: 32,
              //   child: const Text(
              //     'Garuda Wisnu Kencana, Bali',
              //     style: TextStyle(
              //       fontSize: 28,
              //       fontWeight: FontWeight.w700,
              //       color: Colors.white,
              //       letterSpacing: -0.5,
              //       height: 1.2,
              //     ),
              //   ),
              // ),

              // "3K views" Badge - Bottom Left
              Positioned(
                left: 32,
                bottom: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    '3K views',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF212121),
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),

              // Date Labels on X-axis
              Positioned(
                left: 32,
                right: 32,
                bottom: 84,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '24 Apr',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '18 Mr',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '24 Mrt',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Y-axis Labels (0, 1K, 2K, 3K, 4K)
              Positioned(
                right: 24,
                top: 40,
                bottom: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '4K',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.85),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '3K',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.85),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '2K',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.85),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '1K',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.85),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '0',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.85),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Stack(
          //   children: [
          //     // Background Image
          //     Container(
          //       width: double.infinity,
          //       height: 212,
          //       margin: const EdgeInsets.symmetric(horizontal: 16),
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(16),
          //         image: const DecorationImage(
          //           image: AssetImage('assets/image/bawah_laut.png'),
          //           fit: BoxFit.cover,
          //         ),
          //       ),
          //       child: Container(
          //         decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(16),
          //           gradient: LinearGradient(
          //             begin: Alignment.topCenter,
          //             end: Alignment.bottomCenter,
          //             colors: [
          //               Colors.black.withOpacity(0.65),
          //               Colors.black.withOpacity(0.85),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),

          //     // "Most viewed" Tag - Top Left
          //     Positioned(
          //       left: 32,
          //       top: 16,
          //       child: Container(
          //         padding: const EdgeInsets.symmetric(
          //           horizontal: 12,
          //           vertical: 6,
          //         ),
          //         decoration: BoxDecoration(
          //           color: Colors.white.withOpacity(0.25),
          //           borderRadius: BorderRadius.circular(8),
          //           border: Border.all(
          //             color: Colors.white.withOpacity(0.5),
          //             width: 1.5,
          //           ),
          //         ),
          //         child: const Text(
          //           'Most viewed',
          //           style: TextStyle(
          //             fontSize: 12,
          //             color: Colors.white,
          //             fontWeight: FontWeight.w600,
          //             letterSpacing: 0.3,
          //           ),
          //         ),
          //       ),
          //     ),

          //     // "3K views" Badge - Bottom Left
          //     Positioned(
          //       left: 32,
          //       bottom: 16,
          //       child: Container(
          //         padding: const EdgeInsets.symmetric(
          //           horizontal: 14,
          //           vertical: 8,
          //         ),
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(8),
          //           boxShadow: [
          //             BoxShadow(
          //               color: Colors.black.withOpacity(0.1),
          //               blurRadius: 8,
          //               offset: const Offset(0, 2),
          //             ),
          //           ],
          //         ),
          //         child: const Text(
          //           '3K views',
          //           style: TextStyle(
          //             fontSize: 14,
          //             fontWeight: FontWeight.w700,
          //             color: Color(0xFF212121),
          //             letterSpacing: 0.2,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Stats Section with Total Destinations and Total Views
  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Total Destinations Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                    '3',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Total Destinations',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF757575),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF539DF3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Active',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Total Views Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                    '4.5K',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Total Views',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF757575),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF539DF3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Last 30 days',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Your Destinations Section with list of destination cards
  Widget _buildDestinationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Your Destinations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF212121),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Destination Cards List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: destinations.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final destination = destinations[index];
            return _buildDestinationCard(
              name: destination['name'] as String,
              location: destination['location'] as String,
              views: destination['views'] as String,
              imagePath: destination['image'] as String,
              status: destination['status'] as String,
            );
          },
        ),

        const SizedBox(height: 16),

        // See More Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                // Navigate to full destinations list
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Color(0xFFE0E0E0)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'See more destinations',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF757575),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Individual Destination Card
  Widget _buildDestinationCard({
    required String name,
    required String location,
    required String views,
    required String imagePath,
    required String status,
  }) {
    final bool isActive = status == 'Active';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Destination Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFF539DF3).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      LucideIcons.image,
                      color: Color(0xFF539DF3),
                      size: 24,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 12),

            // Destination Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF757575),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    views,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF757575),
                    ),
                  ),
                ],
              ),
            ),

            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF539DF3)
                    : const Color(0xFFEF4444),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
