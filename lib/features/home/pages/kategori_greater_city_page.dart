import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/data/mock_data_source.dart';

class KategoriGreaterCityPage extends StatelessWidget {
  const KategoriGreaterCityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final greaterCities = MockDataSource.cities
        .where((city) => city.isGreaterCity)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Greater City'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/trip-ai-planner'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select a Greater City',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Browse major metropolitan areas with many attractions.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: greaterCities.length,
                itemBuilder: (context, index) {
                  final city = greaterCities[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(city.imageUrl),
                      ),
                      title: Text(city.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(city.province),
                          Text('${city.destinationCount} destinations'),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to city-specific destinations
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Selected ${city.name}'),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
