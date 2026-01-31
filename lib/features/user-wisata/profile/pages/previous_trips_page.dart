import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PreviousTripsPage extends StatelessWidget {
  const PreviousTripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final scale = isSmallScreen ? 0.85 : (screenWidth / 375).clamp(0.85, 1.1);

    // Dummy data for previous trips
    final previousTrips = [
      {
        'id': 1,
        'destination': 'Bali Island',
        'location': 'Bali, Indonesia',
        'date': 'Dec 15-20, 2024',
        'imageUrl': 'https://images.unsplash.com/photo-1537996194471-e657df975ab4',
        'rating': 4.8,
        'activities': 3,
      },
      {
        'id': 2,
        'destination': 'Mount Bromo',
        'location': 'East Java, Indonesia',
        'date': 'Nov 10-12, 2024',
        'imageUrl': 'https://images.unsplash.com/photo-1555400082-f2b6b1c0b5d4',
        'rating': 4.9,
        'activities': 2,
      },
      {
        'id': 3,
        'destination': 'Raja Ampat',
        'location': 'West Papua, Indonesia',
        'date': 'Oct 5-10, 2024',
        'imageUrl': 'https://images.unsplash.com/photo-1559827260-dc66d52bef19',
        'rating': 5.0,
        'activities': 5,
      },
      {
        'id': 4,
        'destination': 'Borobudur Temple',
        'location': 'Yogyakarta, Indonesia',
        'date': 'Sep 20-22, 2024',
        'imageUrl': 'https://images.unsplash.com/photo-1588668214407-6ea9a6d8c272',
        'rating': 4.7,
        'activities': 2,
      },
      {
        'id': 5,
        'destination': 'Komodo Island',
        'location': 'East Nusa Tenggara, Indonesia',
        'date': 'Aug 12-16, 2024',
        'imageUrl': 'https://images.unsplash.com/photo-1552055568-3fdaa072b9d5',
        'rating': 4.9,
        'activities': 4,
      },
    ];

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
          "Previous Trips",
          style: TextStyle(
            color: Colors.black,
            fontSize: (16 * scale).clamp(14.0, 18.0),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 20 : 30,
          vertical: isSmallScreen ? 16 : 20,
        ),
        itemCount: previousTrips.length,
        itemBuilder: (context, index) {
          final trip = previousTrips[index];
          return _buildTripCard(
            context: context,
            trip: trip,
            isSmallScreen: isSmallScreen,
            scale: scale,
          );
        },
      ),
    );
  }

  Widget _buildTripCard({
    required BuildContext context,
    required Map<String, dynamic> trip,
    required bool isSmallScreen,
    required double scale,
  }) {
    return Container(
      margin: EdgeInsets.only(
        bottom: (16 * scale).clamp(12.0, 20.0),
      ),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isSmallScreen ? 12 : 16),
              topRight: Radius.circular(isSmallScreen ? 12 : 16),
            ),
            child: Container(
              height: (180 * scale).clamp(160.0, 200.0),
              width: double.infinity,
              child: Image.network(
                trip['imageUrl'],
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
          // Content
          Padding(
            padding: EdgeInsets.all((16 * scale).clamp(12.0, 20.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip['destination'],
                            style: TextStyle(
                              fontSize: (18 * scale).clamp(16.0, 20.0),
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1B1E28),
                            ),
                          ),
                          SizedBox(height: (4 * scale).clamp(3.0, 5.0)),
                          Row(
                            children: [
                              Icon(
                                LucideIcons.mapPin,
                                size: (14 * scale).clamp(12.0, 16.0),
                                color: Color(0xFF7D848D),
                              ),
                              SizedBox(width: (4 * scale).clamp(3.0, 5.0)),
                              Expanded(
                                child: Text(
                                  trip['location'],
                                  style: TextStyle(
                                    fontSize: (13 * scale).clamp(11.0, 15.0),
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
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: (8 * scale).clamp(6.0, 10.0),
                        vertical: (4 * scale).clamp(3.0, 5.0),
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF539DF3).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
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
                    ),
                  ],
                ),
                SizedBox(height: (12 * scale).clamp(10.0, 14.0)),
                Container(
                  padding: EdgeInsets.all((12 * scale).clamp(10.0, 14.0)),
                  decoration: BoxDecoration(
                    color: Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.calendar,
                        size: (16 * scale).clamp(14.0, 18.0),
                        color: Color(0xFF539DF3),
                      ),
                      SizedBox(width: (8 * scale).clamp(6.0, 10.0)),
                      Text(
                        trip['date'],
                        style: TextStyle(
                          fontSize: (13 * scale).clamp(11.0, 15.0),
                          color: Color(0xFF1B1E28),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        LucideIcons.activity,
                        size: (16 * scale).clamp(14.0, 18.0),
                        color: Color(0xFF539DF3),
                      ),
                      SizedBox(width: (4 * scale).clamp(3.0, 5.0)),
                      Text(
                        '${trip['activities']} Activities',
                        style: TextStyle(
                          fontSize: (13 * scale).clamp(11.0, 15.0),
                          color: Color(0xFF1B1E28),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
