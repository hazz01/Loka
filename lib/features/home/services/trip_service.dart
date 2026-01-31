import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trip_request_model.dart';
import '../models/trip_response_model.dart';

class TripService {
  static const String baseUrl = 'https://michie-mykisah.app.n8n.cloud/webhook';
  
  /// Create new trip plan
  /// Returns the trip plan response from the API
  static Future<TripResponse> createTrip(TripRequest request) async {
    try {
      final url = Uri.parse('$baseUrl/MakingTrip');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode([request.toJson()]),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Debug: print raw response
        print('Raw API Response: ${response.body}');
        
        final responseBody = jsonDecode(response.body);
        print('Decoded response type: ${responseBody.runtimeType}');
        
        // Handle different response formats
        Map<String, dynamic> tripData;
        
        if (responseBody is List) {
          // If response is a list, take the first element
          if (responseBody.isEmpty) {
            throw Exception('Empty response from server');
          }
          
          final firstItem = responseBody[0];
          print('First item type: ${firstItem.runtimeType}');
          
          // Check if the first item has an 'output' field (new API format)
          if (firstItem is Map && firstItem.containsKey('output')) {
            final outputValue = firstItem['output'];
            print('Output field type: ${outputValue.runtimeType}');
            print('Output field value: $outputValue');
            
            if (outputValue is String) {
              String outputString = outputValue;
              // Remove markdown code blocks (```json and ```)
              outputString = outputString.replaceAll('```json', '').replaceAll('```', '').trim();
              tripData = jsonDecode(outputString);
            } else {
              throw Exception('Expected output to be String, got ${outputValue.runtimeType}');
            }
          } else if (firstItem is Map) {
            // Direct map without 'output' wrapper
            tripData = firstItem as Map<String, dynamic>;
          } else {
            throw Exception('Unexpected response format');
          }
        } else if (responseBody is Map) {
          // If response is a map, check for 'output' field
          if (responseBody.containsKey('output')) {
            final outputValue = responseBody['output'];
            print('Output field type: ${outputValue.runtimeType}');
            
            if (outputValue is String) {
              String outputString = outputValue;
              // Remove markdown code blocks (```json and ```)
              outputString = outputString.replaceAll('```json', '').replaceAll('```', '').trim();
              tripData = jsonDecode(outputString);
            } else {
              throw Exception('Expected output to be String, got ${outputValue.runtimeType}');
            }
          } else {
            tripData = responseBody as Map<String, dynamic>;
          }
        } else {
          throw Exception('Unexpected response type: ${responseBody.runtimeType}');
        }
        
        print('Final tripData: $tripData');
        
        // Convert to TripResponse
        return TripResponse.fromJson(tripData);
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
