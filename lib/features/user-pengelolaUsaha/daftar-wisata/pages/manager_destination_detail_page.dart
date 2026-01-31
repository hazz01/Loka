import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class ManagerDestinationDetailPage extends StatefulWidget {
  final String destinationId;

  const ManagerDestinationDetailPage({
    super.key,
    required this.destinationId,
  });

  @override
  State<ManagerDestinationDetailPage> createState() =>
      _ManagerDestinationDetailPageState();
}

class _ManagerDestinationDetailPageState
    extends State<ManagerDestinationDetailPage> {
  // ignore: unused_field
  MapboxMap? _mapboxMap;
  bool _isMapboxInitialized = false;

  // Mapbox configuration
  static const String mapboxAccessToken =
      'pk.eyJ1IjoiaDQyNCIsImEiOiJja21ycXB0dnQwYWhnMnZudGR3eWFlOGJnIn0.NYHwuoDP3269P5dsZ7-HLQ';

  @override
  void initState() {
    super.initState();
    _initializeMapbox();
  }

  void _initializeMapbox() {
    try {
      if (!_isMapboxInitialized) {
        MapboxOptions.setAccessToken(mapboxAccessToken);
        _isMapboxInitialized = true;
      }
    } catch (e) {
      // Silently handle mapbox initialization error
      debugPrint('Mapbox initialization warning: $e');
    }
  }

  // Dummy data based on destination ID
  Map<String, dynamic> _getDestinationData() {
    // Simulate fetching destination data
    final destinations = {
      'dest001': {
        'name': 'Nusa Dua Beach',
        'location': 'Kecamatan Kuta Selatan, Bali',
        'province': 'Bali',
        'openingHours': '07.00 - 17.00',
        'category': 'Beach',
        'views': '0.5K views',
        'rating': 4.0,
        'reviewCount': 52,
        'imagePath': 'assets/image/bawah_laut.png',
        'description':
            'kawasan resor mewah di Bali Selatan yang terkenal dengan pasir putihnya, air laut tenang, dan fasilitas lengkap. Ideal untuk keluarga berenang, liburan santai karena ombaknya aman untuk berenang.',
        'latitude': -8.8065188,
        'longitude': 115.2306332,
        'ticketPrices': [
          {'type': 'Ticket destination', 'price': 'IDR 25.000', 'day': 'Weekday'},
          {'type': 'Ticket destination', 'price': 'IDR 25.000', 'day': 'Weekday'},
        ],
        'tours': [
          {
            'name': 'Family Fun Tour',
            'description': 'Tour Description',
            'price': 'IDR 150.000',
            'destinations': '5 Destinations',
          },
        ],
        'activities': [
          'Enjoy peaceful walks along the white sandy beach with a calm and relaxing atmosphere.',
          'Swim and sunbathe in clear waters with gentle waves, perfect for all ages.',
          'Experience exciting water sports such as jet ski, banana boat, parasailing, and snorkeling.',
        ],
        'virtualTourAvailable': true,
      },
      'dest002': {
        'name': 'Nusa Pedina',
        'location': 'Bali, Indonesia',
        'province': 'Bali',
        'openingHours': '08.00 - 18.00',
        'category': 'Beach',
        'views': '3K views',
        'rating': 4.5,
        'reviewCount': 120,
        'imagePath': 'assets/image/bawah_laut.png',
        'description':
            'Beautiful underwater destination with crystal clear waters and amazing marine life.',
        'latitude': -8.7,
        'longitude': 115.2,
        'ticketPrices': [
          {'type': 'Ticket destination', 'price': 'IDR 35.000', 'day': 'Weekday'},
          {'type': 'Ticket destination', 'price': 'IDR 50.000', 'day': 'Weekend'},
        ],
        'tours': [
          {
            'name': 'Diving Adventure',
            'description': 'Explore underwater world',
            'price': 'IDR 300.000',
            'destinations': '3 Destinations',
          },
        ],
        'activities': [
          'Scuba diving in pristine waters',
          'Snorkeling with tropical fish',
          'Underwater photography sessions',
        ],
        'virtualTourAvailable': true,
      },
      'dest003': {
        'name': 'Lawang Sewu',
        'location': 'Semarang, Indonesia',
        'province': 'Central Java',
        'openingHours': '08.00 - 20.00',
        'category': 'History',
        'views': '1K views',
        'rating': 4.2,
        'reviewCount': 85,
        'imagePath': 'assets/image/kayutangan.png',
        'description':
            'Historic building with thousand doors, a landmark in Semarang with Dutch colonial architecture.',
        'latitude': -6.9838,
        'longitude': 110.4103,
        'ticketPrices': [
          {'type': 'Ticket destination', 'price': 'IDR 20.000', 'day': 'Weekday'},
          {'type': 'Ticket destination', 'price': 'IDR 30.000', 'day': 'Weekend'},
        ],
        'tours': [],
        'activities': [
          'Explore historical architecture',
          'Photography tours',
          'Learn about colonial history',
        ],
        'virtualTourAvailable': false,
      },
    };

    return destinations[widget.destinationId] ??
        destinations['dest001']!; // Default fallback
  }

  Future<void> _addCustomMarker(
    MapboxMap mapboxMap, {
    required double lat,
    required double lng,
    double size = 1.5,
  }) async {
    // Add custom circle annotation for the marker
    await mapboxMap.annotations.createCircleAnnotationManager().then((
      circleManager,
    ) async {
      // Outer glow circle (shadow effect)
      circleManager.create(
        CircleAnnotationOptions(
          geometry: Point(coordinates: Position(lng, lat)),
          circleRadius: 20.0 * size,
          circleColor: 0x40539DF3, // Semi-transparent blue
          circleBlur: 1.0,
        ),
      );

      // Main circle
      circleManager.create(
        CircleAnnotationOptions(
          geometry: Point(coordinates: Position(lng, lat)),
          circleRadius: 12.0 * size,
          circleColor: 0xFF539DF3, // Solid blue
          circleStrokeWidth: 3.0 * size,
          circleStrokeColor: 0xFFFFFFFF, // White border
        ),
      );

      // Inner center dot
      circleManager.create(
        CircleAnnotationOptions(
          geometry: Point(coordinates: Position(lng, lat)),
          circleRadius: 4.0 * size,
          circleColor: 0xFFFFFFFF, // White center
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final destination = _getDestinationData();
    final hasVirtualTour = destination['virtualTourAvailable'] as bool;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Container(
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
                  LucideIcons.chevronLeft,
                  color: Color(0xFF212121),
                ),
              ),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    destination['imagePath'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFF0F0F0),
                        child: const Icon(
                          LucideIcons.image,
                          size: 64,
                          color: Color(0xFFBDBDBD),
                        ),
                      );
                    },
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                  // Page indicators (dots)
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: index == 0 ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: index == 0
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Info Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Views
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              destination['name'],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF212121),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF539DF3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              destination['views'],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Location
                      Text(
                        destination['location'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF757575),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Info Chips
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          _buildInfoChip(
                            destination['province'],
                            LucideIcons.mapPin,
                          ),
                          _buildInfoChip(
                            destination['openingHours'],
                            LucideIcons.clock,
                          ),
                          _buildInfoChip(
                            destination['category'],
                            LucideIcons.tag,
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Virtual Tour Badge (if available)
                      if (hasVirtualTour)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF539DF3).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF539DF3).withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF539DF3),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  LucideIcons.view,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'See 360 View destination',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF212121),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Loka will make 360 view for you',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEF4444),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Decline',
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
                    ],
                  ),
                ),

                // About Destination Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'About destination',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF212121),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        destination['description'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Ticket Price Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ticket Price',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF212121),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(
                        (destination['ticketPrices'] as List).length,
                        (index) {
                          final ticket = destination['ticketPrices'][index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE0E0E0),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ticket['type'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF757575),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      ticket['price'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFFEF4444),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF539DF3),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    ticket['day'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Tour Section (if available)
                if ((destination['tours'] as List).isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tour',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF212121),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(
                          (destination['tours'] as List).length,
                          (index) {
                            final tour = destination['tours'][index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE0E0E0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          tour['name'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF212121),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          tour['price'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFFEF4444),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF539DF3),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      tour['destinations'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                // Map Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Map',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF212121),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE0E0E0),
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: MapWidget(
                          cameraOptions: CameraOptions(
                            center: Point(
                              coordinates: Position(
                                destination['longitude'],
                                destination['latitude'],
                              ),
                            ),
                            zoom: 14.0,
                          ),
                          styleUri: MapboxStyles.MAPBOX_STREETS,
                          onMapCreated: (MapboxMap mapboxMap) async {
                            _mapboxMap = mapboxMap;
                            await _addCustomMarker(
                              mapboxMap,
                              lat: destination['latitude'],
                              lng: destination['longitude'],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Activities & Attractions Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Activities & Attractions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF212121),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...List.generate(
                        (destination['activities'] as List).length,
                        (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              destination['activities'][index],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                                height: 1.5,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Rating Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: List.generate(
                                  5,
                                  (index) => Icon(
                                    index < destination['rating'].floor()
                                        ? LucideIcons.star
                                        : LucideIcons.star,
                                    size: 16,
                                    color: index < destination['rating'].floor()
                                        ? const Color(0xFFFFA726)
                                        : const Color(0xFFE0E0E0),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                destination['rating'].toString(),
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF212121),
                                ),
                              ),
                              Text(
                                '${destination['reviewCount']} Reviews',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF757575),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Rating bars
                      ...List.generate(5, (index) {
                        final rating = 5 - index;
                        final percentage = rating == 5
                            ? 0.8
                            : rating == 4
                                ? 0.3
                                : rating == 3
                                    ? 0.15
                                    : rating == 2
                                        ? 0.05
                                        : 0.01;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 12,
                                child: Text(
                                  rating.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF757575),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE0E0E0),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: percentage,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF539DF3),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Action Buttons
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Show delete confirmation dialog
                            _showDeleteConfirmation(context);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(
                              color: Color(0xFFEF4444),
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Delete Destination',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFEF4444),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigate to edit page
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Edit Information'),
                                backgroundColor: Color(0xFF539DF3),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: const Color(0xFF539DF3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Edit Information',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: const Color(0xFF539DF3),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF212121),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Delete Destination?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text(
          'Are you sure you want to delete this destination? This action cannot be undone.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF757575),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xFF757575),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              context.pop(); // Go back to previous page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Destination deleted successfully'),
                  backgroundColor: Color(0xFFEF4444),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
