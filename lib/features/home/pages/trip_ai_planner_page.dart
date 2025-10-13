import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class TripAIPlannerPage extends StatefulWidget {
  const TripAIPlannerPage({super.key});

  @override
  State<TripAIPlannerPage> createState() => _TripAIPlannerPageState();
}

class _TripAIPlannerPageState extends State<TripAIPlannerPage>
    with TickerProviderStateMixin {
  String? selectedCategory;
  late AnimationController _buttonController;
  late Animation<double> _buttonScaleAnimation;
  late Animation<Color?> _buttonColorAnimation;

  final List<CategoryData> categories = [
    CategoryData(
      id: 'province',
      title: 'Province',
      image: 'assets/image/province.png',
      tags: ['West Java', 'Central Java', 'East Java', 'Bali'],
      route: '/trip-ai-planner/provinsi',
    ),
    CategoryData(
      id: 'greater-city',
      title: 'Greater City',
      image: 'assets/image/greater_city.png',
      tags: ['Jakarta', 'Bandung', 'Jogja', 'Surabaya', 'Malang'],
      route: '/trip-ai-planner/greater-city',
    ),
    CategoryData(
      id: 'city',
      title: 'City',
      image: 'assets/image/city.png',
      tags: ['Surabaya', 'Malang', 'Batu', 'Bayuwangi', 'Mojokerto'],
      route: '/trip-ai-planner/city',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _buttonScaleAnimation = Tween<double>(begin: 0.95, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeOutCubic),
    );

    _buttonColorAnimation =
        ColorTween(
          begin: const Color(0xFFF3F4F6),
          end: const Color(0xFF539DF3),
        ).animate(
          CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  void _selectCategory(String categoryId) {
    setState(() {
      if (selectedCategory == categoryId) {
        selectedCategory = null;
        _buttonController.reverse();
      } else {
        selectedCategory = categoryId;
        _buttonController.forward();
      }
    });
  }

  void _navigateToCategory() {
    if (selectedCategory != null) {
      final category = categories.firstWhere((c) => c.id == selectedCategory);
      context.go(category.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 768;
    final isLargeScreen = screenWidth > 1024;
    final isSmallScreen = screenWidth < 375;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        title: const Text(
          'Trip AI Planner',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            LucideIcons.chevronLeft,
            color: Colors.black,
            size: 25,
          ),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Choose your trip category",
                style: TextStyle(
                  fontSize: isTablet ? 24 : 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: Column(
                  children: [
                    ...categories
                        .asMap()
                        .entries
                        .map((entry) {
                          final index = entry.key;
                          final category = entry.value;
                          final isSelected = selectedCategory == category.id;

                          return [
                            _buildFlexibleCategoryCard(
                              category: category,
                              isSelected: isSelected,
                              isTablet: isTablet,
                            ),
                            if (index < categories.length - 1)
                              const SizedBox(height: 15),
                          ];
                        })
                        .expand((widgets) => widgets),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(30),
        child: AnimatedBuilder(
          animation: _buttonController,
          builder: (context, child) {
            return Transform.scale(
              scale: _buttonScaleAnimation.value,
              child: ElevatedButton(
                onPressed: selectedCategory != null
                    ? _navigateToCategory
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _buttonColorAnimation.value,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: selectedCategory != null
                        ? Colors.white
                        : const Color(0xFF6B7280),
                  ),
                  child: const Text("Next Process"),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFlexibleCategoryCard({
    required CategoryData category,
    required bool isSelected,
    required bool isTablet,
  }) {
    final flex = isSelected ? 5 : 3;

    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: () => _selectCategory(category.id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutCubic,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: AssetImage(category.image),
              fit: BoxFit.cover,
            ),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(isSelected ? 0.2 : 0.1),
                  Colors.black.withOpacity(isSelected ? 0.3 : 0.1),
                ],
              ),
              border: isSelected
                  ? Border.all(color: Colors.white.withOpacity(0.3), width: 2)
                  : null,
            ),
            padding: EdgeInsets.all(isSelected ? 24 : 16),
            child: Column(
              mainAxisAlignment: isSelected
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isSelected) const SizedBox(height: 20) else const Spacer(),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOutCubic,
                  style: TextStyle(
                    fontSize: _getTitleFontSize(isSelected, isTablet),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: isSelected ? 0.5 : 0,
                  ),
                  child: Text(category.title, textAlign: TextAlign.center),
                ),
                if (isSelected) ...[
                  const SizedBox(height: 12),
                  _buildTagsRow(category.tags, isTablet, isSelected),
                  const SizedBox(height: 12),
                ] else ...[
                  const SizedBox(height: 12),
                  _buildTagsRow(category.tags, isTablet, isSelected),
                  const Spacer(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _getTitleFontSize(bool isSelected, bool isTablet) {
    if (isSelected) {
      return isTablet ? 15 : 35;
    } else {
      return isTablet ? 15 : 25;
    }
  }

  Widget _buildTagsRow(
    List<String> tags,
    bool isTablet, [
    bool isSelected = false,
  ]) {
    final displayTags = tags;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      opacity: isSelected ? 1.0 : 1.0,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        tween: Tween(begin: 0.9, end: isSelected ? 0.9 : 0.9),
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 8,
              children: displayTags.asMap().entries.map((entry) {
                final index = entry.key;
                final tag = entry.value;
                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 300 + (index * 50)),
                  curve: Curves.easeOutCubic,
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 10,
                            color: const Color(0xFF3B82F6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}

class CategoryData {
  final String id;
  final String title;
  final String image;
  final List<String> tags;
  final String route;

  CategoryData({
    required this.id,
    required this.title,
    required this.image,
    required this.tags,
    required this.route,
  });
}
