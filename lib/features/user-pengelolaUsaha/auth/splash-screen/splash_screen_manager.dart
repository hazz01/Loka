import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreenManager extends StatefulWidget {
  const SplashScreenManager({super.key});

  @override
  State<SplashScreenManager> createState() => _SplashScreenManagerState();
}

class _SplashScreenManagerState extends State<SplashScreenManager> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      title: 'Grow Local\nDestinations',
      description:
          'Manage your tourism place and\nhelp local destinations thrive.',
      imagePath: 'assets/image/splash_screen_pertama.jpg', // Gambar Kajoetangan
    ),
    OnboardingContent(
      title: 'Showcase with\n360° Views',
      description:
          'Let travelers explore your destination\nbefore they arrive.',
      imagePath:
          'assets/image/splash_screen_kedua.jpg', // Gambar pantai dengan 360 marker
    ),
    OnboardingContent(
      title: 'Track & Grow Your\nBusiness',
      description:
          'Analyze visitor insights and improve your\ntourism performance.',
      imagePath:
          'assets/image/splash_screen_ketiga.jpg', // Gambar analytics/dashboard
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _contents.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigasi ke manager dashboard
      context.go('/auth-manager');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // PageView untuk konten
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _contents.length,
            itemBuilder: (context, index) {
              return _buildOnboardingPage(_contents[index]);
            },
          ),

          // Bottom content (title, description, dots, button)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.0),
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.2),
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    spacing: 30,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title dan Description
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _contents[_currentPage].title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _contents[_currentPage].description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      // Page indicator dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _contents.length,
                          (index) => _buildDotIndicator(index == _currentPage),
                        ),
                      ),
                      // Next/Get Started button
                      SizedBox(
                        width: 250,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _nextPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff539DF3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            _currentPage == _contents.length - 1
                                ? 'Get Started'
                                : 'Next',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingContent content) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background image
        Image.asset(
          content.imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback jika gambar tidak ada
            return Container(
              color: Colors.grey.shade800,
              child: const Center(
                child: Icon(Icons.image, size: 100, color: Colors.white30),
              ),
            );
          },
        ),

        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.1),
                Colors.black.withOpacity(0.3),
                Colors.black.withOpacity(0.6),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDotIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xffffffff) : Color(0xffC0C0C0),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

// Model untuk konten onboarding
class OnboardingContent {
  final String title;
  final String description;
  final String imagePath;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}
