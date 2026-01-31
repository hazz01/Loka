// Model untuk Activity dari JSON
class Activity {
  final String activityType; // "travel" atau "visit"
  final String? destinationId;
  final String? destinationName;
  final String startTime;
  final String endTime;
  final String notes;
  final String? imagePath; // untuk UI, tidak ada di JSON
  final String? price; // untuk UI, tidak ada di JSON
  final String? address; // untuk UI, tidak ada di JSON

  Activity({
    required this.activityType,
    this.destinationId,
    this.destinationName,
    required this.startTime,
    required this.endTime,
    required this.notes,
    this.imagePath,
    this.price,
    this.address,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
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

// Model untuk Day dari JSON
class DayTrip {
  final int dayNumber;
  final List<Activity> activities;
  final DateTime? date; // untuk UI, tidak ada di JSON

  DayTrip({required this.dayNumber, required this.activities, this.date});

  factory DayTrip.fromJson(Map<String, dynamic> json) {
    return DayTrip(
      dayNumber: json['dayNumber'],
      activities: (json['activities'] as List)
          .map((activity) => Activity.fromJson(activity))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dayNumber': dayNumber,
      'activities': activities.map((a) => a.toJson()).toList(),
    };
  }

  // Helper untuk mendapatkan hanya visit activities (bukan travel)
  List<Activity> get visitActivities {
    return activities.where((a) => a.activityType == 'visit').toList();
  }

  // Backward compatibility
  int get day => dayNumber;
  List<Activity> get destinations => visitActivities;
}

// Model untuk Trip Plan dari JSON
class TripPlan {
  final String tripPlanId;
  final String userId;
  final String summary;
  final int totalEstimatedCost;
  final List<DayTrip> days;

  TripPlan({
    required this.tripPlanId,
    required this.userId,
    required this.summary,
    required this.totalEstimatedCost,
    required this.days,
  });

  factory TripPlan.fromJson(Map<String, dynamic> json) {
    return TripPlan(
      tripPlanId: json['tripPlanId'],
      userId: json['userId'],
      summary: json['summary'],
      totalEstimatedCost: json['totalEstimatedCost'],
      days: (json['days'] as List).map((day) => DayTrip.fromJson(day)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tripPlanId': tripPlanId,
      'userId': userId,
      'summary': summary,
      'totalEstimatedCost': totalEstimatedCost,
      'days': days.map((d) => d.toJson()).toList(),
    };
  }
}

// Backward compatibility - Old model
class TripDestination {
  final String name;
  final String timeRange;
  final String imagePath;
  final String description;
  final String price;
  final String? address;
  final String? duration;

  TripDestination({
    required this.name,
    required this.timeRange,
    required this.imagePath,
    required this.description,
    required this.price,
    this.address,
    this.duration,
  });

  static TripDestination fromActivity(Activity destination) {
    return TripDestination(
      name: destination.destinationName ?? 'Unknown',
      timeRange: destination.timeRange,
      imagePath: destination.imagePath ?? '',
      description: destination.notes,
      price: destination.price ?? 'Free',
      address: destination.address,
      duration: destination.duration,
    );
  }
}

// Dummy Data
class TripDummyData {
  static List<DayTrip> getMalangTrip() {
    return [
      DayTrip(
        dayNumber: 1,
        date: DateTime(2024, 10, 22),
        activities: [
          Activity(
            activityType: 'visit',
            destinationId: 'dest001',
            destinationName: 'Museum Angkut',
            startTime: '09:00',
            endTime: '09:45',
            notes:
                'Visit the transportation museum with a collection of vehicles from various eras and countries. This place...',
            imagePath: 'assets/image/museum_angkut.png',
            price: 'IDR 15.000',
          ),
          Activity(
            activityType: 'visit',
            destinationId: 'dest002',
            destinationName: 'Jatim Park 2',
            startTime: '09:45',
            endTime: '10:30',
            notes:
                'Spend time at the amusement park consisting of the Batu Secret Zoo and the Animal Museum. Suitable...',
            imagePath: 'assets/image/jatim_park.png',
            price: 'IDR 5.000',
          ),
          Activity(
            activityType: 'visit',
            destinationId: 'dest003',
            destinationName: 'Alun-Alun Batu',
            startTime: '10:30',
            endTime: '11:15',
            notes:
                'Enjoy the afternoon atmosphere in the square with various recreational and culinary facilities available.',
            imagePath: 'assets/image/alun_alun.png',
            price: 'IDR 80.000',
          ),
          Activity(
            activityType: 'visit',
            destinationId: 'dest004',
            destinationName: 'Kontena Hotel',
            startTime: '12:10',
            endTime: '12:10',
            notes:
                'Jln. KH Jl. Agus Salim No.106, Temas, Batu, Batu City, East Java 65315',
            imagePath: 'assets/image/kontena_hotel.png',
            price: 'IDR 335.072',
          ),
          Activity(
            activityType: 'visit',
            destinationId: 'dest005',
            destinationName: 'Sakdermo Omelet Batu',
            startTime: '13:00',
            endTime: '14:00',
            notes:
                'Nasi Dadar Sakdermo, a culinary shop in Batu City that sells large (jumbo) omelets served with rice and...',
            imagePath: 'assets/image/sakdermo.png',
            price: 'IDR 9.000',
          ),
          Activity(
            activityType: 'visit',
            destinationId: 'dest006',
            destinationName: 'Star Hill, Batu, Malang',
            startTime: '14:10',
            endTime: '15:00',
            notes:
                'Perched high above the city, Bukit Bintang offers a captivating night view of Batu City. The twinkling city...',
            imagePath: 'assets/image/star_hill.png',
            price: 'Free',
            address: 'Jl. Sultan Agung, Sisir, Kec. Batu, Kota Batu',
          ),
        ],
      ),
      DayTrip(
        dayNumber: 2,
        date: DateTime(2024, 10, 23),
        activities: [
          Activity(
            activityType: 'visit',
            destinationId: 'dest007',
            destinationName: 'Coban Rondo Waterfall',
            startTime: '08:00',
            endTime: '10:00',
            notes:
                'Experience the beauty of Coban Rondo waterfall with its natural atmosphere and fresh air. Perfect for morning activities.',
            imagePath: 'assets/image/coban_rondo.png',
            price: 'IDR 25.000',
          ),
          Activity(
            activityType: 'visit',
            destinationId: 'dest008',
            destinationName: 'Selecta Recreation Park',
            startTime: '10:30',
            endTime: '12:30',
            notes:
                'Enjoy swimming pool and beautiful gardens at Selecta. A historic recreational place with stunning natural views.',
            imagePath: 'assets/image/selecta.png',
            price: 'IDR 35.000',
          ),
          Activity(
            activityType: 'visit',
            destinationId: 'dest009',
            destinationName: 'Warung Apung Rahmawati',
            startTime: '13:00',
            endTime: '14:00',
            notes:
                'Floating restaurant offering fresh fish dishes with beautiful views of the dam. A unique dining experience.',
            imagePath: 'assets/image/warung_apung.png',
            price: 'IDR 50.000',
          ),
          Activity(
            activityType: 'visit',
            destinationId: 'dest010',
            destinationName: 'Batu Night Spectacular',
            startTime: '18:00',
            endTime: '21:00',
            notes:
                'Night theme park with various rides and beautiful light decorations. Perfect for family entertainment.',
            imagePath: 'assets/image/bns.png',
            price: 'IDR 75.000',
          ),
        ],
      ),
      DayTrip(
        dayNumber: 3,
        date: DateTime(2024, 10, 24),
        activities: [
          Activity(
            activityType: 'visit',
            destinationId: 'dest011',
            destinationName: 'Batu Secret Zoo Morning',
            startTime: '09:00',
            endTime: '12:00',
            notes:
                'Modern zoo with various animal collections from around the world. Interactive and educational experience.',
            imagePath: 'assets/image/secret_zoo.png',
            price: 'IDR 120.000',
          ),
          Activity(
            activityType: 'visit',
            destinationId: 'dest012',
            destinationName: 'Museum Satwa',
            startTime: '12:30',
            endTime: '14:00',
            notes:
                'Animal museum displaying various animal specimens in diorama form. Educational and interesting.',
            imagePath: 'assets/image/museum_satwa.png',
            price: 'IDR 50.000',
          ),
          Activity(
            activityType: 'visit',
            destinationId: 'dest013',
            destinationName: 'Kampung Wisata Jodipan',
            startTime: '14:30',
            endTime: '16:00',
            notes:
                'Colorful village known as Rainbow Village. Instagram-worthy spot with artistic murals.',
            imagePath: 'assets/image/jodipan.png',
            price: 'IDR 10.000',
          ),
          Activity(
            activityType: 'visit',
            destinationId: 'dest014',
            destinationName: 'Malang City Square',
            startTime: '16:30',
            endTime: '18:00',
            notes:
                'City center with historic buildings and street food. Perfect place to end your Malang trip.',
            imagePath: 'assets/image/alun_malang.png',
            price: 'Free',
          ),
        ],
      ),
    ];
  }

  // Dummy data dari JSON yang diberikan
  static TripPlan getBatuFamilyTrip() {
    return TripPlan(
      tripPlanId: 'batu-family-nature-1d-20251020',
      userId: 'user-123',
      summary:
          'Here is your optimized 1-day family and nature trip to Batu, starting on October 20, 2025, carefully planned within your 500,000 IDR budget for 3 people. This itinerary balances scenic nature exploration with fun activities, ensuring a memorable experience without overspending.',
      totalEstimatedCost: 495000,
      days: [
        DayTrip(
          dayNumber: 1,
          date: DateTime(2025, 10, 20),
          activities: [
            Activity(
              activityType: 'travel',
              startTime: '08:00',
              endTime: '08:30',
              notes:
                  'Begin your exciting family trip with a morning transfer from your accommodation to Coban Talun, a beautiful natural escape.',
            ),
            Activity(
              activityType: 'visit',
              destinationId: 'dest006',
              destinationName: 'Coban Talun',
              startTime: '08:30',
              endTime: '11:30',
              notes:
                  'Immerse in nature at Coban Talun, a popular waterfall with beautiful scenery and flower gardens, ideal for family photos and relaxation. The cool, fresh air provides a perfect start to your day.',
              imagePath: 'assets/image/coban_talun.png',
              price: 'IDR 25.000',
            ),
            Activity(
              activityType: 'travel',
              startTime: '11:30',
              endTime: '12:15',
              notes:
                  'Journey from Coban Talun to the nearby Taman Labirin Coban Rondo in Pujon. A quick, casual lunch can be enjoyed en route to keep energy levels up for the afternoon\'s adventures.',
            ),
            Activity(
              activityType: 'visit',
              destinationId: 'dest010',
              destinationName: 'Taman Labirin Coban Rondo',
              startTime: '12:15',
              endTime: '14:15',
              notes:
                  'Challenge yourselves in the unique green labyrinth, a fun and interactive experience for all ages that perfectly complements the natural beauty of the area with great photo opportunities.',
              imagePath: 'assets/image/labirin.png',
              price: 'IDR 15.000',
            ),
            Activity(
              activityType: 'travel',
              startTime: '14:15',
              endTime: '14:45',
              notes:
                  'Travel to the heart of Batu, Alun-Alun, for a relaxed and lively evening experience.',
            ),
            Activity(
              activityType: 'visit',
              destinationId: 'dest007',
              destinationName: 'Alun-Alun Batu',
              startTime: '14:45',
              endTime: '19:30',
              notes:
                  'Conclude your day at the vibrant Alun-Alun Batu. Enjoy the bustling atmosphere, ride the Ferris wheel (optional, extra cost), and savor a diverse range of local street food for dinner, offering a taste of Batu\'s culinary scene for the family.',
              imagePath: 'assets/image/alun_alun.png',
              price: 'IDR 50.000',
            ),
          ],
        ),
      ],
    );
  }
}

// Extension untuk backward compatibility dengan widget yang sudah ada
extension ActivityToDestination on Activity {
  TripDestination toDestination() {
    return TripDestination(
      name: destinationName ?? 'Unknown',
      timeRange: timeRange,
      imagePath: imagePath ?? '',
      description: notes,
      price: price ?? 'Free',
      address: address,
      duration: duration,
    );
  }
}
