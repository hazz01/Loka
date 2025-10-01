import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetailComponentPage extends StatelessWidget {
  final String destinationId;

  const DetailComponentPage({
    super.key,
    required this.destinationId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Destination Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Detail Component Page',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Destination ID: $destinationId',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            
            // Virtual Tour Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.go('/detail/$destinationId/virtual-tour'),
                icon: const Icon(Icons.threed_rotation),
                label: const Text('Start Virtual Tour'),
              ),
            ),
            const SizedBox(height: 16),
            
            // Booking Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.go('/detail/$destinationId/booking'),
                icon: const Icon(Icons.confirmation_number),
                label: const Text('Book Tickets'),
              ),
            ),
            
            const SizedBox(height: 32),
            const Text(
              'This is a placeholder for the destination detail view. '
              'Here you would show detailed information about the destination, '
              'photos, reviews, and other relevant content.',
            ),
          ],
        ),
      ),
    );
  }
}
