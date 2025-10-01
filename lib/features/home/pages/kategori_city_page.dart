import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/data/mock_data_source.dart';

class KategoriCityPage extends StatelessWidget {
  const KategoriCityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cities = MockDataSource.cities;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose City'),
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
              'Select a City',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Browse all cities to find specific local attractions.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: cities.length,
                itemBuilder: (context, index) {
                  final city = cities[index];
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
                          Row(
                            children: [
                              Text('${city.destinationCount} destinations'),
                              if (city.isGreaterCity) ...[
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.orange,
                                ),
                                const Text(' Greater City'),
                              ],
                            ],
                          ),
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
