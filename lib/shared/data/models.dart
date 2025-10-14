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
