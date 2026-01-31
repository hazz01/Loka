import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:card_loading/card_loading.dart';
import '../../../../shared/data/models.dart';
import '../../../../shared/data/mock_data_source.dart';
import '../state/home_providers.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  // selectedCategory is now stored in Riverpod provider so it persists
  // across navigation. Use the provider (ref) to read/write it.

  late List<Destination> recommendedDestinations;
  late List<Destination> nearestDestinations;
  bool _isLoading = true; // show card loading placeholders on first load

  // Curated partner IDs - show these when the Partner category is selected.
  // Pick IDs that exist in the mock data to avoid firstWhere exceptions.
  final List<String> _partnerIds = [
    'dest_1',
    'dest_23',
    'dest_21',
    'dest_22',
    'dest_7',
  ];

  @override
  void initState() {
    super.initState();
    // Load using the current provider value
    _loadDestinations();
  }

  void _loadDestinations() {
    setState(() {
      // Read selectedCategory from provider to be resilient across navigation
      final currentCategory = ref.read(selectedCategoryProvider);

      // If the selected category is 'Partner', show the curated partner list.
      if (currentCategory == 'Partner') {
        recommendedDestinations = MockDataSource.destinations
            .where((d) => _partnerIds.contains(d.id))
            .toList();
      } else {
        // Otherwise, show destinations that match the selected category.
        recommendedDestinations = MockDataSource.destinations
            .where((d) => d.category == currentCategory)
            .toList();
      }

      nearestDestinations = MockDataSource.getNearestDestinations(limit: 10);
      // After loading the lists, stop showing the skeleton loader.
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    // Watch the shared selectedCategory so Home will rebuild when it changes.
    final currentCategory = ref.watch(selectedCategoryProvider);

    // Responsive sizing - Header
    final headerHeight = isSmallScreen ? 250.0 : 280.0;
    final headerPadding = isSmallScreen ? 20.0 : 30.0;
    final headerTopPadding = isSmallScreen ? 30.0 : 40.0;
    final headerIconSize = isSmallScreen ? 14.0 : 16.0;
    final headerTextSmall = isSmallScreen ? 10.0 : 12.0;
    final headerTextMedium = isSmallScreen ? 12.0 : 14.0;
    final headerTextLocation = isSmallScreen ? 13.0 : 15.0;
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
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: <Widget>[
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
                                // Hero target for app logo (transition from splash)
                                Hero(
                                  tag: 'app-logo',
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Container(
                                      width: isSmallScreen ? 28 : 34,
                                      height: isSmallScreen ? 28 : 34,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: Icon(
                                        Icons.explore,
                                        color: const Color(0xFF539DF3),
                                        size: isSmallScreen ? 16 : 20,
                                      ),
                                    ),
                                  ),
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
                            'Partner',
                            LucideIcons.badgeCheck,
                            currentCategory == 'Partner',
                            () {
                              // Persist selection globally
                              ref
                                      .read(selectedCategoryProvider.notifier)
                                      .state =
                                  'Partner';
                              _loadDestinations();
                            },
                          ),
                          SizedBox(width: isSmallScreen ? 10 : 15),
                          _buildCategoryChip(
                            'Tourist Attraction',
                            LucideIcons.treePine,
                            currentCategory == 'Tourist Attraction',
                            () {
                              ref
                                      .read(selectedCategoryProvider.notifier)
                                      .state =
                                  'Tourist Attraction';
                              _loadDestinations();
                            },
                          ),
                          SizedBox(width: isSmallScreen ? 10 : 15),
                          _buildCategoryChip(
                            'Culinary',
                            LucideIcons.utensilsCrossed,
                            currentCategory == 'Culinary',
                            () {
                              ref
                                      .read(selectedCategoryProvider.notifier)
                                      .state =
                                  'Culinary';
                              _loadDestinations();
                            },
                          ),
                          SizedBox(width: isSmallScreen ? 10 : 15),
                          _buildCategoryChip(
                            'Souvenir',
                            LucideIcons.gift,
                            currentCategory == 'Souvenir',
                            () {
                              ref
                                      .read(selectedCategoryProvider.notifier)
                                      .state =
                                  'Souvenir';
                              _loadDestinations();
                            },
                          ),
                          SizedBox(width: isSmallScreen ? 10 : 15),
                          _buildCategoryChip(
                            'Tour & Trip',
                            LucideIcons.map,
                            currentCategory == 'Tour & Trip',
                            () {
                              ref
                                      .read(selectedCategoryProvider.notifier)
                                      .state =
                                  'Tour & Trip';
                              _loadDestinations();
                            },
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: isSmallScreen ? 16 : 20),

                    // Recommended / Partner header
                    if (currentCategory == 'Partner')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isSmallScreen ? 8 : 10,
                                          vertical: isSmallScreen ? 4 : 5,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFF539DF3),
                                              Color(0xFF3B7DD8),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              LucideIcons.badgeCheck,
                                              size: isSmallScreen ? 12 : 14,
                                              color: Colors.white,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              'VERIFIED PARTNER',
                                              style: TextStyle(
                                                fontSize: isSmallScreen
                                                    ? 9
                                                    : 10,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: isSmallScreen ? 8 : 10),
                                  Text(
                                    'Featured Destinations',
                                    style: TextStyle(
                                      fontSize: sectionTitleSize,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: isSmallScreen ? 4 : 6),
                                  Text(
                                    'Explore our exclusive partner destinations',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 11 : 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                    else
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
                            onTap: () => context.go(
                              '/explore/${Uri.encodeComponent(currentCategory)}',
                            ),
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

                    SizedBox(height: isSmallScreen ? 14 : 16),

                    // Partner Destinations Cards - Horizontal Scroll
                    SizedBox(
                      height: isSmallScreen ? 270 : 300,
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
                                  _partnerIds.contains(destination.id),
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

            // Location-based List (with skeleton while loading)
            _isLoading
                ? SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 16 : 20,
                          vertical: isSmallScreen ? 8 : 10,
                        ),
                        child: CardLoading(
                          height: isSmallScreen ? 84 : 100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      );
                    }, childCount: 6),
                  )
                : SliverList(
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
            SliverToBoxAdapter(
              child: SizedBox(height: isSmallScreen ? 16 : 20),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshData() async {
    // simple refresh: show skeletons then reload
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() {
      final currentCategory = ref.read(selectedCategoryProvider);
      if (currentCategory == 'Partner') {
        recommendedDestinations = MockDataSource.destinations
            .where((d) => _partnerIds.contains(d.id))
            .toList();
      } else {
        recommendedDestinations = MockDataSource.destinations
            .where((d) => d.category == currentCategory)
            .toList();
      }
      nearestDestinations = MockDataSource.getNearestDestinations(limit: 10);
      _isLoading = false;
    });
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
    bool isPartner,
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
      onTap: () => context.push('/detail/$id'),
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
                      // Partnership Badge (only shown for actual partners)
                      if (isPartner)
                        Positioned(
                          top: heartPosition,
                          left: heartPosition,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isSmallScreen ? 6 : 8,
                              vertical: isSmallScreen ? 4 : 5,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF539DF3), Color(0xFF3B7DD8)],
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  LucideIcons.badgeCheck,
                                  size: isSmallScreen ? 10 : 11,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 3),
                                Text(
                                  'PARTNER',
                                  style: TextStyle(
                                    fontSize: isSmallScreen ? 8 : 9,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
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
      onTap: () => context.push('/detail/$id'),
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
              child: Image.network(
                imageUrl,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
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
