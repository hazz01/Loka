import 'models.dart';

// Mock data source for the Loka Virtual Tour App
class MockDataSource {
  static List<Destination> get destinations => _destinations;
  static List<TripPlan> get tripPlans => _tripPlans;
  static List<Province> get provinces => _provinces;
  static List<City> get cities => _cities;

  // Mock destinations data
  static final List<Destination> _destinations = List.generate(
    100,
    (index) => Destination(
      id: 'dest_$index',
      name: 'Destination ${index + 1}',
      description: 'Beautiful destination in Indonesia with amazing views and cultural heritage.',
      imageUrl: 'https://picsum.photos/300/200?random=$index',
      location: _getRandomLocation(index),
      province: _getRandomProvince(index),
      rating: 3.5 + (index % 20) * 0.1,
      hasVirtualTour: index % 3 == 0,
    ),
  );

  // Mock trip plans data
  static final List<TripPlan> _tripPlans = List.generate(
    50,
    (index) => TripPlan(
      id: 'plan_$index',
      title: 'Trip Plan ${index + 1}',
      description: 'Amazing ${_getRandomDuration(index)}-day trip to ${_getRandomProvince(index)}',
      destinations: _getRandomDestinations(index),
      createdAt: DateTime.now().subtract(Duration(days: index * 2)),
      duration: _getRandomDuration(index),
      province: _getRandomProvince(index),
    ),
  );

  // Mock provinces data
  static final List<Province> _provinces = [
    const Province(
      id: 'jakarta',
      name: 'DKI Jakarta',
      imageUrl: 'https://picsum.photos/300/200?random=101',
      destinationCount: 25,
    ),
    const Province(
      id: 'bali',
      name: 'Bali',
      imageUrl: 'https://picsum.photos/300/200?random=102',
      destinationCount: 35,
    ),
    const Province(
      id: 'jawa_barat',
      name: 'Jawa Barat',
      imageUrl: 'https://picsum.photos/300/200?random=103',
      destinationCount: 40,
    ),
    const Province(
      id: 'jawa_tengah',
      name: 'Jawa Tengah',
      imageUrl: 'https://picsum.photos/300/200?random=104',
      destinationCount: 30,
    ),
    const Province(
      id: 'yogyakarta',
      name: 'D.I. Yogyakarta',
      imageUrl: 'https://picsum.photos/300/200?random=105',
      destinationCount: 20,
    ),
  ];

  // Mock cities data
  static final List<City> _cities = [
    const City(
      id: 'jakarta_pusat',
      name: 'Jakarta Pusat',
      province: 'DKI Jakarta',
      imageUrl: 'https://picsum.photos/300/200?random=201',
      destinationCount: 15,
      isGreaterCity: true,
    ),
    const City(
      id: 'denpasar',
      name: 'Denpasar',
      province: 'Bali',
      imageUrl: 'https://picsum.photos/300/200?random=202',
      destinationCount: 20,
      isGreaterCity: true,
    ),
    const City(
      id: 'bandung',
      name: 'Bandung',
      province: 'Jawa Barat',
      imageUrl: 'https://picsum.photos/300/200?random=203',
      destinationCount: 25,
      isGreaterCity: true,
    ),
    const City(
      id: 'yogyakarta_city',
      name: 'Yogyakarta',
      province: 'D.I. Yogyakarta',
      imageUrl: 'https://picsum.photos/300/200?random=204',
      destinationCount: 18,
      isGreaterCity: false,
    ),
  ];

  // Helper methods
  static String _getRandomLocation(int index) {
    final locations = ['Jakarta', 'Bali', 'Bandung', 'Yogyakarta', 'Surabaya'];
    return locations[index % locations.length];
  }

  static String _getRandomProvince(int index) {
    final provinces = ['DKI Jakarta', 'Bali', 'Jawa Barat', 'Jawa Tengah', 'D.I. Yogyakarta'];
    return provinces[index % provinces.length];
  }

  static int _getRandomDuration(int index) {
    return (index % 7) + 1; // 1-7 days
  }

  static List<String> _getRandomDestinations(int index) {
    final count = (index % 5) + 2; // 2-6 destinations
    return List.generate(count, (i) => 'dest_${(index * 10 + i) % 100}');
  }

  // Pagination methods
  static Future<List<Destination>> getDestinations({
    required int page,
    int pageSize = 10,
    String? searchQuery,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    var filteredDestinations = destinations;

    if (searchQuery != null && searchQuery.isNotEmpty) {
      filteredDestinations = destinations
          .where((dest) =>
              dest.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              dest.location.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    final startIndex = page * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, filteredDestinations.length);

    if (startIndex >= filteredDestinations.length) {
      return [];
    }

    return filteredDestinations.sublist(startIndex, endIndex);
  }

  static Future<List<TripPlan>> getTripPlans({
    required int page,
    int pageSize = 10,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final startIndex = page * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, tripPlans.length);

    if (startIndex >= tripPlans.length) {
      return [];
    }

    return tripPlans.sublist(startIndex, endIndex);
  }
}
