import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PlaceHolderAiPage extends StatefulWidget {
  const PlaceHolderAiPage({super.key});

  @override
  State<PlaceHolderAiPage> createState() => _PlaceHolderAiPageState();
}

class _PlaceHolderAiPageState extends State<PlaceHolderAiPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isSmall = w < 600;
    final isMedium = w >= 600 && w < 1024;

    // Responsive sizes (keep same content, only scale visuals)
    final horizontalPad = isSmall ? 20.0 : (isMedium ? 28.0 : 40.0);
    final iconPadding = isSmall ? 18.0 : (isMedium ? 22.0 : 28.0);
    final iconSize = isSmall ? 50.0 : (isMedium ? 60.0 : 72.0);
    final borderWidth = isSmall ? 1.6 : 2.0;
    final spacer1 = isSmall ? 12.0 : 16.0;
    final spacer2 = isSmall ? 6.0 : 8.0;
    final titleSize = isSmall ? 18.0 : 20.0;
    final bodySize = isSmall ? 13.0 : 14.0;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPad),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(iconPadding),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF3B82F6).withOpacity(0.3),
                        width: borderWidth,
                      ),
                    ),
                    child: Icon(
                      LucideIcons.planeTakeoff,
                      size: iconSize,
                      color: const Color(0xFF60A5FA).withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: spacer1),
                  Text(
                    "AI Feature Coming Soon!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: spacer2),
                  Text(
                    "Stay tuned for updates!\nFor now you can try this feature in Greater City section",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54, fontSize: bodySize),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
