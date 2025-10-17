import '../../../shared/data/models.dart';
import '../../../shared/data/mock_data_source.dart';

class DestinationDetailService {
  // Service untuk mengambil detail destinasi
  // Dalam implementasi real, ini akan fetch dari API
  static Future<Destination?> getDestinationDetail(String id) async {
    // Simulasi delay API
    await Future.delayed(const Duration(milliseconds: 500));

    // Ambil data dari MockDataSource
    try {
      final destination = MockDataSource.destinations.firstWhere(
        (dest) => dest.id == id,
      );
      return destination;
    } catch (e) {
      // Jika tidak ditemukan, return null
      return null;
    }
  }

  // Helper method untuk mendapatkan destinasi berdasarkan kategori
  static Future<List<Destination>> getDestinationsByCategory(
    String category,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return MockDataSource.destinations
        .where((dest) => dest.category == category)
        .toList();
  }

  // Helper method untuk mendapatkan destinasi terdekat
  static Future<List<Destination>> getNearbyDestinations({
    int limit = 5,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final destinations = List<Destination>.from(MockDataSource.destinations);
    destinations.sort((a, b) => a.distance.compareTo(b.distance));
    
    return destinations.take(limit).toList();
  }

  // Helper method untuk mendapatkan destinasi dengan virtual tour
  static Future<List<Destination>> getVirtualTourDestinations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return MockDataSource.destinations
        .where((dest) => dest.hasVirtualTour)
        .toList();
  }
}
