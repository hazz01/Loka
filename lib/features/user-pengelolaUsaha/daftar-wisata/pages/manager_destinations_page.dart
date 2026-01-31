import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'add_destination_page.dart';

class ManagerDestinationsPage extends StatelessWidget {
  const ManagerDestinationsPage({super.key});

  // Dummy data for destinations - matching the design image
  static final List<Map<String, dynamic>> destinations = const [
    {
      'id': 'dest002',
      'name': 'Nusa Pedina',
      'location': 'Bali, Indonesia',
      'views': '3K views',
      'image': 'assets/image/bawah_laut.png',
      'status': 'Active',
    },
    {
      'id': 'dest003',
      'name': 'Lawang Sewu',
      'location': 'Semarang, Indonesia',
      'views': '1K views',
      'image': 'assets/image/kayutangan.png',
      'status': 'Active',
    },
    {
      'id': 'dest001',
      'name': 'Nusa Dua Beach',
      'location': 'Bali, Indonesia',
      'views': '0.5K views',
      'image': 'assets/image/bawah_laut.png',
      'status': 'Active',
    },
    {
      'id': 'dest004',
      'name': 'Taman Budaya Garu...',
      'location': 'Bali, Indonesia',
      'views': '0K views',
      'image': 'assets/image/bawah_laut.png',
      'status': 'Draft',
    },
    {
      'id': 'dest005',
      'name': 'Kampoeng Heritag....',
      'location': 'Malang, Indonesia',
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
        child: Column(
          children: [
            // Header Section with profile and Destinations button
            _buildHeader(),

            // Main Content - Scrollable
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Section Title
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
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final destination = destinations[index];
                        return _buildDestinationCard(
                          context: context,
                          id: destination['id'] as String,
                          name: destination['name'] as String,
                          location: destination['location'] as String,
                          views: destination['views'] as String,
                          imagePath: destination['image'] as String,
                          status: destination['status'] as String,
                        );
                      },
                    ),

                    const SizedBox(height: 80), // Bottom padding for FAB
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Floating Action Button for adding new destination
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add destination page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDestinationPage()),
          );
        },
        backgroundColor: const Color(0xFF539DF3),
        child: const Icon(LucideIcons.plus, color: Colors.white, size: 28),
      ),
    );
  }

  /// Header with user profile and Destinations button
  /// Consistent with Dashboard, Analytics, and Tickets pages
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
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // Destinations Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE0E0E0)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Destinations',
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

  /// Individual Destination Card
  /// Matches the design with image, info, and status badge
  Widget _buildDestinationCard({
    required BuildContext context,
    required String id,
    required String name,
    required String location,
    required String views,
    required String imagePath,
    required String status,
  }) {
    final bool isActive = status == 'Active';

    return GestureDetector(
      onTap: () {
        // Navigate to destination detail page
        context.push('/manager/destination/$id');
      },
      child: Container(
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
              // Destination Image Thumbnail
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

              // Destination Info (name, location, views)
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

              const SizedBox(width: 8),

              // Status Badge (Active: blue, Draft: red)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
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
      ),
    );
  }
}
