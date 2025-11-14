import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/trip_request_model.dart';
import '../models/trip_response_model.dart';

class TripService {
  // Base URL untuk mobile (HTTP)
  static const String mobileBaseUrl = 'http://automation.brohaz.dev/webhook';
  // Base URL untuk web (HTTPS)
  static const String webBaseUrl = 'https://automation.brohaz.dev/webhook';
  
  /// Create new trip plan
  /// Returns the trip plan response from the API
  static Future<TripResponse> createTrip(TripRequest request) async {
    // Untuk web, coba HTTPS dulu, jika gagal coba HTTP
    if (kIsWeb) {
      return _createTripForWeb(request);
    } else {
      return _createTripForMobile(request);
    }
  }
  
  /// Create trip untuk platform mobile (Android/iOS)
  static Future<TripResponse> _createTripForMobile(TripRequest request) async {
    final url = Uri.parse('$mobileBaseUrl/NewTrip');
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode([request.toJson()]),
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw Exception('Request timeout. Please check your internet connection.');
        },
      );

      return _processResponse(response);
    } catch (e) {
      throw Exception('Error creating trip: $e');
    }
  }
  
  /// Create trip untuk platform web
  static Future<TripResponse> _createTripForWeb(TripRequest request) async {
    // Coba HTTPS dulu
    try {
      final httpsUrl = Uri.parse('$webBaseUrl/NewTrip');
      final response = await http.post(
        httpsUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode([request.toJson()]),
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );
      
      return _processResponse(response);
    } catch (e) {
      // Jika HTTPS gagal, coba HTTP
      try {
        final httpUrl = Uri.parse('$mobileBaseUrl/NewTrip');
        final response = await http.post(
          httpUrl,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode([request.toJson()]),
        ).timeout(
          const Duration(seconds: 60),
          onTimeout: () {
            throw Exception('Request timeout');
          },
        );
        
        return _processResponse(response);
      } catch (httpError) {
        // Jika kedua-duanya gagal, throw error yang informatif
        throw Exception(
          'Unable to connect to the server. '
          'This might be due to CORS restrictions on web browsers. '
          'Please note: The API works on mobile apps but may have limitations on web browsers. '
          'Original error: $e'
        );
      }
    }
  }
  
  /// Process HTTP response
  static TripResponse _processResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      if (jsonList.isNotEmpty) {
        return TripResponse.fromJson(jsonList[0]);
      } else {
        throw Exception('Empty response from server');
      }
    } else {
      throw Exception(
        'Server returned error code ${response.statusCode}. '
        'Response: ${response.body}'
      );
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
