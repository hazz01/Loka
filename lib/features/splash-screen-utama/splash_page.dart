import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnim = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.8, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    // when animation completes, wait a tiny bit then navigate to home
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (!mounted) return;
          context.go('/');
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = const Color.fromARGB(255, 255, 255, 255);
    // final brandColor = const Color(0xFF539DF3);

    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnim.value,
              child: Transform.scale(scale: _scaleAnim.value, child: child),
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo with Hero for transition to Home
              Hero(
                tag: 'app-logo',
                child: Container(
                  padding: const EdgeInsets.all(18),
                  child: Image.asset(
                    'assets/image/logo_name.png',
                    width: 222,
                    height: 103,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
