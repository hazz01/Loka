import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookingTiketPage extends StatelessWidget {
  final String destinationId;

  const BookingTiketPage({
    super.key,
    required this.destinationId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Tickets'),
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
              Icons.confirmation_number,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 24),
            Text(
              'Booking Tiket',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Destination ID: $destinationId',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            const Text(
              'This is a placeholder for the ticket booking system. '
              'Here you would implement:\n\n'
              '• Date selection\n'
              '• Ticket quantity\n'
              '• Pricing information\n'
              '• Payment integration\n'
              '• Booking confirmation',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                children: [
                  Text(
                    'Booking Form Placeholder',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('Date: [Date Picker]'),
                  SizedBox(height: 8),
                  Text('Quantity: [Number Selector]'),
                  SizedBox(height: 8),
                  Text('Total Price: [Calculate Price]'),
                  SizedBox(height: 16),
                  Text('[Book Now Button]'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
