import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Service untuk mengelola database lokal destination menggunakan SharedPreferences
class LocalDestinationService {
  static const String _storageKey = 'local_destinations';

  /// Menyimpan destination baru ke database lokal
  static Future<bool> addDestination(Map<String, dynamic> destination) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> destinations = await getAllDestinations();
      
      // Generate ID unik
      final String newId = 'local_dest_${DateTime.now().millisecondsSinceEpoch}';
      destination['id'] = newId;
      destination['createdAt'] = DateTime.now().toIso8601String();
      destination['status'] = destination['status'] ?? 'Draft';
      destination['views'] = 0;
      
      destinations.add(destination);
      
      final String jsonString = jsonEncode(destinations);
      await prefs.setString(_storageKey, jsonString);
      
      return true;
    } catch (e) {
      print('Error adding destination: $e');
      return false;
    }
  }

  /// Mengambil semua destinations dari database lokal
  static Future<List<Map<String, dynamic>>> getAllDestinations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_storageKey);
      
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((item) => item as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error getting destinations: $e');
      return [];
    }
  }

  /// Mengambil destination berdasarkan ID
  static Future<Map<String, dynamic>?> getDestinationById(String id) async {
    try {
      final destinations = await getAllDestinations();
      return destinations.firstWhere(
        (dest) => dest['id'] == id,
        orElse: () => {},
      );
    } catch (e) {
      print('Error getting destination by id: $e');
      return null;
    }
  }

  /// Update destination berdasarkan ID
  static Future<bool> updateDestination(String id, Map<String, dynamic> updatedData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> destinations = await getAllDestinations();
      
      final index = destinations.indexWhere((dest) => dest['id'] == id);
      if (index == -1) {
        return false;
      }
      
      updatedData['id'] = id;
      updatedData['updatedAt'] = DateTime.now().toIso8601String();
      destinations[index] = updatedData;
      
      final String jsonString = jsonEncode(destinations);
      await prefs.setString(_storageKey, jsonString);
      
      return true;
    } catch (e) {
      print('Error updating destination: $e');
      return false;
    }
  }

  /// Menghapus destination berdasarkan ID
  static Future<bool> deleteDestination(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> destinations = await getAllDestinations();
      
      destinations.removeWhere((dest) => dest['id'] == id);
      
      final String jsonString = jsonEncode(destinations);
      await prefs.setString(_storageKey, jsonString);
      
      return true;
    } catch (e) {
      print('Error deleting destination: $e');
      return false;
    }
  }

  /// Mengambil destinations berdasarkan status (Draft/Active)
  static Future<List<Map<String, dynamic>>> getDestinationsByStatus(String status) async {
    try {
      final destinations = await getAllDestinations();
      return destinations.where((dest) => dest['status'] == status).toList();
    } catch (e) {
      print('Error getting destinations by status: $e');
      return [];
    }
  }

  /// Mengubah status destination (Draft -> Active atau sebaliknya)
  static Future<bool> updateDestinationStatus(String id, String newStatus) async {
    try {
      final destination = await getDestinationById(id);
      if (destination == null) {
        return false;
      }
      
      destination['status'] = newStatus;
      destination['updatedAt'] = DateTime.now().toIso8601String();
      
      return await updateDestination(id, destination);
    } catch (e) {
      print('Error updating destination status: $e');
      return false;
    }
  }

  /// Increment views counter
  static Future<bool> incrementViews(String id) async {
    try {
      final destination = await getDestinationById(id);
      if (destination == null) {
        return false;
      }
      
      final int currentViews = destination['views'] ?? 0;
      destination['views'] = currentViews + 1;
      
      return await updateDestination(id, destination);
    } catch (e) {
      print('Error incrementing views: $e');
      return false;
    }
  }

  /// Clear all destinations (untuk testing/debug)
  static Future<bool> clearAllDestinations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
      return true;
    } catch (e) {
      print('Error clearing destinations: $e');
      return false;
    }
  }

  /// Get total count of destinations
  static Future<int> getDestinationsCount() async {
    final destinations = await getAllDestinations();
    return destinations.length;
  }

  /// Search destinations by name or location
  static Future<List<Map<String, dynamic>>> searchDestinations(String query) async {
    try {
      final destinations = await getAllDestinations();
      final lowerQuery = query.toLowerCase();
      
      return destinations.where((dest) {
        final name = (dest['name'] ?? '').toString().toLowerCase();
        final location = (dest['location'] ?? '').toString().toLowerCase();
        return name.contains(lowerQuery) || location.contains(lowerQuery);
      }).toList();
    } catch (e) {
      print('Error searching destinations: $e');
      return [];
    }
  }
}
