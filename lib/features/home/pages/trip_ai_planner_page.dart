import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TripAIPlannerPage extends StatelessWidget {
  const TripAIPlannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip AI Planner'),
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
              child: Column(
                children: [
                  const Icon(
                    Icons.smart_toy,
                    size: 100,
                    color: Colors.purple,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Trip AI Planner',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Plan your perfect trip with AI assistance. Choose your preferred destination category:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            
            // Category buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.go('/trip-ai-planner/provinsi'),
                icon: const Icon(Icons.map),
                label: const Text('Browse by Province'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.go('/trip-ai-planner/greater-city'),
                icon: const Icon(Icons.location_city),
                label: const Text('Browse by Greater Cities'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.go('/trip-ai-planner/city'),
                icon: const Icon(Icons.business),
                label: const Text('Browse by Cities'),
              ),
            ),
            
            const SizedBox(height: 32),
            const Expanded(
              child: Center(
                child: Text(
                  'AI-powered trip planning features will be implemented here:\n\n'
                  '• Intelligent destination recommendations\n'
                  '• Customized itinerary generation\n'
                  '• Budget optimization\n'
                  '• Weather-based suggestions\n'
                  '• Local insights and tips',
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
