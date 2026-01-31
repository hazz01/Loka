import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';

class ManagerAnalyticsPage extends StatefulWidget {
  const ManagerAnalyticsPage({super.key});

  @override
  State<ManagerAnalyticsPage> createState() => _ManagerAnalyticsPageState();
}

class _ManagerAnalyticsPageState extends State<ManagerAnalyticsPage> {
  String selectedPeriod = '3M';
  String selectedAgeFilter = 'All';
  String selectedDestination = 'Garuda Wisnu Kencana';
  bool isDropdownExpanded = false;

  // Dummy data untuk grafik berdasarkan periode
  Map<String, List<double>> chartData = {
    // Trend jangka panjang (smooth, naik realistis)
    'ALL': [
      0.20, 0.22, 0.24, 0.27, 0.30,
      0.34, 0.38, 0.42, 0.46, 0.50,
      0.54, 0.57, 0.60, 0.63, 0.66,
      0.69, 0.72, 0.75, 0.78, 0.82,
    ],

    // Potongan dari ALL bagian akhir
    '1Y': [
      0.42, 0.45, 0.47, 0.50, 0.52,
      0.55, 0.57, 0.60, 0.62, 0.65,
      0.67, 0.69, 0.71, 0.73, 0.75,
      0.77, 0.78, 0.80, 0.81, 0.82,
    ],

    // Lebih sempit, noise kecil
    'YTD': [
      0.50, 0.52, 0.53, 0.55, 0.56,
      0.58, 0.60, 0.61, 0.63, 0.65,
      0.66, 0.68, 0.70, 0.71, 0.72,
      0.74, 0.75, 0.77, 0.78, 0.80,
    ],

    // Ada koreksi kecil (realistis)
    '3M': [
      0.62, 0.61, 0.60, 0.59, 0.58,
      0.57, 0.58, 0.60, 0.62, 0.64,
      0.66, 0.67, 0.68, 0.70, 0.71,
      0.72, 0.73, 0.74, 0.75, 0.76,
    ],

    // Lebih volatile tapi masih masuk akal
    '1M': [
      0.68, 0.67, 0.66, 0.65, 0.66,
      0.67, 0.68, 0.69, 0.70, 0.71,
      0.72, 0.71, 0.72, 0.73, 0.74,
      0.75, 0.76, 0.77, 0.78, 0.79,
    ],

    // Gerak harian mingguan
    '5D': [
      0.75, 0.74, 0.745, 0.75, 0.755,
      0.76, 0.758, 0.76, 0.762, 0.765,
      0.768, 0.77, 0.772, 0.775, 0.778,
      0.78, 0.782, 0.785, 0.788, 0.79,
    ],

    // Intraday (noise kecil banget)
    '1D': [
      0.785, 0.784, 0.783, 0.784,
      0.785, 0.786, 0.787, 0.788,
      0.787, 0.786, 0.787, 0.788,
      0.789, 0.79, 0.791, 0.792,
      0.793, 0.794, 0.795, 0.796,
    ],
  };


  // Data lokasi (untuk demo, ditambah lebih banyak destinasi)
  final List<Map<String, String>> destinations = [
    {
      'name': 'Garuda Wisnu Kencana',
      'subtitle': 'Vacationation Kuta Selatan, Bali',
    },
    {
      'name': 'Jatim Park 1',
      'subtitle': 'Kota Batu, Malang',
    },
    {
      'name': 'Taman Safari Indonesia',
      'subtitle': 'Cisarua, Bogor',
    },
  ];

  // Data audience berdasarkan filter gender
  Map<String, List<Map<String, dynamic>>> ageRangeData = {
    'All': [
      {'range': '13 - 17', 'percentage': 0.49},
      {'range': '18 - 24', 'percentage': 0.307},
      {'range': '25 - 34', 'percentage': 0.172},
      {'range': '35 - 44', 'percentage': 0.038},
    ],
    'Men': [
      {'range': '13 - 17', 'percentage': 0.42},
      {'range': '18 - 24', 'percentage': 0.35},
      {'range': '25 - 34', 'percentage': 0.18},
      {'range': '35 - 44', 'percentage': 0.05},
    ],
    'Women': [
      {'range': '13 - 17', 'percentage': 0.56},
      {'range': '18 - 24', 'percentage': 0.28},
      {'range': '25 - 34', 'percentage': 0.12},
      {'range': '35 - 44', 'percentage': 0.04},
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section with Profile and Destination Selector
              _buildHeader(),

              // Destination Hero Card
              _buildDestinationHeroCard(),

              const SizedBox(height: 16),

              // Stats Cards (Views & Total Views)
              _buildStatsCards(),

              const SizedBox(height: 20),

              // Trend Chart Section
              _buildTrendChart(),

              const SizedBox(height: 20),

              // Most Searched Queries
              _buildMostSearchedQueries(),

              const SizedBox(height: 20),

              // Audience Analytics
              _buildAudienceAnalytics(),

              const SizedBox(height: 80), // Bottom padding for navigation
            ],
          ),
        ),
      ),
    );
  }

  /// Header with user profile, destination selector, and Analysis button
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
                'assets/image/avatar.png',
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
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Analysis Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Analysis',
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

  /// Destination Hero Card with image and view count
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                                destinations.firstWhere(
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
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                        ),
                        child: Column(
                          children: destinations.map((destination) {
                            final isSelected = selectedDestination == destination['name'];
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedDestination = destination['name']!;
                                  isDropdownExpanded = false;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            destination['name']!,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                              color: isSelected ? const Color(0xFF539DF3) : const Color(0xFF212121),
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
                    padding: const EdgeInsets.only(left: 0, right: 0, top: 20, bottom: 10),
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Stats Cards showing Views and Total Views
  Widget _buildStatsCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Views Card
          Expanded(
            child: _buildStatCard(
              value: '2K',
              label: 'Views',
              sublabel: '-50%',
              isNegative: true,
            ),
          ),
          const SizedBox(width: 12),

          // Total Views Card
          Expanded(
            child: _buildStatCard(
              value: '4.5K',
              label: 'Total Views',
              sublabel: 'Past 30 days',
              isNegative: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required String sublabel,
    required bool isNegative,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Text(
            value,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF539DF3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              sublabel,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Trend Chart with time period selector
  Widget _buildTrendChart() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trend Chart',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 16),

          // Time Period Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['1D', '5D', '1M', '3M', 'YTD', '1Y', 'ALL']
                .map((period) => _buildPeriodButton(period))
                .toList(),
          ),

          const SizedBox(height: 20),

          // Chart Placeholder
          SizedBox(
            height: 180,
            child: CustomPaint(
              painter: _TrendChartPainter(chartData[selectedPeriod]!),
              child: Container(),
            ),
          ),

          const SizedBox(height: 12),

          // Chart Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'November',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                'December',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '2026',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Powered by Google Trends
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'powered by ',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
              Text(
                'Google Trends',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String period) {
    final isSelected = selectedPeriod == period;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPeriod = period;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF539DF3) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          period,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey[600],
          ),
        ),
      ),
    );
  }

  /// Most Searched Queries section
  Widget _buildMostSearchedQueries() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Most Searched Queries',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Indonesia · Past 3 Months',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 20),

          // Query Items Grid
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildQueryItem('gwk', '+4%', true),
                    const SizedBox(height: 16),
                    _buildQueryItem('gwk bali', '+10%', true),
                    const SizedBox(height: 16),
                    _buildQueryItem('garuda wisnu', '+82%', true),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    _buildQueryItem('bali', '+4%', true),
                    const SizedBox(height: 16),
                    _buildQueryItem('garuda', '+9%', false),
                    const SizedBox(height: 16),
                    _buildQueryItem('wisnu kencana', '+8%', false),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQueryItem(String query, String percentage, bool isPositive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          query,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 0.6,
                  minHeight: 8,
                  backgroundColor: const Color(0xFF539DF3).withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF539DF3),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Text(
              'Search Interest',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
            const Spacer(),
            Text(
              percentage,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              isPositive ? LucideIcons.trendingUp : LucideIcons.trendingDown,
              size: 12,
              color: isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
            ),
          ],
        ),
      ],
    );
  }

  /// Audience Analytics section
  Widget _buildAudienceAnalytics() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Audience Analytics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Demographic breakdown of users',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),

          // Reached Audience
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Reached audience',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212121),
                ),
              ),
              Text(
                'Location',
                style: TextStyle(
                  fontSize: 13,
                  color: const Color(0xFF539DF3),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildLocationBar('Malang', 0.5),
          const SizedBox(height: 12),
          _buildLocationBar('Surabaya', 0.1),
          const SizedBox(height: 12),
          _buildLocationBar('Bali', 0.3),
          const SizedBox(height: 12),
          _buildLocationBar('Jogja', 0.1),

          const SizedBox(height: 32),

          // Age Range
          Row(
            children: [
              const Text(
                'Age range',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212121),
                ),
              ),
              const Spacer(),
              _buildAgeFilterButton('All'),
              const SizedBox(width: 8),
              _buildAgeFilterButton('Men'),
              const SizedBox(width: 8),
              _buildAgeFilterButton('Women'),
            ],
          ),
          const SizedBox(height: 16),

          // Dynamically display age range data based on selected filter
          ...ageRangeData[selectedAgeFilter]!.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            return Column(
              children: [
                if (index > 0) const SizedBox(height: 12),
                _buildAgeRangeBar(data['range'], data['percentage']),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildLocationBar(String location, double percentage) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            location,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF212121),
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF539DF3).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: percentage,
                  child: Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF539DF3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 40,
          child: Text(
            '${(percentage * 100).toInt()}%',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgeRangeBar(String ageRange, double percentage) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            ageRange,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF212121),
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF539DF3).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: percentage,
                  child: Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF539DF3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 45,
          child: Text(
            '${(percentage * 100).toStringAsFixed(1)}%',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgeFilterButton(String label) {
    final isSelected = selectedAgeFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAgeFilter = label;
        });
      },
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: isSelected ? const Color(0xFF539DF3) : Colors.grey[600],
        ),
      ),
    );
  }
}

/// Custom painter for the trend chart
class _TrendChartPainter extends CustomPainter {
  final List<double> dataPoints;

  _TrendChartPainter(this.dataPoints);

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final spacing = width / (dataPoints.length - 1);

    // Draw area fill
    final fillPath = Path();
    fillPath.moveTo(0, height);

    for (int i = 0; i < dataPoints.length; i++) {
      final x = i * spacing;
      final y = height - (dataPoints[i] * height);
      if (i == 0) {
        fillPath.lineTo(x, y);
      } else {
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(width, height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF539DF3).withOpacity(0.3),
          const Color(0xFF539DF3).withOpacity(0.05),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height));

    canvas.drawPath(fillPath, fillPaint);

    // Draw line
    final linePath = Path();
    for (int i = 0; i < dataPoints.length; i++) {
      final x = i * spacing;
      final y = height - (dataPoints[i] * height);
      if (i == 0) {
        linePath.moveTo(x, y);
      } else {
        linePath.lineTo(x, y);
      }
    }

    final linePaint = Paint()
      ..color = const Color(0xFF539DF3)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant _TrendChartPainter oldDelegate) {
    return oldDelegate.dataPoints != dataPoints;
  }
}
