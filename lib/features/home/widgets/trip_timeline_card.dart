import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../models/trip_destination_model.dart';

class TripTimelineCard extends StatelessWidget {
  final TripDestination destination;
  final bool isLast;

  const TripTimelineCard({
    super.key,
    required this.destination,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive sizes
    final timelineDotSize = screenWidth < 360 ? 12.0 : 15.0;
    final timelineLineHeight = screenWidth < 360 ? 180.0 : 200.0;
    final timeFontSize = screenWidth < 360 ? 11.0 : 12.0;
    final nameFontSize = screenWidth < 360 ? 16.0 : 18.0;
    final durationFontSize = screenWidth < 360 ? 11.0 : 12.0;
    final descriptionFontSize = screenWidth < 360 ? 11.0 : 12.0;
    final priceLabelFontSize = screenWidth < 360 ? 11.0 : 12.0;
    final priceFontSize = screenWidth < 360 ? 13.0 : 14.0;
    final addressFontSize = screenWidth < 360 ? 11.0 : 12.0;
    final imageSize = screenWidth < 360 ? 45.0 : 50.0;
    final iconSize = screenWidth < 360 ? 22.0 : 25.0;
    final mapIconSize = screenWidth < 360 ? 11.0 : 12.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: timelineDotSize,
              height: timelineDotSize,
              decoration: BoxDecoration(
                color: const Color(0xFF539DF3),
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: timelineLineHeight,
                color: const Color(0xFF539DF3).withOpacity(0.5),
              ),
          ],
        ),
        const SizedBox(width: 16),
        // Content card
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time
              Text(
                destination.timeRange,
                style: TextStyle(
                  fontSize: timeFontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              // Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFB4BCC9).withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: imageSize,
                            height: imageSize,
                            color: const Color(0xFFE5E7EB),
                            child: destination.imagePath.isNotEmpty
                                ? Image.asset(
                                    destination.imagePath,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        LucideIcons.image,
                                        color: Color(0xFF9CA3AF),
                                        size: iconSize,
                                      );
                                    },
                                  )
                                : Icon(
                                    LucideIcons.image,
                                    color: Color(0xFF9CA3AF),
                                    size: iconSize,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name
                              Text(
                                destination.name,
                                style: TextStyle(
                                  fontSize: nameFontSize,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1B1E28),
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Duration
                              if (destination.duration != null)
                                Text(
                                  destination.duration!,
                                  style: TextStyle(
                                    fontSize: durationFontSize,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF7D848D),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      destination.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: descriptionFontSize,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF8F8B8B),
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Address (if available)
                    Row(
                      children: [
                        Text(
                          'Start from ',
                          style: TextStyle(
                            fontSize: priceLabelFontSize,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF8F8B8B),
                          ),
                        ),
                        Text(
                          destination.price,
                          style: TextStyle(
                            fontSize: priceFontSize,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF539DF3),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    if (destination.address != null)
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBF5FF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LucideIcons.mapPin,
                              size: mapIconSize,
                              color: Color(0xFF539DF3),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                destination.address!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: addressFontSize,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF539DF3),
                                ),
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
        ),
      ],
    );
  }
}
