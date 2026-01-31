import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _birdController;
  late AnimationController _fadeSlideController;
  late Animation<double> _birdAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Animasi burung (naik turun)
    _birdController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _birdAnimation = Tween<double>(begin: 0, end: -20).animate(
      CurvedAnimation(parent: _birdController, curve: Curves.easeInOut),
    );

    // Animasi fade + slide up untuk layar masuk & keluar
    _fadeSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeSlideController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(parent: _fadeSlideController, curve: Curves.easeOut),
        );

    // Jalankan animasi masuk
    _fadeSlideController.forward();

    // Delay untuk keluar otomatis
    Future.delayed(const Duration(seconds: 5), () async {
      // Jalankan animasi keluar
      await _fadeSlideController.reverse();
      if (mounted) {
        context.go('/trip-ai-planner/timeline');
      }
    });
  }

  @override
  void dispose() {
    _birdController.dispose();
    _fadeSlideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Scaffold(
          backgroundColor: const Color(0xFF539DF3),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _birdAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _birdAnimation.value),
                      child: child,
                    );
                  },
                  child: Image.asset(
                    'assets/image/logo.png',
                    width: 120,
                    height: 120,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Hold a second",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                const Text(
                  "we generate perfect trip for you.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
