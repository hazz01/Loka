// Model untuk Trip Response dari API
// Updated to match new endpoint format with costBreakdown and activity types

class TripResponse {
  final String? tripPlanId;
  final String userId;
  final String summary;
  final num totalEstimatedCost;
  final CostBreakdown? costBreakdown;
  final List<DaySchedule> days;

  TripResponse({
    this.tripPlanId,
    required this.userId,
    required this.summary,
    required this.totalEstimatedCost,
    this.costBreakdown,
    required this.days,
  });

  factory TripResponse.fromJson(Map<String, dynamic> json) {
    try {
      // Parse totalEstimatedCost as num (can be int or double)
      num cost = 0;
      if (json['totalEstimatedCost'] != null) {
        if (json['totalEstimatedCost'] is num) {
          cost = json['totalEstimatedCost'];
        } else if (json['totalEstimatedCost'] is String) {
          cost = num.tryParse(json['totalEstimatedCost']) ?? 0;
        }
      }

      // Parse costBreakdown
      CostBreakdown? breakdown;
      if (json['costBreakdown'] != null && json['costBreakdown'] is Map) {
        breakdown = CostBreakdown.fromJson(json['costBreakdown'] as Map<String, dynamic>);
      }

      // Parse days array
      List<DaySchedule> daysList = [];
      if (json['days'] != null && json['days'] is List) {
        daysList = (json['days'] as List)
            .map((day) => DaySchedule.fromJson(day))
            .toList();
      }

      return TripResponse(
        tripPlanId: json['tripPlanId'] as String?,
        userId: json['userId'] as String? ?? '',
        summary: json['summary'] as String? ?? '',
        totalEstimatedCost: cost,
        costBreakdown: breakdown,
        days: daysList,
      );
    } catch (e) {
      print('Error parsing TripResponse: $e');
      // Return a minimal valid object on error
      return TripResponse(
        userId: '',
        summary: 'Error parsing response',
        totalEstimatedCost: 0,
        days: [],
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      if (tripPlanId != null) 'tripPlanId': tripPlanId,
      'userId': userId,
      'summary': summary,
      'totalEstimatedCost': totalEstimatedCost,
      if (costBreakdown != null) 'costBreakdown': costBreakdown!.toJson(),
      'days': days.map((d) => d.toJson()).toList(),
    };
  }

  // Backward compatibility getters
  String get tripName => 'AI Generated Trip';
  String get city => 'Various Locations';
  int get totalBudget => totalEstimatedCost.toInt();
  int get peopleCount => 1;
  int get tripDurationDays => days.length;
  String get primaryCategory => 'AI Generated';
  String get preferences => '';
  
  // For timeline page compatibility
  List<DayItinerary> get dailyItinerary {
    return days.map((day) {
      return DayItinerary(
        day: day.dayNumber,
        theme: 'Day ${day.dayNumber}',
        budgetForDay: 0,
        destinations: day.activities.map((activity) {
          return Destination(
            id: activity.destinationId ?? activity.mealId ?? '',
            title: activity.name ?? 'Activity',
            description: activity.notes,
            address: activity.locationNote ?? '',
            ticketPricePerPerson: activity.estimatedCost?.toInt() ?? 0,
            openingHours: '${activity.startTime} - ${activity.endTime}',
            estimatedCostForGroup: activity.estimatedCost?.toInt() ?? 0,
            notes: activity.notes,
          );
        }).toList(),
      );
    }).toList();
  }

  BudgetSummary get budgetSummary {
    return BudgetSummary(
      totalEstimatedAttractionCost: costBreakdown?.destinations?.toInt() ?? totalEstimatedCost.toInt(),
      remainingBudget: 0,
      notes: '',
    );
  }

  // Original request for compatibility
  Map<String, dynamic> get originalRequest => {
    'tripType': {'name': city},
    'targetCities': [city],
    'budget': totalBudget,
    'peopleCount': peopleCount,
  };
}

// Cost Breakdown Model
class CostBreakdown {
  final num? destinations;
  final num? meals;
  final num? travel;

  CostBreakdown({
    this.destinations,
    this.meals,
    this.travel,
  });

  factory CostBreakdown.fromJson(Map<String, dynamic> json) {
    num? parseNum(dynamic value) {
      if (value == null) return null;
      if (value is num) return value;
      if (value is String) return num.tryParse(value);
      return null;
    }

    return CostBreakdown(
      destinations: parseNum(json['destinations']),
      meals: parseNum(json['meals']),
      travel: parseNum(json['travel']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (destinations != null) 'destinations': destinations,
      if (meals != null) 'meals': meals,
      if (travel != null) 'travel': travel,
    };
  }
}

class BudgetSummary {
  final int totalEstimatedAttractionCost;
  final int remainingBudget;
  final String notes;

  BudgetSummary({
    required this.totalEstimatedAttractionCost,
    required this.remainingBudget,
    required this.notes,
  });

  factory BudgetSummary.fromJson(Map<String, dynamic> json) {
    // Helper function to parse int from either int or String
    int parseInt(dynamic value, [int defaultValue = 0]) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is String) {
        // Remove currency symbols, commas, and spaces
        final cleaned = value.replaceAll(RegExp(r'[^\d]'), '');
        return int.tryParse(cleaned) ?? defaultValue;
      }
      return defaultValue;
    }
    
    // Handle both snake_case and camelCase field names
    final attractionCost = parseInt(
      json['total_estimated_attraction_cost'] ?? 
      json['totalSpentOnTickets'] ?? 
      json['totalEstimatedAttractionCost'] ??
      json['totalEstimatedTicketCostForTrip']
    );
    
    final remaining = parseInt(
      json['remaining_budget'] ?? 
      json['remainingBudget']
    );
    
    // Handle notes - could be a string or nested object
    String notes = '';
    final notesValue = json['notes'];
    if (notesValue is String) {
      notes = notesValue;
    } else if (notesValue != null) {
      // If it's an object, try to stringify it
      notes = notesValue.toString();
    }
    
    // Also check for budgetStatus field
    final statusValue = json['budgetStatus'];
    if (statusValue is String && notes.isEmpty) {
      notes = statusValue;
    }
    
    return BudgetSummary(
      totalEstimatedAttractionCost: attractionCost,
      remainingBudget: remaining,
      notes: notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_estimated_attraction_cost': totalEstimatedAttractionCost,
      'remaining_budget': remainingBudget,
      'notes': notes,
    };
  }
}

class DayItinerary {
  final int day;
  final String theme;
  final int budgetForDay;
  final List<Destination> destinations;

  DayItinerary({
    required this.day,
    required this.theme,
    required this.budgetForDay,
    required this.destinations,
  });

  factory DayItinerary.fromJson(Map<String, dynamic> json) {
    // Helper function to parse int from either int or String
    int parseInt(dynamic value, [int defaultValue = 0]) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is String) {
        // Remove currency symbols, commas, and spaces
        final cleaned = value.replaceAll(RegExp(r'[^\d]'), '');
        return int.tryParse(cleaned) ?? defaultValue;
      }
      return defaultValue;
    }
    
    // Handle both 'destinations' and 'activities' field names
    final destinationsData = json['destinations'] ?? json['activities'] ?? [];
    
    return DayItinerary(
      day: parseInt(json['day'], 1),
      theme: json['theme'] ?? '',
      budgetForDay: parseInt(json['budget_for_day'] ?? json['budgetForDay'] ?? json['totalDailyTicketCost']),
      destinations: (destinationsData as List)
          .map((dest) => Destination.fromJson(dest))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'theme': theme,
      'budget_for_day': budgetForDay,
      'destinations': destinations.map((d) => d.toJson()).toList(),
    };
  }
}

class Destination {
  final String id;
  final String title;
  final String description;
  final String address;
  final int ticketPricePerPerson;
  final String? openingHours;
  final int estimatedCostForGroup;
  final String? notes;

  Destination({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.ticketPricePerPerson,
    this.openingHours,
    required this.estimatedCostForGroup,
    this.notes,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    // Helper function to parse int from either int or String
    int parseInt(dynamic value, [int defaultValue = 0]) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is String) {
        // Remove currency symbols, commas, and spaces
        final cleaned = value.replaceAll(RegExp(r'[^\d]'), '');
        return int.tryParse(cleaned) ?? defaultValue;
      }
      return defaultValue;
    }
    
    // Handle both snake_case and camelCase field names
    final id = json['id'] ?? json['destinationId'] ?? '';
    final ticketPrice = parseInt(
      json['ticket_price_per_person'] ?? 
      json['ticketPrice'] ?? 
      json['ticketPricePerPerson'] ??
      json['estimatedCostPerPerson']
    );
    
    final openingHours = json['opening_hours'] ?? json['openingHours'];
    final estimatedCost = parseInt(
      json['estimated_cost_for_group'] ?? 
      json['estimatedCostForGroup'] ?? 
      ticketPrice
    ); // Fallback to ticket price if no group cost
    
    return Destination(
      id: id,
      title: json['title'] ?? 'Unknown',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      ticketPricePerPerson: ticketPrice,
      openingHours: openingHours,
      estimatedCostForGroup: estimatedCost,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'address': address,
      'ticket_price_per_person': ticketPricePerPerson,
      'opening_hours': openingHours,
      'estimated_cost_for_group': estimatedCostForGroup,
      'notes': notes,
    };
  }
}

// Legacy classes for backward compatibility

class DaySchedule {
  final int dayNumber;
  final List<ActivitySchedule> activities;

  DaySchedule({
    required this.dayNumber,
    required this.activities,
  });

  factory DaySchedule.fromJson(Map<String, dynamic> json) {
    try {
      int dayNum = 1;
      if (json['dayNumber'] != null) {
        if (json['dayNumber'] is int) {
          dayNum = json['dayNumber'];
        } else if (json['dayNumber'] is String) {
          dayNum = int.tryParse(json['dayNumber']) ?? 1;
        }
      }

      List<ActivitySchedule> activitiesList = [];
      if (json['activities'] != null && json['activities'] is List) {
        activitiesList = (json['activities'] as List)
            .map((activity) => ActivitySchedule.fromJson(activity))
            .toList();
      }

      return DaySchedule(
        dayNumber: dayNum,
        activities: activitiesList,
      );
    } catch (e) {
      print('Error parsing DaySchedule: $e');
      return DaySchedule(
        dayNumber: 1,
        activities: [],
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'dayNumber': dayNumber,
      'activities': activities.map((a) => a.toJson()).toList(),
    };
  }
}

class ActivitySchedule {
  final String activityType; // "visit" | "meal" | "travel"
  final String? destinationId; // "dest[uid]" or null
  final String? mealId; // "meal[uid]" or null
  final String? name;
  final String startTime;
  final String endTime;
  final num? estimatedCost;
  final String? locationNote;
  final String notes;
  final String? destinationName; // For backward compatibility

  ActivitySchedule({
    this.activityType = 'visit',
    this.destinationId,
    this.mealId,
    this.name,
    required this.startTime,
    required this.endTime,
    this.estimatedCost,
    this.locationNote,
    required this.notes,
    this.destinationName,
  });

  factory ActivitySchedule.fromJson(Map<String, dynamic> json) {
    try {
      // Helper to parse num
      num? parseNum(dynamic value) {
        if (value == null) return null;
        if (value is num) return value;
        if (value is String) return num.tryParse(value);
        return null;
      }

      return ActivitySchedule(
        activityType: json['activityType'] as String? ?? 'visit',
        destinationId: json['destinationId'] as String?,
        mealId: json['mealId'] as String?,
        name: json['name'] as String?,
        startTime: json['startTime'] as String? ?? '09:00',
        endTime: json['endTime'] as String? ?? '17:00',
        estimatedCost: parseNum(json['estimatedCost']),
        locationNote: json['locationNote'] as String?,
        notes: json['notes'] as String? ?? '',
        destinationName: json['destinationName'] as String?,
      );
    } catch (e) {
      print('Error parsing ActivitySchedule: $e');
      return ActivitySchedule(
        activityType: 'visit',
        startTime: '09:00',
        endTime: '17:00',
        notes: '',
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'activityType': activityType,
      if (destinationId != null) 'destinationId': destinationId,
      if (mealId != null) 'mealId': mealId,
      if (name != null) 'name': name,
      'startTime': startTime,
      'endTime': endTime,
      if (estimatedCost != null) 'estimatedCost': estimatedCost,
      if (locationNote != null) 'locationNote': locationNote,
      'notes': notes,
      if (destinationName != null) 'destinationName': destinationName,
    };
  }

  // Helper untuk mendapatkan time range
  String get timeRange => '$startTime - $endTime';

  // Helper untuk mendapatkan duration
  String? get duration {
    try {
      final start = _parseTime(startTime);
      final end = _parseTime(endTime);
      final diff = end.difference(start);
      final hours = diff.inHours;
      final minutes = diff.inMinutes % 60;
      if (hours > 0 && minutes > 0) {
        return '$hours hours $minutes minutes';
      } else if (hours > 0) {
        return '$hours hours';
      } else {
        return '$minutes minutes';
      }
    } catch (e) {
      return null;
    }
  }

  DateTime _parseTime(String time) {
    final parts = time.split(':');
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }
}
