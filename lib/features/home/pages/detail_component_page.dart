import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailComponentPage extends StatefulWidget {
  final String destinationId;

  const DetailComponentPage({super.key, required this.destinationId});

  @override
  State<DetailComponentPage> createState() => _DetailComponentPageState();
}

class _DetailComponentPageState extends State<DetailComponentPage> {
  String selectedTab = 'overview';
  String selectedTicketType = 'Weekday';
  String? selectedTour; // null means no tour selected
  bool isFavorite = false;

  // Ticket prices
  final int weekdayPrice = 50000;
  final int weekendPrice = 0; // 0 means not available

  // Tour options with prices
  final Map<String, int> tourOptions = {
    'Highlight Tour': 50000,
    'Family Fun Tour': 150000,
  };

  // Mapbox configuration
  static const String mapboxAccessToken =
      'pk.eyJ1IjoiaDQyNCIsImEiOiJja21ycXB0dnQwYWhnMnZudGR3eWFlOGJnIn0.NYHwuoDP3269P5dsZ7-HLQ';
  static const double destinationLat = -7.9797;
  static const double destinationLng = 112.6304;

  // ignore: unused_field
  MapboxMap? _mapboxMap;

  @override
  void initState() {
    super.initState();
    MapboxOptions.setAccessToken(mapboxAccessToken);
  }

  Future<void> _addCustomMarker(
    MapboxMap mapboxMap, {
    double size = 1.5,
  }) async {
    // Add custom circle annotation for the marker
    await mapboxMap.annotations.createCircleAnnotationManager().then((
      circleManager,
    ) async {
      // Outer glow circle (shadow effect)
      circleManager.create(
        CircleAnnotationOptions(
          geometry: Point(
            coordinates: Position(destinationLng, destinationLat),
          ),
          circleRadius: 20.0 * size,
          circleColor: 0x40539DF3, // Semi-transparent blue
          circleBlur: 1.0,
        ),
      );

      // Main circle
      circleManager.create(
        CircleAnnotationOptions(
          geometry: Point(
            coordinates: Position(destinationLng, destinationLat),
          ),
          circleRadius: 12.0 * size,
          circleColor: 0xFF539DF3, // Solid blue
          circleStrokeWidth: 3.0 * size,
          circleStrokeColor: 0xFFFFFFFF, // White border
        ),
      );

      // Inner circle
      circleManager.create(
        CircleAnnotationOptions(
          geometry: Point(
            coordinates: Position(destinationLng, destinationLat),
          ),
          circleRadius: 5.0 * size,
          circleColor: 0xFFFFFFFF, // White center
        ),
      );
    });

    // Add pulsing animation effect with another circle
    await mapboxMap.annotations.createCircleAnnotationManager().then((
      pulseManager,
    ) async {
      pulseManager.create(
        CircleAnnotationOptions(
          geometry: Point(
            coordinates: Position(destinationLng, destinationLat),
          ),
          circleRadius: 25.0 * size,
          circleColor: 0x20539DF3, // Very transparent blue
          circleBlur: 0.8,
        ),
      );
    });
  }

  int get totalPrice {
    int ticketPrice = selectedTicketType == 'Weekday'
        ? weekdayPrice
        : weekendPrice;
    int tourPrice = selectedTour != null ? (tourOptions[selectedTour] ?? 0) : 0;
    return ticketPrice + tourPrice;
  }

  Future<void> _openGoogleMaps() async {
    // Try to open with Google Maps app first
    final googleMapsUrl = Uri.parse(
      'google.navigation:q=$destinationLat,$destinationLng&mode=d',
    );

    // If Google Maps app not available, use browser version
    final googleMapsBrowserUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$destinationLat,$destinationLng',
    );

    try {
      // Try to launch Google Maps app
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl);
      } else {
        // Fallback to browser version
        await launchUrl(
          googleMapsBrowserUrl,
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      // If all fails, show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open maps application'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive scaling factors
    final scale = screenWidth / 375; // Base width 375 (iPhone size)
    final textScale = MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2);

    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4),
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: const Color(0xFFF4F4F4),
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.chevronLeft, color: Colors.black, size: 25),
          onPressed: () => context.go('/'),
        ),
        centerTitle: true,
        title: Text(
          "Details  ",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
              size: 25,
            ),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main Content - Scrollable
          CustomScrollView(
            slivers: [
              // Content Section with horizontal margin
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image - Square/Rectangle shape
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: double.infinity,
                          height: screenHeight * 0.35, // 35% of screen height
                          child: Image.network(
                            'https://images.unsplash.com/photo-1580837119756-563d608dd119?w=800',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Tabs (overview | maps | reviews)
                      Row(
                        children: [
                          _buildTab('overview'),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              '|',
                              style: TextStyle(color: Color(0xFF797979)),
                            ),
                          ),
                          _buildTab('maps'),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              '|',
                              style: TextStyle(color: Color(0xFF797979)),
                            ),
                          ),
                          _buildTab('reviews'),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // Title and Rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'kampoeng heritage kajoetangan',
                              style: TextStyle(
                                fontSize: (18 * scale).clamp(14.0, 18.0),
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: (20 * scale).clamp(18.0, 24.0),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '5.0',
                                style: TextStyle(
                                  fontSize: (16 * scale).clamp(14.0, 20.0),
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      // Location
                      Row(
                        children: [
                          Icon(
                            LucideIcons.mapPin,
                            size: 16,
                            color: Color(0xFF969696),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            'Jl. Besar Ijen Ggg. 4, Malang',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF969696),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // Time
                      Row(
                        children: [
                          Icon(
                            LucideIcons.clock,
                            size: 16,
                            color: Color(0xFF969696),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '7:00 AM - 5:30 PM',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF969696),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // 360 View Button
                      GestureDetector(
                        onTap: () => context.go(
                          '/detail/${widget.destinationId}/virtual-tour',
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF539DF3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/image/360_icon.png',
                                width: (30 * scale).clamp(24.0, 36.0),
                                height: (30 * scale).clamp(24.0, 36.0),
                                color: Colors.white,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'See 360 View destination',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: (16 * scale).clamp(
                                            12.0,
                                            14.0,
                                          ),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'See 360 View you will want to see',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.70),
                                          fontSize: (10 * scale).clamp(
                                            9.0,
                                            10.0,
                                          ),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Try 360 View',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: (9 * scale).clamp(8.0, 11.0),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // About destination
                      Text(
                        'About destination',
                        style: TextStyle(
                          fontSize: (16 * scale).clamp(14.0, 20.0),
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Kampoeng Heritage Kajoetangan is a historical neighborhood in Malang, renowned for its well-preserved colonial-era architecture. This area offers a glimpse into the past with its vintage houses, old-fashioned shops, and traditional markets, providing visitors with a unique showcase of Indonesia\'s colonial history and local culture.\n\nIn addition to its historical charm, Kampoeng Heritage Kajoetangan is a vibrant cultural hub. It hosts various cultural festivals, art exhibitions, and traditional performances, showcasing local artistry. The neighborhood\'s quaint cafes and eateries add to its nostalgic ambiance, making it a beloved destination for history enthusiasts and culture lovers alike.',
                        style: TextStyle(
                          fontSize: (14 * scale).clamp(12.0, 14.0),
                          color: Color(0xFF8F8B8B),
                          fontWeight: FontWeight.w500,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 35),

                      // Ticket Price Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ticket Price',
                            style: TextStyle(
                              fontSize: (16 * scale).clamp(14.0, 20.0),
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF131313),
                            ),
                          ),
                          // Weekday/Weekend Toggle on the right
                          Row(
                            children: [
                              _buildTicketTypeButton(
                                'Weekday',
                                selectedTicketType == 'Weekday',
                                scale,
                              ),
                              const SizedBox(width: 8),
                              _buildTicketTypeButton(
                                'Weekend',
                                selectedTicketType == 'Weekend',
                                scale,
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Ticket Options - Dynamic based on selected type
                      if (selectedTicketType == 'Weekday')
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Weekday",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFB4B4B4),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Ticket destination",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF131313),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "IDR ${weekdayPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black.withOpacity(0.70),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "+tax",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFB4B4B4),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.orange.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.orange,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Ticket Not Available",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.orange[800],
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "Weekend tickets are currently unavailable. Please select Weekday.",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 35),
                      // Available Tour
                      Text(
                        'Available Tour',
                        style: TextStyle(
                          fontSize: (16 * scale).clamp(14.0, 20.0),
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF131313),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Tour Option 1
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selectedTour == 'Highlight Tour') {
                              selectedTour =
                                  null; // Deselect if already selected
                            } else {
                              selectedTour = 'Highlight Tour';
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: selectedTour == 'Highlight Tour'
                                ? Border.all(color: Color(0xFF539DF3), width: 2)
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: selectedTour == 'Highlight Tour'
                                            ? Color(0xFF539DF3)
                                            : Color(0xFFB4B4B4),
                                        width: 2,
                                      ),
                                    ),
                                    child: selectedTour == 'Highlight Tour'
                                        ? Center(
                                            child: Container(
                                              width: 12,
                                              height: 12,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xFF539DF3),
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Highlight Tour',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFFB4B4B4),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        '5 Destination',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF131313),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'IDR ${tourOptions['Highlight Tour']!.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black.withOpacity(0.70),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '+tax',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFB4B4B4),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Tour Option 2
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selectedTour == 'Family Fun Tour') {
                              selectedTour =
                                  null; // Deselect if already selected
                            } else {
                              selectedTour = 'Family Fun Tour';
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: selectedTour == 'Family Fun Tour'
                                ? Border.all(color: Color(0xFF539DF3), width: 2)
                                : null,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: selectedTour == 'Family Fun Tour'
                                            ? Color(0xFF539DF3)
                                            : Color(0xFFB4B4B4),
                                        width: 2,
                                      ),
                                    ),
                                    child: selectedTour == 'Family Fun Tour'
                                        ? Center(
                                            child: Container(
                                              width: 12,
                                              height: 12,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xFF539DF3),
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Family Fun Tour',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFFB4B4B4),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        '5 Destination',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF131313),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'IDR ${tourOptions['Family Fun Tour']!.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black.withOpacity(0.70),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '+tax',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFFB4B4B4),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 35),

                      // Map Section
                      Text(
                        'Map',
                        style: TextStyle(
                          fontSize: (16 * scale).clamp(14.0, 20.0),
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF131313),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = 'maps';
                          });
                          _showFullscreenMap();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Stack(
                            children: [
                              // Mapbox Preview Map
                              Container(
                                height:
                                    screenHeight * 0.25, // 25% of screen height
                                width: double.infinity,
                                child: MapWidget(
                                  cameraOptions: CameraOptions(
                                    center: Point(
                                      coordinates: Position(
                                        destinationLng,
                                        destinationLat,
                                      ),
                                    ),
                                    zoom: 14.0,
                                  ),
                                  styleUri: MapboxStyles.MAPBOX_STREETS,
                                  onMapCreated: (MapboxMap mapboxMap) async {
                                    // Add custom marker
                                    await _addCustomMarker(
                                      mapboxMap,
                                      size: 1.2,
                                    );
                                  },
                                ),
                              ),
                              // Overlay to indicate it's tappable
                              Positioned(
                                bottom: 12,
                                right: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.map,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'View on Map',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 35),

                      // Activities and Attractions
                      Text(
                        'Activities and Attractions',
                        style: TextStyle(
                          fontSize: (16 * scale).clamp(14.0, 20.0),
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF131313),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildBulletPoint(
                        'Explore the rich history of Malang',
                        scale,
                      ),
                      _buildBulletPoint(
                        'Antiques and artifacts exhibition',
                        scale,
                      ),
                      _buildBulletPoint(
                        'Photography with ancient houses in the background',
                        scale,
                      ),
                      _buildBulletPoint(
                        'Local cultural performances (specific schedules)',
                        scale,
                      ),
                      _buildBulletPoint('Interactive historical tours', scale),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          final bottomScale = constraints.maxWidth / 375;
          return Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Container(
              height: 50,
              margin: const EdgeInsets.all(30),
              decoration: BoxDecoration(color: Colors.transparent),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            totalPrice > 0
                                ? "IDR ${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}"
                                : "IDR 0",
                            style: TextStyle(
                              fontSize: (16 * bottomScale).clamp(14.0, 18.0),
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          selectedTour != null ? "Ticket + Tour" : "Per person",
                          style: TextStyle(
                            fontSize: (12 * bottomScale).clamp(10.0, 14.0),
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF797979),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            (selectedTicketType == 'Weekday' && totalPrice > 0)
                            ? () {
                                context.go(
                                  '/detail/${widget.destinationId}/booking',
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF539DF3),
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
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Booking Ticket",
                            style: TextStyle(
                              fontSize: (16 * bottomScale).clamp(14.0, 18.0),
                              fontWeight: FontWeight.w600,
                              color:
                                  (selectedTicketType == 'Weekday' &&
                                      totalPrice > 0)
                                  ? Colors.white
                                  : Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFullscreenMap() {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              // Fullscreen Interactive Mapbox Map
              Positioned.fill(
                child: MapWidget(
                  cameraOptions: CameraOptions(
                    center: Point(
                      coordinates: Position(destinationLng, destinationLat),
                    ),
                    zoom: 15.0,
                  ),
                  styleUri: MapboxStyles.MAPBOX_STREETS,
                  onMapCreated: (MapboxMap mapboxMap) async {
                    _mapboxMap = mapboxMap;

                    // Add custom marker with larger size for fullscreen
                    await _addCustomMarker(mapboxMap, size: 1.5);
                  },
                ),
              ),
              // Close Button
              Positioned(
                top: 50,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(Icons.close, color: Colors.black, size: 24),
                  ),
                ),
              ),
              // Info Card at Bottom
              Positioned(
                bottom: 30,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kampoeng Heritage Kajoetangan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            LucideIcons.mapPin,
                            size: 16,
                            color: Color(0xFF539DF3),
                          ),
                          SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Jl. Besar Ijen Ggg. 4, Malang',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF969696),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Pinch to zoom • Drag to pan',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFFB4B4B4),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(height: 16),
                      // Get Directions Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _openGoogleMaps,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF539DF3),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          icon: Icon(LucideIcons.navigation, size: 18),
                          label: Text(
                            'Get Directions',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
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
      },
    );
  }

  Widget _buildTab(String tab) {
    final isSelected = selectedTab == tab;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = tab;
        });
        // If maps tab is clicked, show fullscreen map
        if (tab == 'maps') {
          _showFullscreenMap();
        }
      },
      child: Text(
        tab,
        style: TextStyle(
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
          color: isSelected ? Color(0xFF539DF3) : Color(0xFF797979),
        ),
      ),
    );
  }

  Widget _buildTicketTypeButton(String type, bool isSelected, double scale) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTicketType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF539DF3) : Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.calendar,
              size: (20 * scale).clamp(16.0, 24.0),
              color: isSelected ? Colors.white : Color(0xFFBDBDBD),
            ),
            const SizedBox(width: 8),
            Text(
              type,
              style: TextStyle(
                fontSize: (12 * scale).clamp(10.0, 14.0),
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Color(0xFFBDBDBD),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text, double scale) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 7),
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: Colors.black87,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: (14 * scale).clamp(12.0, 14.0),
                color: Color(0xFF8F8B8B),
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
