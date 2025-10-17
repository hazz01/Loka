import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../shared/data/models.dart';
import '../../../shared/data/destination_repository.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String selectedCategory = 'Tourist Attraction';
  List<Destination> _allDestinations = [];
  bool isLoading = true;
  String? errorMessage;
  final DestinationRepository _repository = DestinationRepository();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final destinations = await _repository.getAllDestinations();

      if (mounted) {
        setState(() {
          _allDestinations = destinations;
          isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = e.toString();
        });
      }
    }
  }

  List<Destination> get recommendedDestinations {
    return _allDestinations
        .where((dest) => dest.category == selectedCategory)
        .toList();
  }

  List<Destination> get nearestDestinations {
    final sorted = List<Destination>.from(_allDestinations);
    sorted.sort((a, b) => a.distance.compareTo(b.distance));
    return sorted.take(10).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    // Responsive sizing - Header
    final headerHeight = isSmallScreen ? 250.0 : 280.0;
    final headerPadding = isSmallScreen ? 20.0 : 30.0;
    final headerTopPadding = isSmallScreen ? 30.0 : 40.0;
    final headerIconSize = isSmallScreen ? 14.0 : 16.0;
    final headerTextSmall = isSmallScreen ? 10.0 : 12.0;
    final headerTextMedium = isSmallScreen ? 12.0 : 14.0;
    final headerTextLocation = isSmallScreen ? 13.0 : 15.0;
    final headerMapPinSize = isSmallScreen ? 12.0 : 14.0;
    final searchIconSize = isSmallScreen ? 18.0 : 20.0;
    final searchTextSize = isSmallScreen ? 12.0 : 14.0;
    final searchPadding = isSmallScreen ? 14.0 : 16.0;

    // Responsive sizing - Content
    final contentPadding = isSmallScreen ? 20.0 : 30.0;
    final tripPlannerPadding = isSmallScreen ? 14.0 : 16.0;
    final tripPlannerTitleSize = isSmallScreen ? 12.0 : 14.0;
    final tripPlannerSubtitleSize = isSmallScreen ? 9.0 : 10.0;
    final tripPlannerButtonSize = isSmallScreen ? 12.0 : 14.0;
    final tripPlannerChevronSize = isSmallScreen ? 20.0 : 24.0;
    final sectionTitleSize = isSmallScreen ? 18.0 : 20.0;
    final sectionLinkSize = isSmallScreen ? 14.0 : 16.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: CustomScrollView(
        slivers: [
          // Header with Background Image
          SliverToBoxAdapter(
            child: Stack(
              children: [
                // Background Image with Curve
                ClipPath(
                  clipper: CurvedBottomClipper(),
                  child: Container(
                    height: headerHeight,
                    decoration: BoxDecoration(
                      color: Colors.blue[700], // Placeholder background
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.1),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Content over image
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    headerPadding,
                    headerTopPadding,
                    headerPadding,
                    0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 10 : 12,
                              vertical: isSmallScreen ? 6 : 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  LucideIcons.mapPin,
                                  color: const Color(0xFF539DF3),
                                  size: headerIconSize,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Change Location",
                                  style: TextStyle(
                                    color: const Color(0xFF539DF3),
                                    fontSize: headerTextSmall,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isSmallScreen ? 35 : 45),
                      Column(
                        children: [
                          Text(
                            "location",
                            style: TextStyle(
                              fontSize: headerTextMedium,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFF8F7F7),
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 4 : 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LucideIcons.mapPin,
                                color: Colors.white,
                                size: headerMapPinSize,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "Malang, Jawa Timur",
                                style: TextStyle(
                                  fontSize: headerTextLocation,
                                  color: const Color(0xFFF8F7F7),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: isSmallScreen ? 65 : 75),
                      GestureDetector(
                        onTap: () => context.go('/search'),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: searchPadding,
                            vertical: searchPadding,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                LucideIcons.search,
                                color: Colors.black.withOpacity(0.3),
                                size: searchIconSize,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'Search destination here',
                                style: TextStyle(
                                  color: Colors.black.withOpacity(0.3),
                                  fontSize: searchTextSize,
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
              ],
            ),
          ),

          // White Container Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: contentPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: isSmallScreen ? 15 : 20),
                  Container(
                    padding: EdgeInsets.all(tripPlannerPadding),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Trip Planner',
                                style: TextStyle(
                                  fontSize: tripPlannerTitleSize,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF539DF3),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Make the best plan for your tour trip',
                                style: TextStyle(
                                  fontSize: tripPlannerSubtitleSize,
                                  color: const Color(0xFF797979),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => context.go('/trip-ai-planner'),
                            borderRadius: BorderRadius.circular(10),
                            splashColor: Colors.blue.withOpacity(0.3),
                            highlightColor: Colors.blue.withOpacity(0.1),
                            child: Ink(
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 16 : 21,
                                vertical: isSmallScreen ? 8 : 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Color(0xFF539DF3)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Create',
                                    style: TextStyle(
                                      color: const Color(0xFF539DF3),
                                      fontSize: tripPlannerButtonSize,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: isSmallScreen ? 1 : 2),
                                  Icon(
                                    LucideIcons.chevronRight,
                                    size: tripPlannerChevronSize,
                                    color: const Color(0xFF539DF3),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 35 : 50),

                  // Category Tabs - Horizontal Scrollable
                  SizedBox(
                    height: isSmallScreen ? 40 : 45,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildCategoryChip(
                          'Tourist Attraction',
                          LucideIcons.treePine,
                          selectedCategory == 'Tourist Attraction',
                          () => setState(() => selectedCategory = 'Tourist Attraction'),
                        ),
                        SizedBox(width: isSmallScreen ? 10 : 15),
                        _buildCategoryChip(
                          'Culinary',
                          LucideIcons.utensilsCrossed,
                          selectedCategory == 'Culinary',
                          () => setState(() => selectedCategory = 'Culinary'),
                        ),
                        SizedBox(width: isSmallScreen ? 10 : 15),
                        _buildCategoryChip(
                          'Souvenir',
                          LucideIcons.gift,
                          selectedCategory == 'Souvenir',
                          () => setState(() => selectedCategory = 'Souvenir'),
                        ),
                        SizedBox(width: isSmallScreen ? 10 : 15),
                        _buildCategoryChip(
                          'Tour & Trip',
                          LucideIcons.map,
                          selectedCategory == 'Tour & Trip',
                          () => setState(() => selectedCategory = 'Tour & Trip'),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 16 : 20),

                  // Recommended Section Header
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recommended',
                            style: TextStyle(
                              fontSize: sectionTitleSize,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          GestureDetector(
                            onTap: () =>
                                context.go('/explore/$selectedCategory'),
                            child: Text(
                              'Explore',
                              style: TextStyle(
                                fontSize: sectionLinkSize,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF539DF3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: isSmallScreen ? 12 : 14),

                  // Recommended Cards - Horizontal Scroll
                  SizedBox(
                    height: isSmallScreen ? 252 : 282,
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : recommendedDestinations.isEmpty
                        ? Center(
                            child: Text(
                              'Tidak ada destinasi ditemukan',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: recommendedDestinations.length > 5
                                ? 5
                                : recommendedDestinations.length,
                            itemBuilder: (context, index) {
                              final destination =
                                  recommendedDestinations[index];
                              return _buildRecommendedCard(
                                destination.imageUrl,
                                destination.name,
                                destination.rating,
                                destination.id,
                              );
                            },
                          ),
                  ),

                  SizedBox(height: isSmallScreen ? 20 : 30),

                  // Based on location Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Based on your location',
                        style: TextStyle(
                          fontSize: sectionTitleSize,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'See map',
                        style: TextStyle(
                          fontSize: sectionLinkSize,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF539DF3),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: isSmallScreen ? 6 : 8),
                ],
              ),
            ),
          ),

          // Location-based List
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final destination = nearestDestinations[index];
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 16 : 20,
                  vertical: isSmallScreen ? 5 : 6,
                ),
                child: _buildLocationCard(
                  destination.imageUrl,
                  destination.name,
                  '${destination.distance.toStringAsFixed(1)} km from you',
                  destination.rating,
                  destination.id,
                ),
              );
            }, childCount: nearestDestinations.length),
          ),

          // Bottom Padding
          SliverToBoxAdapter(child: SizedBox(height: isSmallScreen ? 16 : 20)),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final iconSize = isSmallScreen ? 18.0 : 24.0;
    final textSize = isSmallScreen ? 12.0 : 14.0;
    final chipPadding = isSmallScreen ? 8.0 : 10.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: chipPadding,
          vertical: chipPadding,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF539DF3) : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: iconSize,
              color: isSelected ? Colors.white : const Color(0xFF797979),
            ),
            SizedBox(width: isSmallScreen ? 4 : 5),
            Text(
              label,
              style: TextStyle(
                fontSize: textSize,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF797979),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedCard(
    String imageUrl,
    String title,
    double rating,
    String id,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final cardWidth = isSmallScreen ? 170.0 : 200.0;
    final imageHeight = isSmallScreen ? 170.0 : 200.0;
    final placeholderIconSize = isSmallScreen ? 45.0 : 60.0;
    final heartIconSize = isSmallScreen ? 18.0 : 20.0;
    final titleSize = isSmallScreen ? 11.0 : 12.0;
    final starSize = isSmallScreen ? 14.0 : 16.0;
    final cardPadding = isSmallScreen ? 12.0 : 15.0;
    final heartPadding = isSmallScreen ? 6.0 : 8.0;
    final heartPosition = isSmallScreen ? 8.0 : 10.0;

    return GestureDetector(
      onTap: () => context.go('/detail/$id'),
      child: Container(
        width: cardWidth,
        margin: EdgeInsets.only(right: isSmallScreen ? 12 : 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: cardPadding,
                vertical: isSmallScreen ? 12 : 14,
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(isSmallScreen ? 6 : 8),
                        ),
                        child: Container(
                          height: imageHeight,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: Icon(
                            LucideIcons.image,
                            color: Colors.grey[600],
                            size: placeholderIconSize,
                          ),
                        ),
                      ),
                      Positioned(
                        top: heartPosition,
                        right: heartPosition,
                        child: Container(
                          padding: EdgeInsets.all(heartPadding),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.8),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            LucideIcons.heart,
                            color: Colors.red,
                            size: heartIconSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isSmallScreen ? 6 : 7),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: titleSize,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isSmallScreen ? 5 : 7),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: const Color(0xFFF8D548),
                            size: starSize,
                          ),
                          SizedBox(width: isSmallScreen ? 1 : 2),
                          Text(
                            rating.toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: titleSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(
    String imageUrl,
    String title,
    String distance,
    double rating,
    String id,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final imageSize = isSmallScreen ? 65.0 : 80.0;
    final iconSize = isSmallScreen ? 12.0 : 15.0;
    final textSize = isSmallScreen ? 11.0 : 13.0;
    final titleSize = isSmallScreen ? 12.0 : 14.0;
    final starSize = isSmallScreen ? 13.0 : 16.0;
    final chevronSize = isSmallScreen ? 20.0 : 24.0;
    final cardPadding = isSmallScreen ? 10.0 : 12.0;
    final imageRadius = isSmallScreen ? 10.0 : 12.0;
    final spaceBetween = isSmallScreen ? 14.0 : 18.0;

    return GestureDetector(
      onTap: () => context.go('/detail/$id'),
      child: Container(
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(imageRadius),
              child: Container(
                width: imageSize,
                height: imageSize,
                color: Colors.grey[300],
                child: Icon(
                  LucideIcons.image,
                  color: Colors.grey[600],
                  size: imageSize * 0.4,
                ),
              ),
            ),
            SizedBox(width: spaceBetween),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        LucideIcons.mapPin,
                        size: iconSize,
                        color: const Color(0xFF7D848D),
                      ),
                      SizedBox(width: isSmallScreen ? 4 : 5),
                      Text(
                        distance,
                        style: TextStyle(
                          fontSize: textSize,
                          color: const Color(0xFF7D848D),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 10),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1B1E28),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 10),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.star,
                        size: starSize,
                        color: const Color(0xFF7D848D),
                      ),
                      SizedBox(width: isSmallScreen ? 4 : 5),
                      Text(
                        rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: textSize,
                          color: const Color(0xFF7D848D),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              color: const Color(0xFF539DF3),
              size: chevronSize,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

// Custom Clipper for Curved Bottom
class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);

    // Create smooth curve
    final firstControlPoint = Offset(size.width / 4, size.height);
    final firstEndPoint = Offset(size.width / 2, size.height - 20);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    final secondControlPoint = Offset(size.width * 3 / 4, size.height - 40);
    final secondEndPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
