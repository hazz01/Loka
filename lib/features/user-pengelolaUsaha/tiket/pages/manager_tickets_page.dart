import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'ticket_detail_page.dart';
import 'tour_detail_page.dart';

class ManagerTicketsPage extends StatefulWidget {
  const ManagerTicketsPage({super.key});

  @override
  State<ManagerTicketsPage> createState() => _ManagerTicketsPageState();
}

class _ManagerTicketsPageState extends State<ManagerTicketsPage> {
  String selectedDestination = 'Garuda Wisnu Kencana';
  bool isDropdownExpanded = false;

  // Dummy destinations data
  final List<Map<String, String>> destinations = [
    {
      'name': 'Garuda Wisnu Kencana',
      'subtitle': 'Kecamatan Kuta Selatan, Bali',
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

  // Ticket categories dummy data
  final List<Map<String, dynamic>> ticketCategories = [
    {
      'name': 'Ticket destination',
      'price': 'IDR 25.000',
      'badge': 'Weekday',
    },
    {
      'name': 'Ticket destination + parking',
      'price': 'IDR 50.000',
      'badge': 'Weekend',
    },
  ];

  // Tour categories dummy data
  final List<Map<String, dynamic>> tourCategories = [
    {
      'name': 'Family Fun Tour',
      'price': 'IDR 150.000',
      'badge': '8 Destinations',
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
              // Header Section with Profile and Tickets button
              _buildHeader(),

              // Destination Selector Card
              _buildDestinationCard(),

              const SizedBox(height: 16),

              // Stats Cards (Most buys & Total buys)
              _buildStatsCards(),

              const SizedBox(height: 20),

              // Most buys tour section
              _buildMostBuysTour(),

              const SizedBox(height: 20),

              // Your tickets category
              _buildTicketsCategory(),

              const SizedBox(height: 20),

              // Your tour category
              _buildTourCategory(),

              const SizedBox(height: 80), // Bottom padding for navigation
            ],
          ),
        ),
      ),
    );
  }

  /// Header with user profile and Tickets button
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

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ryo Hariyono Angwyn',
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

          // Tickets Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Tickets',
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

  /// Destination Selector Card with dropdown
  Widget _buildDestinationCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
      child: Padding(
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
    );
  }

  /// Stats Cards showing Most buys and Total buys
  Widget _buildStatsCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Most buys Card
          Expanded(
            child: _buildStatCard(
              value: '143',
              label: 'Most buys',
              badge: 'Weekend',
            ),
          ),
          const SizedBox(width: 12),

          // Total buys Card
          Expanded(
            child: _buildStatCard(
              value: '200',
              label: 'Total buys',
              badge: 'Last 30 days',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required String badge,
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
              badge,
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

  /// Most buys tour section
  Widget _buildMostBuysTour() {
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
      child: Row(
        children: [
          // Number
          const Text(
            '19',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: Color(0xFF212121),
              height: 1,
            ),
          ),
          const SizedBox(width: 20),

          // Text and Badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Most buys tour',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF539DF3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Family fun tour',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Your tickets category section
  Widget _buildTicketsCategory() {
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
            'Your tickets category',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 16),

          // Ticket items
          ...ticketCategories.asMap().entries.map((entry) {
            final index = entry.key;
            final ticket = entry.value;
            return Column(
              children: [
                if (index > 0) const SizedBox(height: 12),
                _buildTicketItem(
                  name: ticket['name'],
                  price: ticket['price'],
                  badge: ticket['badge'],
                ),
              ],
            );
          }).toList(),

          const SizedBox(height: 16),

          // Edit Ticket Button
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFF5F5F5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Edit Ticket',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF212121),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketItem({
    required String name,
    required String price,
    required String badge,
  }) {
    return InkWell(
      onTap: () {
        // Navigate to ticket detail page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TicketDetailPage(
              ticketName: name,
              ticketPrice: price,
              ticketBadge: badge,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
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
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF539DF3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Your tour category section
  Widget _buildTourCategory() {
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
            'Your tour category',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 16),

          // Tour items
          ...tourCategories.asMap().entries.map((entry) {
            final index = entry.key;
            final tour = entry.value;
            return Column(
              children: [
                if (index > 0) const SizedBox(height: 12),
                _buildTourItem(
                  name: tour['name'],
                  price: tour['price'],
                  badge: tour['badge'],
                ),
              ],
            );
          }).toList(),

          const SizedBox(height: 16),

          // Edit Tour Button
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFF5F5F5),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Edit Tour',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF212121),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTourItem({
    required String name,
    required String price,
    required String badge,
  }) {
    return InkWell(
      onTap: () {
        // Navigate to tour detail page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TourDetailPage(
              tourName: name,
              tourPrice: price,
              tourBadge: badge,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
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
                  ),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF539DF3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
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
