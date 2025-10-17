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
  // New fields from Firestore
  final String? address;
  final String? activitiesDescription;
  final String? availability;
  final String? openingHours;
  final List<String>? tags;
  final int? ticketPrice;
  final String? title;

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
    this.address,
    this.activitiesDescription,
    this.availability,
    this.openingHours,
    this.tags,
    this.ticketPrice,
    this.title,
  });

  // Factory method to create Destination from Firestore document
  factory Destination.fromFirestore(Map<String, dynamic> data, String docId) {
    // Mock data untuk rating dan distance (tidak ada di Firestore)
    final mockRating = 4.0 + (docId.hashCode % 10) / 10.0; // 4.0 - 4.9
    final mockDistance = (docId.hashCode % 50).toDouble() + 1.0; // 1.0 - 50.0
    
    // Safe conversion for ticketPrice (handle both int and String)
    int? ticketPrice;
    if (data['ticketPrice'] != null) {
      if (data['ticketPrice'] is int) {
        ticketPrice = data['ticketPrice'] as int;
      } else if (data['ticketPrice'] is String) {
        ticketPrice = int.tryParse(data['ticketPrice'] as String);
      } else if (data['ticketPrice'] is double) {
        ticketPrice = (data['ticketPrice'] as double).toInt();
      }
    }
    
    return Destination(
      id: docId,
      name: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: '', // Tidak ada imageUrl di Firestore, bisa dikosongkan atau gunakan placeholder
      location: data['address'] ?? '',
      province: 'Jawa Timur', // Default province, bisa disesuaikan
      rating: mockRating,
      hasVirtualTour: false, // Default value
      category: _getCategoryFromTags(data['tags']),
      distance: mockDistance,
      address: data['address'],
      activitiesDescription: data['activitiesDescription'],
      availability: data['availability'],
      openingHours: data['openingHours'],
      tags: data['tags'] != null ? List<String>.from(data['tags']) : null,
      ticketPrice: ticketPrice,
      title: data['title'],
    );
  }

  // Helper method untuk mendapatkan category dari tags
  static String _getCategoryFromTags(dynamic tags) {
    if (tags == null) return 'Tourist Attraction';
    
    final tagsList = tags is List ? tags : [];
    
    if (tagsList.contains('culinary') || tagsList.contains('food')) {
      return 'Culinary';
    } else if (tagsList.contains('shopping') || tagsList.contains('souvenir')) {
      return 'Souvenir';
    } else if (tagsList.contains('adventure') || tagsList.contains('tour')) {
      return 'Tour & Trip';
    } else {
      return 'Tourist Attraction';
    }
  }

  // Method to convert Destination to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'title': title ?? name,
      'description': description,
      'address': address ?? location,
      'activitiesDescription': activitiesDescription,
      'availability': availability ?? 'available',
      'openingHours': openingHours,
      'tags': tags ?? [],
      'ticketPrice': ticketPrice ?? 0,
    };
  }
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
