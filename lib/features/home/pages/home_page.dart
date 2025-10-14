import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../shared/data/models.dart';
import '../../../shared/data/mock_data_source.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String selectedCategory = 'Tourist Attraction';
  late List<Destination> recommendedDestinations;
  late List<Destination> nearestDestinations;

  @override
  void initState() {
    super.initState();
    _loadDestinations();
  }

  void _loadDestinations() {
    setState(() {
      recommendedDestinations = MockDataSource.getDestinationsByCategory(
        selectedCategory,
      );
      nearestDestinations = MockDataSource.getNearestDestinations(limit: 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    // Responsive sizing
    final headerIconSize = isSmallScreen ? 14.0 : 16.0;
    final headerTextSmall = isSmallScreen ? 10.0 : 12.0;
    final headerTextMedium = isSmallScreen ? 12.0 : 14.0;
    final headerTextLocation = isSmallScreen ? 13.0 : 15.0;
    final headerMapPinSize = isSmallScreen ? 12.0 : 14.0;
    final searchIconSize = isSmallScreen ? 18.0 : 20.0;
    final searchTextSize = isSmallScreen ? 12.0 : 14.0;

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
                    height: 280,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://ik.imagekit.io/tvlk/image/imageResource/2025/10/09/1760028548328-f4fcfe5f76665952afaf0d14d6d7fea5.png?tr=q-75',
                        ),
                        fit: BoxFit.cover,
                      ),
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
                  padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
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
                      SizedBox(height: 45),
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
                          const SizedBox(height: 5),
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
                      SizedBox(height: 60),
                      GestureDetector(
                        onTap: () => context.go('/search'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
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
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(16),
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 21,
                                vertical: 10,
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
                                  const SizedBox(width: 2),
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

                  const SizedBox(height: 50),

                  // Category Tabs - Horizontal Scrollable
                  SizedBox(
                    height: 45,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildCategoryChip(
                          'Tourist Attraction',
                          LucideIcons.treePine,
                          selectedCategory == 'Tourist Attraction',
                          () {
                            setState(() {
                              selectedCategory = 'Tourist Attraction';
                              recommendedDestinations =
                                  MockDataSource.getDestinationsByCategory(
                                    selectedCategory,
                                  );
                            });
                          },
                        ),
                        const SizedBox(width: 15),
                        _buildCategoryChip(
                          'Culinary',
                          LucideIcons.utensilsCrossed,
                          selectedCategory == 'Culinary',
                          () {
                            setState(() {
                              selectedCategory = 'Culinary';
                              recommendedDestinations =
                                  MockDataSource.getDestinationsByCategory(
                                    selectedCategory,
                                  );
                            });
                          },
                        ),
                        const SizedBox(width: 15),
                        _buildCategoryChip(
                          'Souvenir',
                          LucideIcons.gift,
                          selectedCategory == 'Souvenir',
                          () {
                            setState(() {
                              selectedCategory = 'Souvenir';
                              recommendedDestinations =
                                  MockDataSource.getDestinationsByCategory(
                                    selectedCategory,
                                  );
                            });
                          },
                        ),
                        const SizedBox(width: 15),
                        _buildCategoryChip(
                          'Tour & Trip',
                          LucideIcons.map,
                          selectedCategory == 'Tour & Trip',
                          () {
                            setState(() {
                              selectedCategory = 'Tour & Trip';
                              recommendedDestinations =
                                  MockDataSource.getDestinationsByCategory(
                                    selectedCategory,
                                  );
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

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

                  const SizedBox(height: 14),

                  // Recommended Cards - Horizontal Scroll
                  SizedBox(
                    height: 282,
                    child: recommendedDestinations.isEmpty
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

                  const SizedBox(height: 30),

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

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // Location-based List
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final destination = nearestDestinations[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 6,
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
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
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
    final isSmallScreen = screenWidth < 360;
    final iconSize = isSmallScreen ? 20.0 : 24.0;
    final textSize = isSmallScreen ? 12.0 : 14.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
            const SizedBox(width: 5),
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
    final isSmallScreen = screenWidth < 360;
    final cardWidth = isSmallScreen ? 180.0 : 200.0;
    final imageHeight = isSmallScreen ? 180.0 : 200.0;
    final placeholderIconSize = isSmallScreen ? 50.0 : 60.0;
    final heartIconSize = isSmallScreen ? 18.0 : 20.0;
    final titleSize = isSmallScreen ? 11.0 : 12.0;
    final starSize = isSmallScreen ? 14.0 : 16.0;

    return GestureDetector(
      onTap: () => context.go('/detail/$id'),
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.only(right: 15),
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
              child: Column(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        child: Image.network(
                          imageUrl,
                          height: imageHeight,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: imageHeight,
                              color: Colors.grey[300],
                              child: Icon(
                                LucideIcons.image,
                                color: Colors.grey,
                                size: placeholderIconSize,
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
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
                  const SizedBox(height: 7),
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
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: const Color(0xFFF8D548),
                            size: starSize,
                          ),
                          const SizedBox(width: 2),
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
    final isSmallScreen = screenWidth < 360;
    final imageSize = isSmallScreen ? 70.0 : 80.0;
    final iconSize = isSmallScreen ? 13.0 : 15.0;
    final textSize = isSmallScreen ? 12.0 : 13.0;
    final titleSize = isSmallScreen ? 13.0 : 14.0;
    final starSize = isSmallScreen ? 14.0 : 16.0;
    final chevronSize = isSmallScreen ? 20.0 : 24.0;

    return GestureDetector(
      onTap: () => context.go('/detail/$id'),
      child: Container(
        padding: const EdgeInsets.all(12),
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
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 18),
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
                      const SizedBox(width: 5),
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
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.star,
                        size: starSize,
                        color: const Color(0xFF7D848D),
                      ),
                      const SizedBox(width: 5),
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
