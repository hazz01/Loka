import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VirtualTourPage extends StatelessWidget {
  final String destinationId;

  const VirtualTourPage({
    super.key,
    required this.destinationId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Virtual Tour'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/detail/$destinationId'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.threed_rotation,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 24),
            Text(
              'Virtual Tour',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Destination ID: $destinationId',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            const Text(
              'This is a placeholder for the virtual tour viewer. '
              'Here you would embed an iframe or use a WebView '
              'to display the virtual tour content from external websites.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'Virtual Tour Iframe Placeholder\n\n'
                  'In a real implementation, this would be:\n'
                  '- WebView widget\n'
                  '- Embedded 360° viewer\n'
                  '- External tour website',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
