import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:go_router/go_router.dart';

class ManagerAccountPage extends StatelessWidget {
  const ManagerAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Account',
          style: TextStyle(
            color: Color(0xFF212121),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
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
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xff539DF3).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.user,
                      size: 40,
                      color: Color(0xff539DF3),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tourism Manager',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'manager@loka.com',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff757575),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Menu Options
            Container(
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
                children: [
                  _buildMenuItem(
                    icon: LucideIcons.user,
                    title: 'Edit Profile',
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _buildMenuItem(
                    icon: LucideIcons.building2,
                    title: 'Business Information',
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _buildMenuItem(
                    icon: LucideIcons.bell,
                    title: 'Notifications',
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _buildMenuItem(
                    icon: LucideIcons.settings,
                    title: 'Help & Support',
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  _buildMenuItem(
                    icon: LucideIcons.settings,
                    title: 'Settings',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Logout Button
            Container(
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
              child: _buildMenuItem(
                icon: LucideIcons.logOut,
                title: 'Logout',
                textColor: const Color(0xffEF4444),
                iconColor: const Color(0xffEF4444),
                onTap: () {
                  context.go('/auth-manager');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 22, color: iconColor ?? const Color(0xff757575)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? const Color(0xFF212121),
                ),
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              size: 20,
              color: iconColor ?? const Color(0xff757575),
            ),
          ],
        ),
      ),
    );
  }
}
