import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TourismManagerDashboardPage extends StatelessWidget {
  const TourismManagerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF539DF3),
        elevation: 0,
        title: const Text(
          'Tourism Manager Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/splash'),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: const Color(0xFF539DF3).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.business_center,
                  size: 80,
                  color: Color(0xFF539DF3),
                ),
              ),

              const SizedBox(height: 32),

              // Title
              const Text(
                'Tourism Manager Dashboard',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),

              const SizedBox(height: 16),

              // Description
              const Text(
                'Halaman ini masih dalam pengembangan.\nFitur manajemen destinasi wisata akan segera hadir.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 48),

              // Placeholder features
              _buildFeatureCard(
                icon: Icons.location_on,
                title: 'Kelola Destinasi',
                description: 'Tambah, edit, dan hapus destinasi wisata',
              ),

              const SizedBox(height: 12),

              _buildFeatureCard(
                icon: Icons.analytics,
                title: 'Statistik & Analytics',
                description: 'Lihat performa destinasi wisata Anda',
              ),

              const SizedBox(height: 12),

              _buildFeatureCard(
                icon: Icons.confirmation_number,
                title: 'Manajemen Tiket',
                description: 'Kelola harga dan ketersediaan tiket',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF539DF3).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF539DF3), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
