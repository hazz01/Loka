import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final scale = isSmallScreen ? 0.85 : (screenWidth / 375).clamp(0.85, 1.1);

    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4),
      appBar: AppBar(
        toolbarHeight: isSmallScreen ? 56 : 70,
        backgroundColor: const Color(0xFFF4F4F4),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: (16 * scale).clamp(14.0, 18.0),
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              LucideIcons.pen,
              color: Color(0xFF539DF3),
              size: (24 * scale).clamp(22.0, 26.0),
            ),
            padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          isSmallScreen ? 20 : 30,
          isSmallScreen ? 16 : 20,
          isSmallScreen ? 20 : 30,
          isSmallScreen ? 40 : 60,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: (96 * scale).clamp(80.0, 110.0),
                  height: (96 * scale).clamp(80.0, 110.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      "assets/image/profile.png",
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: Icon(
                            LucideIcons.user,
                            size: (48 * scale).clamp(40.0, 55.0),
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: (8 * scale).clamp(6.0, 10.0)),
            Column(
              children: [
                Text(
                  "Leonardo",
                  style: TextStyle(
                    color: Color(0xFF1B1E28),
                    fontSize: (24 * scale).clamp(20.0, 28.0),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: (4 * scale).clamp(3.0, 5.0)),
                Text(
                  "Leonardo@gmail.com",
                  style: TextStyle(
                    fontSize: (14 * scale).clamp(12.0, 16.0),
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF7D848D),
                  ),
                ),
              ],
            ),
            SizedBox(height: (30 * scale).clamp(24.0, 36.0)),
            Container(
              width: double.infinity,
              height: (80 * scale).clamp(70.0, 90.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Travel Trips",
                          style: TextStyle(
                            color: Color(0xFF1B1E28),
                            fontSize: (14 * scale).clamp(12.0, 16.0),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: (10 * scale).clamp(8.0, 12.0)),
                        Text(
                          "22",
                          style: TextStyle(
                            color: Color(0xFF539DF3),
                            fontSize: (16 * scale).clamp(14.0, 18.0),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: double.infinity,
                    width: isSmallScreen ? 1 : 1.5,
                    decoration: BoxDecoration(color: Color(0xFFF7F7F9)),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Favorite",
                          style: TextStyle(
                            color: Color(0xFF1B1E28),
                            fontSize: (14 * scale).clamp(12.0, 16.0),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: (10 * scale).clamp(8.0, 12.0)),
                        Text(
                          "8",
                          style: TextStyle(
                            color: Color(0xFF539DF3),
                            fontSize: (16 * scale).clamp(14.0, 18.0),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: (30 * scale).clamp(24.0, 36.0)),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(isSmallScreen ? 12 : 16),
              ),
              child: Column(
                children: [
                  _buildProfileMenuItem(
                    icon: LucideIcons.user,
                    title: "Profile",
                    onTap: () {
                      // Handle profile tap
                      print("Profile tapped");
                    },
                    isSmallScreen: isSmallScreen,
                    scale: scale,
                  ),
                  _buildProfileMenuItem(
                    icon: LucideIcons.bookmark,
                    title: "Favorite",
                    onTap: () {
                      context.go('/favorite-trips');
                    },
                    isSmallScreen: isSmallScreen,
                    scale: scale,
                  ),
                  _buildProfileMenuItem(
                    icon: LucideIcons.planeTakeoff,
                    title: "Previous Trips",
                    onTap: () {
                      context.go('/previous-trips');
                    },
                    isSmallScreen: isSmallScreen,
                    scale: scale,
                  ),
                  _buildProfileMenuItem(
                    icon: LucideIcons.creditCard,
                    title: "Transaction History",
                    onTap: () {
                      context.go('/transaction-history');
                    },
                    isSmallScreen: isSmallScreen,
                    scale: scale,
                  ),
                  _buildProfileMenuItem(
                    icon: LucideIcons.settings,
                    title: "Settings",
                    onTap: () {
                      // Handle profile tap
                      print("Settings tapped");
                    },
                    isSmallScreen: isSmallScreen,
                    scale: scale,
                  ),
                  _buildProfileMenuItem(
                    icon: LucideIcons.logOut,
                    title: "Log Out",
                    onTap: () {
                      // Handle profile tap
                      print("Log Out tapped");
                    },
                    isSmallScreen: isSmallScreen,
                    scale: scale,
                    isLast: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isSmallScreen,
    required double scale,
    bool isLast = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: (19 * scale).clamp(16.0, 22.0),
          vertical: (18 * scale).clamp(14.0, 22.0),
        ),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: Color(0xFFF7F7F9),
                    width: isSmallScreen ? 1 : 1.5,
                  ),
                ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: (24 * scale).clamp(22.0, 26.0),
                  color: Color(0xFF539DF3),
                ),
                SizedBox(width: (16 * scale).clamp(12.0, 18.0)),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: (16 * scale).clamp(14.0, 18.0),
                    color: Color(0xFF1B1E28),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            Icon(
              LucideIcons.chevronRight,
              color: Color(0xFF539DF3),
              size: (24 * scale).clamp(22.0, 26.0),
            ),
          ],
        ),
      ),
    );
  }
}
