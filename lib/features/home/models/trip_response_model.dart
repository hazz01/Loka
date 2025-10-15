// Model untuk Trip Response dari API

class TripResponse {
  final String tripPlanId;
  final String userId;
  final String summary;
  final int totalEstimatedCost;
  final List<DaySchedule> days;
  final Map<String, dynamic> originalRequest;
  final String process;
  final String updatedAt;
  final String generatedAt;

  TripResponse({
    required this.tripPlanId,
    required this.userId,
    required this.summary,
    required this.totalEstimatedCost,
    required this.days,
    required this.originalRequest,
    required this.process,
    required this.updatedAt,
    required this.generatedAt,
  });

  factory TripResponse.fromJson(Map<String, dynamic> json) {
    return TripResponse(
      tripPlanId: json['tripPlanId'],
      userId: json['userId'],
      summary: json['summary'],
      totalEstimatedCost: json['totalEstimatedCost'],
      days: (json['days'] as List)
          .map((day) => DaySchedule.fromJson(day))
          .toList(),
      originalRequest: json['originalRequest'] ?? {},
      process: json['process'],
      updatedAt: json['updatedAt'],
      generatedAt: json['generatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tripPlanId': tripPlanId,
      'userId': userId,
      'summary': summary,
      'totalEstimatedCost': totalEstimatedCost,
      'days': days.map((d) => d.toJson()).toList(),
      'originalRequest': originalRequest,
      'process': process,
      'updatedAt': updatedAt,
      'generatedAt': generatedAt,
    };
  }
}

class DaySchedule {
  final int dayNumber;
  final List<ActivitySchedule> activities;

  DaySchedule({
    required this.dayNumber,
    required this.activities,
  });

  factory DaySchedule.fromJson(Map<String, dynamic> json) {
    return DaySchedule(
      dayNumber: json['dayNumber'],
      activities: (json['activities'] as List)
          .map((activity) => ActivitySchedule.fromJson(activity))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dayNumber': dayNumber,
      'activities': activities.map((a) => a.toJson()).toList(),
    };
  }
}

class ActivitySchedule {
  final String activityType; // "travel" or "visit"
  final String? destinationId;
  final String? destinationName;
  final String startTime;
  final String endTime;
  final String notes;

  ActivitySchedule({
    required this.activityType,
    this.destinationId,
    this.destinationName,
    required this.startTime,
    required this.endTime,
    required this.notes,
  });

  factory ActivitySchedule.fromJson(Map<String, dynamic> json) {
    return ActivitySchedule(
      activityType: json['activityType'],
      destinationId: json['destinationId'],
      destinationName: json['destinationName'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activityType': activityType,
      'destinationId': destinationId,
      'destinationName': destinationName,
      'startTime': startTime,
      'endTime': endTime,
      'notes': notes,
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
