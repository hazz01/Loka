// Shared data models for the Loka Virtual Tour App

class Destination {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String location;
  final String province;
  final double rating;
  final bool hasVirtualTour;
  final String category; // Tourist Attraction, Culinary, Souvenir, Tour & Trip
  final double distance; // in km
  
  // Additional fields for detail page
  final String? address;
  final String? openingHours;
  final double? latitude;
  final double? longitude;
  final List<TicketPrice>? ticketPrices;
  final List<TourOption>? tourOptions;
  final List<String>? activities;
  final String? virtualTourUrl; // URL untuk virtual tour

  const Destination({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.province,
    required this.rating,
    required this.hasVirtualTour,
    required this.category,
    this.distance = 0.0,
    // Optional detail fields
    this.address,
    this.openingHours,
    this.latitude,
    this.longitude,
    this.ticketPrices,
    this.tourOptions,
    this.activities,
    this.virtualTourUrl,
  });
}

class TicketPrice {
  final String type; // "Weekday" or "Weekend"
  final int price;
  final bool isAvailable;

  const TicketPrice({
    required this.type,
    required this.price,
    this.isAvailable = true,
  });
}

class TourOption {
  final String id;
  final String name;
  final String description;
  final int price;
  final int destinationCount;

  const TourOption({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.destinationCount,
  });
}

class TripPlan {
  final String id;
  final String title;
  final String description;
  final List<String> destinations;
  final DateTime createdAt;
  final int duration; // in days
  final String province;

  const TripPlan({
    required this.id,
    required this.title,
    required this.description,
    required this.destinations,
    required this.createdAt,
    required this.duration,
    required this.province,
  });
}

class Province {
  final String id;
  final String name;
  final String imageUrl;
  final int destinationCount;

  const Province({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.destinationCount,
  });
}

class City {
  final String id;
  final String name;
  final String province;
  final String imageUrl;
  final int destinationCount;
  final bool isGreaterCity;

  const City({
    required this.id,
    required this.name,
    required this.province,
    required this.imageUrl,
    required this.destinationCount,
    required this.isGreaterCity,
  });
}
