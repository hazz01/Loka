import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/data/mock_data_source.dart';

class KategoriProvinsiPage extends StatelessWidget {
  const KategoriProvinsiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provinces = MockDataSource.provinces;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Province'),
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
              'Select a Province',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Browse destinations by province to plan your trip.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: provinces.length,
                itemBuilder: (context, index) {
                  final province = provinces[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(province.imageUrl),
                      ),
                      title: Text(province.name),
                      subtitle: Text('${province.destinationCount} destinations'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to province-specific destinations
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Selected ${province.name}'),
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
