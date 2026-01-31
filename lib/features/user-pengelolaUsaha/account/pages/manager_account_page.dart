import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loka/shared/widgets/pop_up_components.dart';
import 'package:loka/shared/widgets/toast_components.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ManagerAccountPage extends StatelessWidget {
  const ManagerAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive values
    final horizontalPadding = screenWidth > 600 ? 48.0 : 24.0;
    final topPadding = screenHeight > 800 ? 30.0 : 20.0;
    final containerPadding = screenWidth > 600 ? 40.0 : 30.0;
    final profileImageSize = screenWidth > 600 ? 100.0 : 80.0;
    final spacingBetweenElements = screenHeight > 800 ? 25.0 : 20.0;
    final cardSpacing = screenWidth > 600 ? 12.0 : 8.0;
    final cardPadding = screenWidth > 600 ? 30.0 : 25.0;

    // Responsive font sizes
    final nameFontSize = screenWidth > 600 ? 18.0 : 16.0;
    final emailFontSize = screenWidth > 600 ? 14.0 : 12.0;
    final statNumberFontSize = screenWidth > 600 ? 20.0 : 18.0;
    final statLabelFontSize = screenWidth > 600 ? 14.0 : 12.0;
    final menuFontSize = screenWidth > 600 ? 16.0 : 14.0;

    Future<void> _handleLogout(BuildContext context) async {
      final shouldLogout = await AppPopup.showConfirmation(
        context: context,
        title: "Are you sure you want to log out?",
        message: "We'll be here whenever you're ready to come back!",
        confirmText: "Log Out",
        cancelText: "Cancel",
        confirmColor: const Color(0xffF44336),
      );

      if (shouldLogout == true && context.mounted) {
        try {
          if (context.mounted) {
            ToastNotification.success(context, message: 'Logout berhasil');
            context.go('/auth-manager');
          }
        } catch (e) {
          if (context.mounted) {
            ToastNotification.error(context, message: 'Logout gagal: $e');
          }
        }
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          children: [
            // profile header
            Column(
              spacing: cardSpacing,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, topPadding, 0, cardSpacing),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(containerPadding),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xffE5E7EB), width: 1),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: profileImageSize,
                          height: profileImageSize,
                          child: Image.asset('assets/image/foto_profile.png'),
                        ),
                        SizedBox(height: spacingBetweenElements),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Ryo Hariyono Angwyn',
                              style: TextStyle(
                                fontSize: nameFontSize,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff212121),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'ryohariyono17@gmail.com',
                              style: TextStyle(
                                fontSize: emailFontSize,
                                fontWeight: FontWeight.normal,
                                color: Color(0xff757575),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  spacing: cardSpacing,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: cardPadding,
                          horizontal: screenWidth > 600 ? 20.0 : 15.0,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xffE5E7EB),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 5,
                          children: [
                            Text(
                              "3",
                              style: TextStyle(
                                fontSize: statNumberFontSize,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff212121),
                              ),
                            ),
                            Text(
                              "Businesses",
                              style: TextStyle(
                                fontSize: statLabelFontSize,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff757575),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: cardPadding,
                          horizontal: screenWidth > 600 ? 20.0 : 15.0,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xffE5E7EB),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 5,
                          children: [
                            Text(
                              "4.5K",
                              style: TextStyle(
                                fontSize: statNumberFontSize,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff212121),
                              ),
                            ),
                            Text(
                              "Total Views",
                              style: TextStyle(
                                fontSize: statLabelFontSize,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff757575),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: cardSpacing),

            // Menu Options
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xffE5E7EB), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: LucideIcons.user,
                    title: 'Change Password',
                    onTap: () {},
                    fontSize: menuFontSize,
                  ),
                  const Divider(height: 1, color: Color(0xffE5E7EB)),
                  _buildMenuItem(
                    icon: LucideIcons.logOut,
                    iconColor: Color(0xffF44336),
                    textColor: Color(0xffF44336),
                    title: 'Logout',
                    onTap: () => _handleLogout(context),
                    fontSize: menuFontSize,
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight > 800 ? 100.0 : 80.0),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required double fontSize,
    Color? textColor,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: fontSize > 14 ? 24 : 19,
          vertical: fontSize > 14 ? 18 : 16,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: fontSize > 14 ? 22 : 20,
              color: iconColor ?? const Color(0xff539DF3),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.normal,
                  color: textColor ?? const Color(0xff212121),
                ),
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              size: fontSize > 14 ? 26 : 24,
              color: iconColor ?? const Color(0xff539DF3),
            ),
          ],
        ),
      ),
    );
  }
}
