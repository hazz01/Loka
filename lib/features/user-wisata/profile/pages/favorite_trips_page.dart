import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../shared/widgets/smart_image_widget.dart';

class FavoriteTripsPage extends StatefulWidget {
  const FavoriteTripsPage({super.key});

  @override
  State<FavoriteTripsPage> createState() => _FavoriteTripsPageState();
}

class _FavoriteTripsPageState extends State<FavoriteTripsPage> {
  List<Map<String, dynamic>> favoriteTrips = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteTrips();
  }

  Future<void> _loadFavoriteTrips() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? favoritesJson = prefs.getString('favorite_trips');

      if (favoritesJson != null) {
        final List<dynamic> decoded = jsonDecode(favoritesJson);
        setState(() {
          favoriteTrips = decoded
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
          isLoading = false;
        });
      } else {
        // Initialize with some dummy data if no favorites exist
        await _initializeDummyData();
      }
    } catch (e) {
      print('Error loading favorites: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _initializeDummyData() async {
    // Array data lokal untuk favorite trips menggunakan gambar lokal
    final dummyData = [
      {
        'id': 'trip_001',
        'destination': 'Gunung Bromo',
        'location': 'Probolinggo, Jawa Timur',
        'imageUrl': 'assets/image/homepage_travel/gunung_bromo_picture.png',
        'rating': 4.9,
        'price': 'IDR 35K',
        'category': 'Nature',
      },
      {
        'id': 'trip_002',
        'destination': 'Pantai Balekambang',
        'location': 'Malang, Jawa Timur',
        'imageUrl':
            'assets/image/homepage_travel/pantai_balekambang_picture.png',
        'rating': 4.7,
        'price': 'IDR 15K',
        'category': 'Beach',
      },
      {
        'id': 'trip_003',
        'destination': 'Jatim Park 2',
        'location': 'Batu, Jawa Timur',
        'imageUrl': 'assets/image/homepage_travel/jatimpark2_picture.png',
        'rating': 4.8,
        'price': 'IDR 100K',
        'category': 'Theme Park',
      },
      {
        'id': 'trip_004',
        'destination': 'Museum Angkut',
        'location': 'Batu, Jawa Timur',
        'imageUrl': 'assets/image/homepage_travel/museum_angkut_picture.png',
        'rating': 4.6,
        'price': 'IDR 90K',
        'category': 'Museum',
      },
      {
        'id': 'trip_005',
        'destination': 'Air Terjun Coban Rondo',
        'location': 'Malang, Jawa Timur',
        'imageUrl':
            'assets/image/homepage_travel/air_terjun_coban_rondo_picture.png',
        'rating': 4.5,
        'price': 'IDR 20K',
        'category': 'Nature',
      },
      {
        'id': 'trip_006',
        'destination': 'Kampung Warna Warni Jodipan',
        'location': 'Malang, Jawa Timur',
        'imageUrl': 'assets/image/homepage_travel/kampung_jodipan_picture.png',
        'rating': 4.4,
        'price': 'IDR 5K',
        'category': 'Cultural',
      },
      {
        'id': 'trip_007',
        'destination': 'Selecta',
        'location': 'Batu, Jawa Timur',
        'imageUrl': 'assets/image/homepage_travel/selecta_picture.png',
        'rating': 4.3,
        'price': 'IDR 30K',
        'category': 'Recreation',
      },
    ];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('favorite_trips', jsonEncode(dummyData));

    setState(() {
      favoriteTrips = dummyData;
      isLoading = false;
    });
  }

  Future<void> _removeFavorite(String id) async {
    try {
      final updatedFavorites = favoriteTrips
          .where((trip) => trip['id'] != id)
          .toList();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('favorite_trips', jsonEncode(updatedFavorites));

      setState(() {
        favoriteTrips = updatedFavorites;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed from favorites'),
            duration: Duration(seconds: 2),
            backgroundColor: Color(0xFF539DF3),
          ),
        );
      }
    } catch (e) {
      print('Error removing favorite: $e');
    }
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
        leading: IconButton(
          icon: Icon(
            LucideIcons.chevronLeft,
            color: Colors.black,
            size: (24 * scale).clamp(22.0, 26.0),
          ),
          onPressed: () => context.go('/profile'),
        ),
        title: Text(
          "Favorite Trips",
          style: TextStyle(
            color: Colors.black,
            fontSize: (16 * scale).clamp(14.0, 18.0),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFF539DF3)))
          : favoriteTrips.isEmpty
          ? _buildEmptyState(isSmallScreen, scale)
          : ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 20 : 30,
                vertical: isSmallScreen ? 16 : 20,
              ),
              itemCount: favoriteTrips.length,
              itemBuilder: (context, index) {
                final trip = favoriteTrips[index];
                return _buildFavoriteCard(
                  context: context,
                  trip: trip,
                  isSmallScreen: isSmallScreen,
                  scale: scale,
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(bool isSmallScreen, double scale) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all((40 * scale).clamp(30.0, 50.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.heart,
              size: (80 * scale).clamp(60.0, 100.0),
              color: Color(0xFF7D848D).withOpacity(0.5),
            ),
            SizedBox(height: (20 * scale).clamp(16.0, 24.0)),
            Text(
              'No Favorites Yet',
              style: TextStyle(
                fontSize: (20 * scale).clamp(18.0, 24.0),
                fontWeight: FontWeight.w600,
                color: Color(0xFF1B1E28),
              ),
            ),
            SizedBox(height: (8 * scale).clamp(6.0, 10.0)),
            Text(
              'Start adding destinations to your favorites!',
              style: TextStyle(
                fontSize: (14 * scale).clamp(12.0, 16.0),
                color: Color(0xFF7D848D),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteCard({
    required BuildContext context,
    required Map<String, dynamic> trip,
    required bool isSmallScreen,
    required double scale,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: (16 * scale).clamp(12.0, 20.0)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isSmallScreen ? 12 : 16),
              bottomLeft: Radius.circular(isSmallScreen ? 12 : 16),
            ),
            child: SmartImageWidget(
              imageUrl: trip['imageUrl'],
              width: (120 * scale).clamp(100.0, 140.0),
              height: (140 * scale).clamp(120.0, 160.0),
              fit: BoxFit.cover,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isSmallScreen ? 12 : 16),
                bottomLeft: Radius.circular(isSmallScreen ? 12 : 16),
              ),
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.all((12 * scale).clamp(10.0, 14.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trip['destination'],
                              style: TextStyle(
                                fontSize: (16 * scale).clamp(14.0, 18.0),
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1B1E28),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: (4 * scale).clamp(3.0, 5.0)),
                            Row(
                              children: [
                                Icon(
                                  LucideIcons.mapPin,
                                  size: (12 * scale).clamp(10.0, 14.0),
                                  color: Color(0xFF7D848D),
                                ),
                                SizedBox(width: (4 * scale).clamp(3.0, 5.0)),
                                Expanded(
                                  child: Text(
                                    trip['location'],
                                    style: TextStyle(
                                      fontSize: (12 * scale).clamp(10.0, 14.0),
                                      color: Color(0xFF7D848D),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          LucideIcons.heart,
                          color: Colors.red,
                          size: (20 * scale).clamp(18.0, 24.0),
                        ),
                        onPressed: () => _removeFavorite(trip['id']),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),
                  SizedBox(height: (8 * scale).clamp(6.0, 10.0)),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: (6 * scale).clamp(5.0, 8.0),
                      vertical: (3 * scale).clamp(2.0, 4.0),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFF539DF3).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      trip['category'],
                      style: TextStyle(
                        fontSize: (11 * scale).clamp(9.0, 13.0),
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF539DF3),
                      ),
                    ),
                  ),
                  SizedBox(height: (8 * scale).clamp(6.0, 10.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            LucideIcons.star,
                            size: (14 * scale).clamp(12.0, 16.0),
                            color: Color(0xFFFFB800),
                          ),
                          SizedBox(width: (4 * scale).clamp(3.0, 5.0)),
                          Text(
                            trip['rating'].toString(),
                            style: TextStyle(
                              fontSize: (13 * scale).clamp(11.0, 15.0),
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1B1E28),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        trip['price'],
                        style: TextStyle(
                          fontSize: (14 * scale).clamp(12.0, 16.0),
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF539DF3),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
