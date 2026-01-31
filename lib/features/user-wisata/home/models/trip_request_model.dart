// Model untuk Trip Request sesuai format API

class TripRequest {
  final String userId;
  final TripType tripType;
  final List<String> targetCities;
  final int budget;
  final int peopleCount;
  final int tripDuration;
  final TripDateTime tripStart;
  final TripDateTime tripEnd;
  final List<String> categories;
  final TripPreferences preferences;

  TripRequest({
    required this.userId,
    required this.tripType,
    required this.targetCities,
    required this.budget,
    required this.peopleCount,
    required this.tripDuration,
    required this.tripStart,
    required this.tripEnd,
    required this.categories,
    required this.preferences,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'tripType': tripType.toJson(),
      'targetCities': targetCities,
      'budget': budget,
      'peopleCount': peopleCount,
      'tripDuration': tripDuration,
      'tripStart': tripStart.toJson(),
      'tripEnd': tripEnd.toJson(),
      'categories': categories,
      'preferences': preferences.toJson(),
    };
  }

  factory TripRequest.fromJson(Map<String, dynamic> json) {
    return TripRequest(
      userId: json['userId'],
      tripType: TripType.fromJson(json['tripType']),
      targetCities: List<String>.from(json['targetCities']),
      budget: json['budget'],
      peopleCount: json['peopleCount'],
      tripDuration: json['tripDuration'],
      tripStart: TripDateTime.fromJson(json['tripStart']),
      tripEnd: TripDateTime.fromJson(json['tripEnd']),
      categories: List<String>.from(json['categories']),
      preferences: TripPreferences.fromJson(json['preferences']),
    );
  }
}

class TripType {
  final String type; // "city", "greater_city", "province"
  final String name;

  TripType({
    required this.type,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'name': name,
    };
  }

  factory TripType.fromJson(Map<String, dynamic> json) {
    return TripType(
      type: json['type'],
      name: json['name'],
    );
  }
}

class TripDateTime {
  final String date; // "2025-10-20"
  final String daypart; // "morning", "noon", "evening", "night"

  TripDateTime({
    required this.date,
    required this.daypart,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'daypart': daypart,
    };
  }

  factory TripDateTime.fromJson(Map<String, dynamic> json) {
    return TripDateTime(
      date: json['date'],
      daypart: json['daypart'],
    );
  }
}

class TripPreferences {
  final String transportMode;
  final String restPreference;
  final String mealPreference;
  final String pace;

  TripPreferences({
    required this.transportMode,
    required this.restPreference,
    required this.mealPreference,
    required this.pace,
  });

  Map<String, dynamic> toJson() {
    return {
      'transportMode': transportMode,
      'restPreference': restPreference,
      'mealPreference': mealPreference,
      'pace': pace,
    };
  }

  factory TripPreferences.fromJson(Map<String, dynamic> json) {
    return TripPreferences(
      transportMode: json['transportMode'],
      restPreference: json['restPreference'],
      mealPreference: json['mealPreference'],
      pace: json['pace'],
    );
  }
}
