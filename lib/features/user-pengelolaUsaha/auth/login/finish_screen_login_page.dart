import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FinishScreenLoginPage extends StatefulWidget {
  const FinishScreenLoginPage({super.key});

  @override
  State<FinishScreenLoginPage> createState() => _FinishScreenLoginPageState();
}

class _FinishScreenLoginPageState extends State<FinishScreenLoginPage> {
  @override
  void initState() {
    super.initState();
    // Navigate to manager dashboard after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go('/manager');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive sizes
    final logoSize = screenWidth > 600 ? 120.0 : 100.0;
    final titleFontSize = screenWidth > 600 ? 32.0 : 28.0;
    final subtitleFontSize = screenWidth > 600 ? 16.0 : 14.0;
    final spacing = screenHeight > 800 ? 20.0 : 15.0;
    final horizontalPadding = screenWidth > 600 ? 48.0 : 24.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //logo
                Image.asset(
                  'assets/icons/AppIcon.png',
                  width: logoSize,
                  height: logoSize,
                ),
                SizedBox(height: spacing),
                Column(
                  spacing: 8,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "You’re Logged In",
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff212121),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth > 600 ? 0 : 16,
                      ),
                      child: Text(
                        "Access your dashboard and continue managing\nyour tourism business.",
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff757575),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
