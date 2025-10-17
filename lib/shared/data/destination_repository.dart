import 'package:cloud_firestore/cloud_firestore.dart';
import 'models.dart';

class DestinationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'destination';

  // Get all destinations with optimized parsing
  Future<List<Destination>> getAllDestinations() async {
    try {
      print('📍 Fetching destinations from Firestore...');
      
      // TEMPORARY FIX: Limit to 10 destinations to prevent ANR
      final querySnapshot = await _firestore
          .collection(_collectionPath)
          .limit(10) // Only load 10 destinations for now
          .get()
          .timeout(const Duration(seconds: 10));
      
      final destinations = <Destination>[];
      
      // Simple parsing without batching (only 10 docs)
      for (var doc in querySnapshot.docs) {
        try {
          final destination = Destination.fromFirestore(doc.data(), doc.id);
          destinations.add(destination);
        } catch (e) {
          print('❌ Error parsing ${doc.id}: $e');
        }
      }
      
      print('✅ Loaded ${destinations.length} destinations');
      return destinations;
    } catch (e) {
      print('❌ Error getting destinations: $e');
      return [];
    }
  }

  // Get destination by ID
  Future<Destination?> getDestinationById(String id) async {
    try {
      final docSnapshot = await _firestore.collection(_collectionPath).doc(id).get();
      if (docSnapshot.exists) {
        return Destination.fromFirestore(docSnapshot.data()!, docSnapshot.id);
      }
      return null;
    } catch (e) {
      print('Error getting destination by ID: $e');
      return null;
    }
  }

  // Get destinations by category
  Future<List<Destination>> getDestinationsByCategory(String category) async {
    try {
      final allDestinations = await getAllDestinations();
      return allDestinations
          .where((dest) => dest.category == category)
          .toList();
    } catch (e) {
      print('Error getting destinations by category: $e');
      return [];
    }
  }

  // Get destinations with pagination
  Future<List<Destination>> getDestinations({
    required int page,
    int pageSize = 10,
    String? searchQuery,
    String? category,
  }) async {
    try {
      final allDestinations = await getAllDestinations();
      var filteredDestinations = allDestinations;

      // Filter by category
      if (category != null && category.isNotEmpty) {
        filteredDestinations = filteredDestinations
            .where((dest) => dest.category == category)
            .toList();
      }

      // Filter by search query
      if (searchQuery != null && searchQuery.isNotEmpty) {
        filteredDestinations = filteredDestinations
            .where(
              (dest) =>
                  dest.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                  dest.location
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()),
            )
            .toList();
      }

      final startIndex = page * pageSize;
      final endIndex = (startIndex + pageSize).clamp(
        0,
        filteredDestinations.length,
      );

      if (startIndex >= filteredDestinations.length) {
        return [];
      }

      return filteredDestinations.sublist(startIndex, endIndex);
    } catch (e) {
      print('Error getting paginated destinations: $e');
      return [];
    }
  }

  // Get nearest destinations (sorted by distance)
  Future<List<Destination>> getNearestDestinations({int limit = 10}) async {
    try {
      final destinations = await getAllDestinations();
      final sorted = List<Destination>.from(destinations);
      sorted.sort((a, b) => a.distance.compareTo(b.distance));
      return sorted.take(limit).toList();
    } catch (e) {
      print('Error getting nearest destinations: $e');
      return [];
    }
  }

  // Stream all destinations (real-time updates)
  Stream<List<Destination>> streamDestinations() {
    return _firestore.collection(_collectionPath).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Destination.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  // Stream destinations by category (real-time updates)
  Stream<List<Destination>> streamDestinationsByCategory(String category) {
    return streamDestinations().map(
      (destinations) =>
          destinations.where((dest) => dest.category == category).toList(),
    );
  }

  // Add new destination (admin function)
  Future<String?> addDestination(Destination destination) async {
    try {
      final docRef = await _firestore
          .collection(_collectionPath)
          .add(destination.toFirestore());
      return docRef.id;
    } catch (e) {
      print('Error adding destination: $e');
      return null;
    }
  }

  // Update destination (admin function)
  Future<bool> updateDestination(String id, Destination destination) async {
    try {
      await _firestore
          .collection(_collectionPath)
          .doc(id)
          .update(destination.toFirestore());
      return true;
    } catch (e) {
      print('Error updating destination: $e');
      return false;
    }
  }

  // Delete destination (admin function)
  Future<bool> deleteDestination(String id) async {
    try {
      await _firestore.collection(_collectionPath).doc(id).delete();
      return true;
    } catch (e) {
      print('Error deleting destination: $e');
      return false;
    }
  }
}
