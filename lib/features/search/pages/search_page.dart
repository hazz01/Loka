import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:card_loading/card_loading.dart';

// Use shared destination model and mock data so detail pages can resolve IDs
import '../../../shared/data/models.dart';
import '../../../shared/data/mock_data_source.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  List<String> searchHistory = ["Museum Angkut", "Jatim Park 1"];
  List<Destination> filteredDestinations = [];
  String selectedCategory = "All";
  String selectedPriceRange = "All";
  double selectedRating = 0.0;
  bool _isSearching = false;
  // Use mock data from shared MockDataSource so detail page can find the
  // destination by id. Copy the list to avoid accidental mutation of the
  // original mock list.
  final List<Destination> allDestinations = List<Destination>.from(
    MockDataSource.destinations,
  );

  @override
  void initState() {
    super.initState();
    // Initialize to show all destinations by default
    filteredDestinations = List<Destination>.from(allDestinations);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    // simulate search delay and show skeletons
    // setState(() {
    //   _isSearching = true;
    // });

    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      setState(() {
        if (query.isEmpty) {
          // show all destinations when query is empty
          filteredDestinations = List<Destination>.from(allDestinations);
        } else {
          filteredDestinations = allDestinations.where((destination) {
            return destination.name.toLowerCase().contains(
                  query.toLowerCase(),
                ) ||
                destination.location.toLowerCase().contains(
                  query.toLowerCase(),
                ) ||
                destination.category.toLowerCase().contains(
                  query.toLowerCase(),
                );
          }).toList();
        }

        // Apply filters
        _applyFilters();
        // _isSearching = false;
      });
    });
  }

  void _addToSearchHistory(String query) {
    if (query.isNotEmpty && !searchHistory.contains(query)) {
      setState(() {
        searchHistory.insert(0, query);
        if (searchHistory.length > 5) {
          searchHistory = searchHistory.sublist(0, 5);
        }
      });
    }
  }

  void _applyFilters() {
    setState(() {
      var filtered = searchController.text.isEmpty
          ? allDestinations
          : allDestinations.where((destination) {
              return destination.name.toLowerCase().contains(
                    searchController.text.toLowerCase(),
                  ) ||
                  destination.location.toLowerCase().contains(
                    searchController.text.toLowerCase(),
                  ) ||
                  destination.category.toLowerCase().contains(
                    searchController.text.toLowerCase(),
                  );
            }).toList();

      // Filter by category
      if (selectedCategory != "All") {
        filtered = filtered
            .where((destination) => destination.category == selectedCategory)
            .toList();
      }

      // Filter by rating
      if (selectedRating > 0) {
        filtered = filtered
            .where((destination) => destination.rating >= selectedRating)
            .toList();
      }

      filteredDestinations = filtered;
    });
  }

  void _removeFromHistory(String item) {
    setState(() {
      searchHistory.remove(item);
    });
  }

  void _selectFromHistory(String item) {
    setState(() {
      searchController.text = item;
      _performSearch(item);
    });
  }

  void _showFilterBottomSheet() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final scale = isSmallScreen ? 0.85 : (screenWidth / 375).clamp(0.85, 1.1);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: BoxDecoration(
                color: Color(0xFFF4F4F4),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isSmallScreen ? 20 : 24),
                  topRight: Radius.circular(isSmallScreen ? 20 : 24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Container(
                    margin: EdgeInsets.only(
                      top: (12 * scale).clamp(10.0, 14.0),
                      bottom: (8 * scale).clamp(6.0, 10.0),
                    ),
                    width: (40 * scale).clamp(35.0, 45.0),
                    height: (4 * scale).clamp(3.0, 5.0),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Filter content
                  Padding(
                    padding: EdgeInsets.all((24 * scale).clamp(20.0, 28.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Filters",
                          style: TextStyle(
                            fontSize: (20 * scale).clamp(18.0, 22.0),
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1B1E28),
                          ),
                        ),
                        SizedBox(height: (24 * scale).clamp(20.0, 28.0)),
                        // Category Filter
                        Text(
                          "Category",
                          style: TextStyle(
                            fontSize: (16 * scale).clamp(14.0, 18.0),
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1B1E28),
                          ),
                        ),
                        SizedBox(height: (12 * scale).clamp(10.0, 14.0)),
                        Wrap(
                          spacing: (8 * scale).clamp(6.0, 10.0),
                          runSpacing: (8 * scale).clamp(6.0, 10.0),
                          children:
                              [
                                "All",
                                "Tourist Attraction",
                                "Heritage",
                                "Culinary",
                                "Souvenir",
                                "Tour & Trip",
                              ].map((category) {
                                final isSelected = selectedCategory == category;
                                return GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      selectedCategory = category;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: (16 * scale).clamp(
                                        14.0,
                                        18.0,
                                      ),
                                      vertical: (10 * scale).clamp(8.0, 12.0),
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Color(0xFF539DF3)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(
                                        isSmallScreen ? 18 : 20,
                                      ),
                                      border: Border.all(
                                        color: isSelected
                                            ? Color(0xFF539DF3)
                                            : Colors.black12,
                                      ),
                                    ),
                                    child: Text(
                                      category,
                                      style: TextStyle(
                                        fontSize: (14 * scale).clamp(
                                          12.0,
                                          16.0,
                                        ),
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? Colors.white
                                            : Color(0xFF6B7280),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                        SizedBox(height: (24 * scale).clamp(20.0, 28.0)),
                        // Rating Filter
                        Text(
                          "Minimum Rating",
                          style: TextStyle(
                            fontSize: (16 * scale).clamp(14.0, 18.0),
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1B1E28),
                          ),
                        ),
                        SizedBox(height: (12 * scale).clamp(10.0, 14.0)),
                        Row(
                          children: [
                            Expanded(
                              child: Slider(
                                value: selectedRating,
                                min: 0,
                                max: 5,
                                divisions: 10,
                                activeColor: Color(0xFF539DF3),
                                label: selectedRating == 0
                                    ? "All"
                                    : selectedRating.toStringAsFixed(1),
                                onChanged: (value) {
                                  setModalState(() {
                                    selectedRating = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: (12 * scale).clamp(10.0, 14.0)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: (12 * scale).clamp(10.0, 14.0),
                                vertical: (6 * scale).clamp(5.0, 7.0),
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFF539DF3),
                                borderRadius: BorderRadius.circular(
                                  isSmallScreen ? 6 : 8,
                                ),
                              ),
                              child: Text(
                                selectedRating == 0
                                    ? "All"
                                    : selectedRating.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: (14 * scale).clamp(12.0, 16.0),
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: (24 * scale).clamp(20.0, 28.0)),
                        // Apply button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _applyFilters();
                              });
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF539DF3),
                              padding: EdgeInsets.symmetric(
                                vertical: (16 * scale).clamp(14.0, 18.0),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  isSmallScreen ? 10 : 12,
                                ),
                              ),
                            ),
                            child: Text(
                              "Apply Filters",
                              style: TextStyle(
                                fontSize: (16 * scale).clamp(14.0, 18.0),
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: (12 * scale).clamp(10.0, 14.0)),
                        // Reset button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              setModalState(() {
                                selectedCategory = "All";
                                selectedRating = 0.0;
                              });
                              setState(() {
                                selectedCategory = "All";
                                selectedRating = 0.0;
                                _applyFilters();
                              });
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: (16 * scale).clamp(14.0, 18.0),
                              ),
                              side: BorderSide(color: Color(0xFF539DF3)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  isSmallScreen ? 10 : 12,
                                ),
                              ),
                            ),
                            child: Text(
                              "Reset Filters",
                              style: TextStyle(
                                fontSize: (16 * scale).clamp(14.0, 18.0),
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF539DF3),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onRefreshSearch() async {
    // Simulate a refresh: show skeletons briefly then restore full list
    setState(() {
      _isSearching = true;
    });

    await Future.delayed(const Duration(milliseconds: 350));

    if (!mounted) return;
    setState(() {
      searchController.clear();
      selectedCategory = "All";
      selectedRating = 0.0;
      // restore all destinations after refresh
      filteredDestinations = List<Destination>.from(allDestinations);
      _isSearching = false;
    });
  }

  Widget _buildDestinationCard(
    Destination destination,
    bool isSmallScreen,
    double scale,
  ) {
    // Use styling similar to ExplorePage's destination card and make sure we
    // reference the shared model fields (imageUrl, distance as double).
    final imageSize = isSmallScreen ? 80.0 : 100.0;
    final imagePlaceholderIconSize = isSmallScreen ? 32.0 : 40.0;
    final titleFontSize = isSmallScreen ? 13.0 : 16.0;
    final subtitleFontSize = isSmallScreen ? 11.0 : 13.0;
    final iconSize = isSmallScreen ? 12.0 : 14.0;
    final chevronSize = isSmallScreen ? 20.0 : 24.0;
    final spacingWidth = isSmallScreen ? 10.0 : 16.0;
    final cardPadding = isSmallScreen ? 10.0 : 12.0;
    final imageRadius = isSmallScreen ? 10.0 : 12.0;

    return GestureDetector(
      onTap: () => context.push('/detail/${destination.id}'),
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
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: imageSize,
                    height: imageSize,
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF539DF3),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
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
                  SizedBox(height: isSmallScreen ? 6 : 8),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.mapPin,
                        size: iconSize,
                        color: const Color(0xFF7D848D),
                      ),
                      SizedBox(width: isSmallScreen ? 3 : 4),
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
                  SizedBox(height: isSmallScreen ? 6 : 8),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.star,
                        size: iconSize,
                        color: const Color(0xFFF8D548),
                      ),
                      SizedBox(width: isSmallScreen ? 3 : 4),
                      Text(
                        destination.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: const Color(0xFF7D848D),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 8 : 12),
                      Icon(
                        LucideIcons.navigation,
                        size: iconSize,
                        color: const Color(0xFF7D848D),
                      ),
                      SizedBox(width: isSmallScreen ? 3 : 4),
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final scale = isSmallScreen ? 0.85 : (screenWidth / 375).clamp(0.85, 1.1);

    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4),
      appBar: AppBar(
        toolbarHeight: isSmallScreen ? 56 : 70,
        backgroundColor: const Color(0xFFF4F4F4),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Search destination",
          style: TextStyle(
            color: Colors.black,
            fontSize: (16 * scale).clamp(14.0, 18.0),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefreshSearch,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 20 : 30,
            vertical: isSmallScreen ? 16 : 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: _performSearch,
                      onSubmitted: (value) {
                        _addToSearchHistory(value);
                        _performSearch(value);
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Search destination here',
                        hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.3),
                          fontSize: (14 * scale).clamp(12.0, 16.0),
                          fontWeight: FontWeight.w500,
                        ),
                        prefixIcon: Icon(
                          LucideIcons.search,
                          color: Colors.black.withOpacity(0.3),
                          size: (17 * scale).clamp(15.0, 19.0),
                        ),
                        suffixIcon: searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  LucideIcons.x,
                                  color: Colors.black.withOpacity(0.3),
                                  size: (17 * scale).clamp(15.0, 19.0),
                                ),
                                onPressed: () {
                                  setState(() {
                                    searchController.clear();
                                    _performSearch('');
                                  });
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            isSmallScreen ? 10 : 12,
                          ),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: (20 * scale).clamp(16.0, 24.0),
                          vertical: (12 * scale).clamp(10.0, 14.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: (10 * scale).clamp(8.0, 12.0)),
                  GestureDetector(
                    onTap: _showFilterBottomSheet,
                    child: Container(
                      padding: EdgeInsets.all((12 * scale).clamp(10.0, 14.0)),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          isSmallScreen ? 10 : 12,
                        ),
                      ),
                      child: Icon(
                        LucideIcons.settings2,
                        color: Color(0xFF212121),
                        size: (24 * scale).clamp(22.0, 26.0),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: (20 * scale).clamp(16.0, 24.0)),
              // Search History - only show when search is empty and no active filters
              if (searchHistory.isNotEmpty &&
                  searchController.text.isEmpty &&
                  selectedCategory == "All" &&
                  selectedRating == 0.0)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: (10 * scale).clamp(8.0, 12.0),
                    runSpacing: (10 * scale).clamp(8.0, 12.0),
                    children: searchHistory.map((item) {
                      return GestureDetector(
                        onTap: () => _selectFromHistory(item),
                        child: Container(
                          padding: EdgeInsets.all(
                            (10 * scale).clamp(8.0, 12.0),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              isSmallScreen ? 10 : 12,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item,
                                style: TextStyle(
                                  fontSize: (12 * scale).clamp(11.0, 14.0),
                                  color: Color(0xFF6B7280),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: (10 * scale).clamp(8.0, 12.0)),
                              GestureDetector(
                                onTap: () {
                                  _removeFromHistory(item);
                                },
                                child: Icon(
                                  LucideIcons.circleX,
                                  size: (17 * scale).clamp(15.0, 19.0),
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              SizedBox(height: (20 * scale).clamp(16.0, 24.0)),
              // Search Results - always show results (defaults to all destinations)
              SizedBox(height: (12 * scale).clamp(10.0, 16.0)),
              if (_isSearching)
                Column(
                  children: List.generate(6, (index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 16 : 20,
                        vertical: isSmallScreen ? 8 : 10,
                      ),
                      child: CardLoading(
                        // Use same container style as Home page skeletons
                        height: isSmallScreen ? 84 : 100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  }),
                )
              else if (filteredDestinations.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: (40 * scale).clamp(30.0, 50.0),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          LucideIcons.searchX,
                          size: (48 * scale).clamp(40.0, 56.0),
                          color: Colors.black38,
                        ),
                        SizedBox(height: (16 * scale).clamp(12.0, 20.0)),
                        Text(
                          "No destinations found",
                          style: TextStyle(
                            fontSize: (16 * scale).clamp(14.0, 18.0),
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Column(
                  children: filteredDestinations.map((destination) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: (16 * scale).clamp(12.0, 20.0),
                      ),
                      child: _buildDestinationCard(
                        destination,
                        isSmallScreen,
                        scale,
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
