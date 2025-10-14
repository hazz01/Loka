import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../shared/data/models.dart';
import '../../../shared/data/mock_data_source.dart';

class ExplorePage extends StatefulWidget {
  final String category;

  const ExplorePage({super.key, required this.category});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late List<Destination> destinations;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDestinations();
  }

  void _loadDestinations() {
    setState(() {
      isLoading = true;
    });

    // Simulate loading
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        destinations = MockDataSource.getDestinationsByCategory(
          widget.category,
        );
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    // Responsive sizing
    final appBarIconSize = isSmallScreen ? 22.0 : 25.0;
    final appBarTitleSize = isSmallScreen ? 14.0 : 16.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: const Color(0xFFF4F4F4),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            LucideIcons.chevronLeft,
            color: Colors.black,
            size: appBarIconSize,
          ),
          onPressed: () => context.go('/'),
        ),
        centerTitle: true,
        title: Text(
          widget.category,
          style: TextStyle(
            color: Colors.black,
            fontSize: appBarTitleSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF539DF3)),
            )
          : destinations.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.searchX,
                    size: isSmallScreen ? 56.0 : 64.0,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada destinasi ditemukan',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14.0 : 16.0,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              itemCount: destinations.length,
              itemBuilder: (context, index) {
                final destination = destinations[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: _buildDestinationCard(destination),
                );
              },
            ),
    );
  }

  Widget _buildDestinationCard(Destination destination) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    // Responsive sizing
    final imageSize = isSmallScreen ? 85.0 : 100.0;
    final imagePlaceholderIconSize = isSmallScreen ? 35.0 : 40.0;
    final titleFontSize = isSmallScreen ? 14.0 : 16.0;
    final subtitleFontSize = isSmallScreen ? 12.0 : 13.0;
    final iconSize = isSmallScreen ? 12.0 : 14.0;
    final chevronSize = isSmallScreen ? 20.0 : 24.0;
    final spacingWidth = isSmallScreen ? 12.0 : 16.0;

    return GestureDetector(
      onTap: () => context.go('/detail/${destination.id}'),
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
                destination.imageUrl,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: imageSize,
                    height: imageSize,
                    color: Colors.grey[300],
                    child: Icon(
                      LucideIcons.image,
                      color: Colors.grey,
                      size: imagePlaceholderIconSize,
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: spacingWidth),
            SizedBox(width: spacingWidth),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination.name,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1B1E28),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.mapPin,
                        size: iconSize,
                        color: const Color(0xFF7D848D),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          destination.location,
                          style: TextStyle(
                            fontSize: subtitleFontSize,
                            color: const Color(0xFF7D848D),
                            fontWeight: FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.star,
                        size: iconSize,
                        color: const Color(0xFFF8D548),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        destination.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: const Color(0xFF7D848D),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        LucideIcons.navigation,
                        size: iconSize,
                        color: const Color(0xFF7D848D),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${destination.distance.toStringAsFixed(1)} km',
                        style: TextStyle(
                          fontSize: subtitleFontSize,
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
}
