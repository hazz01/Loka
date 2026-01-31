import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'add_destination_page.dart';
import '../services/local_destination_service.dart';

class ManagerDestinationsPage extends StatefulWidget {
  const ManagerDestinationsPage({super.key});

  @override
  State<ManagerDestinationsPage> createState() => _ManagerDestinationsPageState();
}

class _ManagerDestinationsPageState extends State<ManagerDestinationsPage> {
  List<Map<String, dynamic>> destinations = [];
  bool isLoading = true;

  // Dummy data untuk fallback atau initial data
  static final List<Map<String, dynamic>> _dummyDestinations = const [
    {
      'id': 'dest002',
      'name': 'Nusa Pedina',
      'location': 'Bali, Indonesia',
      'views': 3000,
      'image': 'assets/image/bawah_laut.png',
      'status': 'Active',
    },
    {
      'id': 'dest003',
      'name': 'Lawang Sewu',
      'location': 'Semarang, Indonesia',
      'views': 1000,
      'image': 'assets/image/kayutangan.png',
      'status': 'Active',
    },
    {
      'id': 'dest001',
      'name': 'Nusa Dua Beach',
      'location': 'Bali, Indonesia',
      'views': 500,
      'image': 'assets/image/bawah_laut.png',
      'status': 'Active',
    },
    {
      'id': 'dest004',
      'name': 'Taman Budaya Garu...',
      'location': 'Bali, Indonesia',
      'views': 0,
      'image': 'assets/image/bawah_laut.png',
      'status': 'Draft',
    },
    {
      'id': 'dest005',
      'name': 'Kampoeng Heritag....',
      'location': 'Malang, Indonesia',
      'views': 0,
      'image': 'assets/image/bawah_laut.png',
      'status': 'Draft',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadDestinations();
  }

  /// Memuat destinations dari local database
  Future<void> _loadDestinations() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Ambil data dari local database
      final localDestinations = await LocalDestinationService.getAllDestinations();
      
      // Jika kosong, gunakan dummy data sebagai default
      if (localDestinations.isEmpty) {
        destinations = List.from(_dummyDestinations);
      } else {
        destinations = localDestinations;
      }
    } catch (e) {
      print('Error loading destinations: $e');
      // Fallback ke dummy data jika error
      destinations = List.from(_dummyDestinations);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Format views count
  String _formatViews(int views) {
    if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K views';
    }
    return '$views views';
  }

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
                    isLoading
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : destinations.isEmpty
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(32.0),
                                  child: Text(
                                    'No destinations yet. Add your first destination!',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF757575),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: destinations.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final destination = destinations[index];
                                  final views = destination['views'] is int
                                      ? destination['views'] as int
                                      : 0;
                                  
                                  return _buildDestinationCard(
                                    context: context,
                                    id: destination['id'] as String,
                                    name: destination['name'] as String,
                                    location: destination['location'] as String,
                                    views: _formatViews(views),
                                    imagePath: destination['image'] as String? ?? 'assets/image/bawah_laut.png',
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
        onPressed: () async {
          // Navigate to add destination page dan tunggu result
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDestinationPage()),
          );
          
          // Reload destinations jika ada data baru ditambahkan
          if (result == true) {
            _loadDestinations();
          }
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
  /// Added: Dismissible untuk swipe to delete
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

    return Dismissible(
      key: Key(id),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.trash2, color: Colors.white, size: 24),
            SizedBox(height: 4),
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        // Show confirmation dialog
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Delete Destination?'),
            content: Text('Are you sure you want to delete "$name"? This action cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) async {
        // Hapus dari database
        final success = await LocalDestinationService.deleteDestination(id);
        
        if (success) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$name has been deleted'),
                backgroundColor: Colors.red,
                action: SnackBarAction(
                  label: 'OK',
                  textColor: Colors.white,
                  onPressed: () {},
                ),
              ),
            );
          }
          // Reload list
          _loadDestinations();
        }
      },
      child: GestureDetector(
        onTap: () {
          // Navigate to destination detail page
          context.push('/manager/destination/$id');
        },
        onLongPress: () {
          // Show options menu
          _showDestinationOptions(context, id, name, status);
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
      ),
    );
  }

  /// Show options menu untuk destination (long press)
  void _showDestinationOptions(BuildContext context, String id, String name, String status) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Title
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF212121),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 20),
            
            // Option: Change Status
            ListTile(
              leading: Icon(
                status == 'Active' ? LucideIcons.fileX : LucideIcons.check,
                color: const Color(0xFF539DF3),
              ),
              title: Text(
                status == 'Active' ? 'Mark as Draft' : 'Mark as Active',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                final newStatus = status == 'Active' ? 'Draft' : 'Active';
                final success = await LocalDestinationService.updateDestinationStatus(id, newStatus);
                
                if (success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Status changed to $newStatus'),
                      backgroundColor: const Color(0xFF539DF3),
                    ),
                  );
                  _loadDestinations();
                }
              },
            ),
            
            // Option: Delete
            ListTile(
              leading: const Icon(
                LucideIcons.trash2,
                color: Colors.red,
              ),
              title: const Text(
                'Delete Destination',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
              onTap: () async {
                Navigator.pop(context);
                
                // Show confirmation
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: const Text('Delete Destination?'),
                    content: Text('Are you sure you want to delete "$name"? This action cannot be undone.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
                
                if (confirm == true) {
                  final success = await LocalDestinationService.deleteDestination(id);
                  
                  if (success && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$name has been deleted'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    _loadDestinations();
                  }
                }
              },
            ),
            
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
