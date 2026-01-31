import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ManagerTicketsPage extends StatelessWidget {
  const ManagerTicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Ticket Management',
          style: TextStyle(
            color: Color(0xFF212121),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.settings, color: Color(0xff539DF3)),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 6,
        itemBuilder: (context, index) {
          return _buildTicketCard(
            destinationName: 'Destination ${index + 1}',
            ticketType: index % 2 == 0 ? 'Regular' : 'VIP',
            price: index % 2 == 0 ? 'Rp 50.000' : 'Rp 100.000',
            soldCount: '${(index + 1) * 87}',
            available: index % 3 != 0,
          );
        },
      ),
    );
  }

  Widget _buildTicketCard({
    required String destinationName,
    required String ticketType,
    required String price,
    required String soldCount,
    required bool available,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destinationName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$ticketType Ticket',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff757575),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: available
                      ? const Color(0xff10B981).withOpacity(0.1)
                      : const Color(0xffEF4444).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  available ? 'Available' : 'Sold Out',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: available
                        ? const Color(0xff10B981)
                        : const Color(0xffEF4444),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    LucideIcons.tag,
                    size: 16,
                    color: Color(0xff539DF3),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff539DF3),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    LucideIcons.shoppingBag,
                    size: 16,
                    color: Color(0xff757575),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$soldCount sold',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff757575),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
