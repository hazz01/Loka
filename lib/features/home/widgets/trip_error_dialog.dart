import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TripErrorDialog {
  static void show(BuildContext context, String error) {
    // Check if error is CORS related
    final isCorsError = error.toLowerCase().contains('cors') ||
        error.toLowerCase().contains('cross-origin') ||
        error.toLowerCase().contains('failed to fetch') ||
        error.toLowerCase().contains('network error on web');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          children: [
            Icon(
              isCorsError ? Icons.public_off : Icons.error_outline,
              color: Colors.orange,
            ),
            const SizedBox(width: 10),
            Text(isCorsError ? 'Platform Limitation' : 'Error'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (kIsWeb && isCorsError) ...[
                const Text(
                  'Web Browser Limitation',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const Text(
                  'The AI Trip Planner feature works perfectly on Android and iOS apps, '
                  'but has limitations on web browsers due to security policies (CORS).',
                ),
                const SizedBox(height: 15),
                const Text(
                  'Solutions:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                const Text(
                  '1. Use the Android or iOS mobile app for full functionality\n'
                  '2. View a sample trip plan below\n'
                  '3. For developers: See WEB_CORS_SOLUTION.md',
                  style: TextStyle(fontSize: 13),
                ),
              ] else ...[
                const Text('Failed to create trip plan.'),
                const SizedBox(height: 10),
                Text(
                  'Error: ${error.length > 200 ? error.substring(0, 200) + "..." : error}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Please check your internet connection and try again.',
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to timeline with dummy data as fallback
              context.go('/trip-ai-planner/timeline');
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue.withOpacity(0.1),
            ),
            child: const Text(
              'View Sample Trip',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
