import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../shared/data/models.dart';
import '../services/destination_detail_service.dart';

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
  bool isLoading = true;
  Destination? destinationDetail;

  // Mapbox configuration
  static const String mapboxAccessToken =
      'pk.eyJ1IjoiaDQyNCIsImEiOiJja21ycXB0dnQwYWhnMnZudGR3eWFlOGJnIn0.NYHwuoDP3269P5dsZ7-HLQ';

  // ignore: unused_field
  MapboxMap? _mapboxMap;

  @override
  void initState() {
    super.initState();
    MapboxOptions.setAccessToken(mapboxAccessToken);
    _loadDestinationDetail();
  }

  Future<void> _loadDestinationDetail() async {
    try {
      final detail = await DestinationDetailService.getDestinationDetail(
        widget.destinationId,
      );
      setState(() {
        destinationDetail = detail;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load destination details'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _addCustomMarker(
    MapboxMap mapboxMap, {
    double size = 1.5,
  }) async {
    if (destinationDetail == null ||
        destinationDetail!.latitude == null ||
        destinationDetail!.longitude == null)
      return;

    final lat = destinationDetail!.latitude!;
    final lng = destinationDetail!.longitude!;

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

      // Inner circle
      circleManager.create(
        CircleAnnotationOptions(
          geometry: Point(coordinates: Position(lng, lat)),
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
          geometry: Point(coordinates: Position(lng, lat)),
          circleRadius: 25.0 * size,
          circleColor: 0x20539DF3, // Very transparent blue
          circleBlur: 0.8,
        ),
      );
    });
  }

  int get totalPrice {
    if (destinationDetail == null || destinationDetail!.ticketPrices == null) {
      return 0;
    }

    final ticketPrice = destinationDetail!.ticketPrices!
        .firstWhere(
          (ticket) => ticket.type == selectedTicketType,
          orElse: () => const TicketPrice(type: '', price: 0),
        )
        .price;

    final tourPrice =
        selectedTour != null && destinationDetail!.tourOptions != null
        ? destinationDetail!.tourOptions!
              .firstWhere(
                (tour) => tour.id == selectedTour,
                orElse: () => const TourOption(
                  id: '',
                  name: '',
                  description: '',
                  price: 0,
                  destinationCount: 0,
                ),
              )
              .price
        : 0;

    return ticketPrice + tourPrice;
  }

  Future<void> _openGoogleMaps() async {
    if (destinationDetail == null) return;

    final lat = destinationDetail!.latitude;
    final lng = destinationDetail!.longitude;

    // Try to open with Google Maps app first
    final googleMapsUrl = Uri.parse('google.navigation:q=$lat,$lng&mode=d');

    // If Google Maps app not available, use browser version
    final googleMapsBrowserUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
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
    final isSmallScreen = screenWidth < 600;

    // Responsive scaling factors
    final scale = isSmallScreen ? 0.85 : (screenWidth / 375).clamp(0.85, 1.1);

    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4),
      appBar: AppBar(
        toolbarHeight: isSmallScreen ? 56 : 70,
        backgroundColor: const Color(0xFFF4F4F4),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            LucideIcons.chevronLeft,
            color: Colors.black,
            size: isSmallScreen ? 22 : 25,
          ),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: Text(
          "Details  ",
          style: TextStyle(
            color: Colors.black,
            fontSize: isSmallScreen ? 14 : 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
              size: isSmallScreen ? 22 : 25,
            ),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFF539DF3)))
          : destinationDetail == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Destination not found',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                // Main Content - Scrollable
                CustomScrollView(
                  slivers: [
                    // Content Section with horizontal margin
                    SliverPadding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 16 : 30,
                        vertical: isSmallScreen ? 6 : 10,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image - Square/Rectangle shape
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                isSmallScreen ? 8 : 12,
                              ),
                              child: Container(
                                width: double.infinity,
                                height: isSmallScreen
                                    ? screenHeight * 0.28
                                    : screenHeight * 0.40,
                                child: Image.network(
                                  destinationDetail!.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: Icon(
                                        Icons.image_not_supported,
                                        size: 64,
                                        color: Colors.grey[500],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                            SizedBox(height: isSmallScreen ? 12 : 18),

                            // Tabs (overview | maps | reviews)
                            Row(
                              children: [
                                _buildTab('overview'),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Text(
                                    '|',
                                    style: TextStyle(color: Color(0xFF797979)),
                                  ),
                                ),
                                _buildTab('maps'),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Text(
                                    '|',
                                    style: TextStyle(color: Color(0xFF797979)),
                                  ),
                                ),
                                _buildTab('reviews'),
                              ],
                            ),

                            SizedBox(height: isSmallScreen ? 16 : 25),

                            // Title and Rating
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    destinationDetail!.name,
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
                                      destinationDetail!.rating.toString(),
                                      style: TextStyle(
                                        fontSize: (16 * scale).clamp(
                                          14.0,
                                          20.0,
                                        ),
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: isSmallScreen ? 3 : 5),
                            // Location
                            Row(
                              children: [
                                Icon(
                                  LucideIcons.mapPin,
                                  size: 16,
                                  color: Color(0xFF969696),
                                ),
                                const SizedBox(width: 2),
                                Expanded(
                                  child: Text(
                                    destinationDetail!.address ??
                                        destinationDetail!.location,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF969696),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: isSmallScreen ? 2 : 4),

                            // Time
                            if (destinationDetail!.openingHours != null)
                              Row(
                                children: [
                                  Icon(
                                    LucideIcons.clock,
                                    size: 16,
                                    color: Color(0xFF969696),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    destinationDetail!.openingHours!,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF969696),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),

                            SizedBox(height: isSmallScreen ? 10 : 18),

                            // 360 View Button — show only when virtual tour is available
                            if (destinationDetail!.hasVirtualTour == true &&
                                (destinationDetail!.virtualTourUrl ?? '')
                                    .isNotEmpty)
                              GestureDetector(
                                onTap: () async {
                                  final urlStr =
                                      (destinationDetail!.virtualTourUrl ?? '')
                                          .trim();
                                  if (urlStr.isEmpty) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Virtual tour URL not available',
                                          ),
                                        ),
                                      );
                                    }
                                    return;
                                  }

                                  Uri? uri;
                                  try {
                                    uri = Uri.parse(urlStr);
                                  } catch (_) {
                                    uri = null;
                                  }

                                  if (uri == null ||
                                      !(uri.hasScheme &&
                                          (uri.scheme.startsWith('http') ||
                                              uri.scheme == 'https'))) {
                                    // Try to prepend https if scheme missing
                                    try {
                                      uri = Uri.parse('https://$urlStr');
                                    } catch (_) {
                                      uri = null;
                                    }
                                  }

                                  if (uri == null) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Invalid virtual tour URL',
                                          ),
                                        ),
                                      );
                                    }
                                    return;
                                  }

                                  try {
                                    // Prefer opening inside the app (in-app browser).
                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(
                                        uri,
                                        mode: LaunchMode.inAppWebView,
                                      );
                                    } else {
                                      await launchUrl(
                                        uri,
                                        mode: LaunchMode.externalApplication,
                                      );
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Could not open URL: ${e.toString()}',
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: isSmallScreen ? 10 : 12,
                                    horizontal: isSmallScreen ? 8 : 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF539DF3),
                                    borderRadius: BorderRadius.circular(
                                      isSmallScreen ? 8 : 12,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/image/360_icon.png',
                                        width: (30 * scale).clamp(
                                          isSmallScreen ? 20.0 : 24.0,
                                          36.0,
                                        ),
                                        height: (30 * scale).clamp(
                                          isSmallScreen ? 20.0 : 24.0,
                                          36.0,
                                        ),
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: isSmallScreen ? 8 : 12),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: isSmallScreen ? 6 : 8,
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
                                                  color: Colors.white
                                                      .withOpacity(0.70),
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
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isSmallScreen ? 6 : 8,
                                          vertical: isSmallScreen ? 7 : 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            isSmallScreen ? 6 : 8,
                                          ),
                                        ),
                                        child: Text(
                                          'Try 360 View',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: (9 * scale).clamp(
                                              8.0,
                                              11.0,
                                            ),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              // Placeholder when no VR available (not partner)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: isSmallScreen ? 10 : 12,
                                  horizontal: isSmallScreen ? 8 : 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(
                                    isSmallScreen ? 8 : 12,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/image/360_icon.png',
                                      width: (30 * scale).clamp(
                                        isSmallScreen ? 20.0 : 24.0,
                                        36.0,
                                      ),
                                      height: (30 * scale).clamp(
                                        isSmallScreen ? 20.0 : 24.0,
                                        36.0,
                                      ),
                                      color: Colors.black87,
                                    ),
                                    SizedBox(width: isSmallScreen ? 8 : 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '360 View not available',
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: (16 * scale).clamp(
                                                12.0,
                                                14.0,
                                              ),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            'Virtual tour not available for this destination (not a partner yet)',
                                            style: TextStyle(
                                              color: Colors.black54,
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
                                  ],
                                ),
                              ),

                            SizedBox(height: isSmallScreen ? 18 : 28),

                            // About destination
                            Text(
                              'About destination',
                              style: TextStyle(
                                fontSize: (16 * scale).clamp(14.0, 20.0),
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 12 : 20),
                            Text(
                              destinationDetail!.description,
                              style: TextStyle(
                                fontSize: (14 * scale).clamp(12.0, 14.0),
                                color: Color(0xFF8F8B8B),
                                fontWeight: FontWeight.w500,
                                height: 1.6,
                              ),
                            ),

                            SizedBox(height: isSmallScreen ? 20 : 35),

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
                            Builder(
                              builder: (context) {
                                if (destinationDetail!.ticketPrices == null ||
                                    destinationDetail!.ticketPrices!.isEmpty) {
                                  return Container(
                                    padding: EdgeInsets.all(
                                      isSmallScreen ? 12 : 20,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(
                                        isSmallScreen ? 8 : 12,
                                      ),
                                    ),
                                    child: Text(
                                      'Ticket information not available',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  );
                                }

                                final selectedTicket = destinationDetail!
                                    .ticketPrices!
                                    .firstWhere(
                                      (ticket) =>
                                          ticket.type == selectedTicketType,
                                      orElse: () =>
                                          const TicketPrice(type: '', price: 0),
                                    );

                                if (selectedTicket.isAvailable &&
                                    selectedTicket.price > 0)
                                  return Container(
                                    padding: EdgeInsets.all(
                                      isSmallScreen ? 12 : 20,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                        isSmallScreen ? 8 : 12,
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              selectedTicketType,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "IDR ${selectedTicket.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black.withOpacity(
                                                  0.70,
                                                ),
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
                                  );
                                else
                                  return Container(
                                    padding: EdgeInsets.all(
                                      isSmallScreen ? 12 : 20,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(
                                        isSmallScreen ? 8 : 12,
                                      ),
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
                                          size: isSmallScreen ? 18 : 24,
                                        ),
                                        SizedBox(width: isSmallScreen ? 8 : 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                "$selectedTicketType tickets are currently unavailable. Please select another option.",
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
                                  );
                              },
                            ),
                            SizedBox(height: isSmallScreen ? 20 : 35),
                            // Available Tour
                            if (destinationDetail!.tourOptions != null &&
                                destinationDetail!.tourOptions!.isNotEmpty) ...[
                              Text(
                                'Available Tour',
                                style: TextStyle(
                                  fontSize: (16 * scale).clamp(14.0, 20.0),
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF131313),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Dynamic Tour Options
                              ...destinationDetail!.tourOptions!.asMap().entries.map((
                                entry,
                              ) {
                                final index = entry.key;
                                final tour = entry.value;
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom:
                                        index <
                                            destinationDetail!
                                                    .tourOptions!
                                                    .length -
                                                1
                                        ? (isSmallScreen ? 10 : 15)
                                        : 0,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (selectedTour == tour.id) {
                                          selectedTour =
                                              null; // Deselect if already selected
                                        } else {
                                          selectedTour = tour.id;
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(
                                        isSmallScreen ? 12 : 20,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          isSmallScreen ? 8 : 12,
                                        ),
                                        border: selectedTour == tour.id
                                            ? Border.all(
                                                color: Color(0xFF539DF3),
                                                width: 2,
                                              )
                                            : null,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: isSmallScreen ? 18 : 24,
                                                height: isSmallScreen ? 18 : 24,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color:
                                                        selectedTour == tour.id
                                                        ? Color(0xFF539DF3)
                                                        : Color(0xFFB4B4B4),
                                                    width: 2,
                                                  ),
                                                ),
                                                child: selectedTour == tour.id
                                                    ? Center(
                                                        child: Container(
                                                          width: isSmallScreen
                                                              ? 8
                                                              : 12,
                                                          height: isSmallScreen
                                                              ? 8
                                                              : 12,
                                                          decoration:
                                                              BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Color(
                                                                  0xFF539DF3,
                                                                ),
                                                              ),
                                                        ),
                                                      )
                                                    : null,
                                              ),
                                              SizedBox(
                                                width: isSmallScreen ? 8 : 12,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    tour.name,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xFFB4B4B4),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: isSmallScreen
                                                        ? 3
                                                        : 5,
                                                  ),
                                                  Text(
                                                    '${tour.destinationCount} Destination',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xFF131313),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'IDR ${tour.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black
                                                      .withOpacity(0.70),
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
                                );
                              }).toList(),
                            ],

                            SizedBox(height: isSmallScreen ? 20 : 35),

                            // Map Section
                            Text(
                              'Map',
                              style: TextStyle(
                                fontSize: (16 * scale).clamp(14.0, 20.0),
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF131313),
                              ),
                            ),
                            SizedBox(height: isSmallScreen ? 12 : 20),
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
                                      height: isSmallScreen
                                          ? screenHeight * 0.18
                                          : screenHeight *
                                                0.25, // 25% of screen height
                                      width: double.infinity,
                                      child:
                                          destinationDetail!.longitude !=
                                                  null &&
                                              destinationDetail!.latitude !=
                                                  null
                                          ? MapWidget(
                                              cameraOptions: CameraOptions(
                                                center: Point(
                                                  coordinates: Position(
                                                    destinationDetail!
                                                        .longitude!,
                                                    destinationDetail!
                                                        .latitude!,
                                                  ),
                                                ),
                                                zoom: 14.0,
                                              ),
                                              styleUri:
                                                  MapboxStyles.MAPBOX_STREETS,
                                              onMapCreated:
                                                  (MapboxMap mapboxMap) async {
                                                    // Add custom marker
                                                    await _addCustomMarker(
                                                      mapboxMap,
                                                      size: 1.2,
                                                    );
                                                  },
                                            )
                                          : Container(
                                              color: Colors.grey[300],
                                              child: Center(
                                                child: Text(
                                                  'Map not available',
                                                  style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ),
                                    // Overlay to indicate it's tappable
                                    Positioned(
                                      bottom: isSmallScreen ? 8 : 12,
                                      right: isSmallScreen ? 8 : 12,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isSmallScreen ? 8 : 12,
                                          vertical: isSmallScreen ? 4 : 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.7),
                                          borderRadius: BorderRadius.circular(
                                            isSmallScreen ? 14 : 20,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.map,
                                              color: Colors.white,
                                              size: isSmallScreen ? 13 : 16,
                                            ),
                                            SizedBox(
                                              width: isSmallScreen ? 4 : 6,
                                            ),
                                            Text(
                                              'View on Map',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: isSmallScreen
                                                    ? 10
                                                    : 12,
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

                            SizedBox(height: isSmallScreen ? 20 : 35),

                            // Activities and Attractions
                            if (destinationDetail!.activities != null &&
                                destinationDetail!.activities!.isNotEmpty) ...[
                              Text(
                                'Activities and Attractions',
                                style: TextStyle(
                                  fontSize: (16 * scale).clamp(14.0, 20.0),
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF131313),
                                ),
                              ),
                              SizedBox(height: isSmallScreen ? 12 : 20),
                              ...destinationDetail!.activities!
                                  .map(
                                    (activity) =>
                                        _buildBulletPoint(activity, scale),
                                  )
                                  .toList(),
                            ],
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
          final isSmallBottom = constraints.maxWidth < 600;
          return Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Container(
              height: isSmallBottom ? 44 : 50,
              margin: EdgeInsets.all(isSmallBottom ? 16 : 30),
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
                              fontSize: (16 * bottomScale).clamp(
                                isSmallBottom ? 12.0 : 14.0,
                                18.0,
                              ),
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          selectedTour != null ? "Ticket + Tour" : "Per person",
                          style: TextStyle(
                            fontSize: (12 * bottomScale).clamp(
                              isSmallBottom ? 9.0 : 10.0,
                              14.0,
                            ),
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
                        onPressed: (totalPrice > 0)
                            ? () {
                                context.go(
                                  '/detail/${widget.destinationId}/booking',
                                );
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
                          disabledBackgroundColor: const Color(0xFFE5E7EB),
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
                              color: (totalPrice > 0)
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
    if (destinationDetail == null ||
        destinationDetail!.longitude == null ||
        destinationDetail!.latitude == null)
      return;

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
                      coordinates: Position(
                        destinationDetail!.longitude!,
                        destinationDetail!.latitude!,
                      ),
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
                        destinationDetail!.name,
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
                              destinationDetail!.address ??
                                  destinationDetail!.location,
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
