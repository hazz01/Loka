import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trip_request_model.dart';
import '../models/trip_response_model.dart';

class TripService {
  static const String baseUrl = 'http://automation.brohaz.dev/webhook';
  
  /// Create new trip plan
  /// Returns the trip plan response from the API
  static Future<TripResponse> createTrip(TripRequest request) async {
    try {
      final url = Uri.parse('$baseUrl/NewTrip');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode([request.toJson()]),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        if (jsonList.isNotEmpty) {
          return TripResponse.fromJson(jsonList[0]);
        } else {
          throw Exception('Empty response from server');
        }
      } else {
        throw Exception('Failed to create trip: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating trip: $e');
    }
  }
  
  /// Get trip plan by ID (if you need this functionality)
  static Future<TripResponse?> getTripById(String tripPlanId) async {
    try {
      // Implement if you have a GET endpoint
      // For now, returning null
      return null;
    } catch (e) {
      throw Exception('Error getting trip: $e');
    }
  }
}
