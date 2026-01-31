import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PreRegisterPage extends StatelessWidget {
  const PreRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 30),

              // Title
              const Text(
                'Where your\njourneys begin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  color: const Color(0xFF212121),
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 30),

              // Image Grid
              Expanded(
                child: Row(
                  children: [
                    // LEFT COLUMN
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            flex: 4, // 🔥 FOTO 1 lebih panjang
                            child: _ImageCard('assets/image/foto1.jpg'),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            flex: 2, // foto 3 lebih pendek
                            child: _ImageCard('assets/image/foto3.jpg'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // RIGHT COLUMN
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2, // foto 2 lebih pendek
                            child: _ImageCard('assets/image/foto2.jpg'),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            flex: 2, // 🔥 FOTO 4 lebih panjang
                            child: _ImageCard('assets/image/foto4.jpg'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/register');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF539DF3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Google Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Google Sign In
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/icons/google.png', width: 20),
                      const SizedBox(width: 12),
                      const Text(
                        'Continue with Google',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Sign In Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(fontSize: 13),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      context.go('/register');
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF539DF3),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageCard extends StatelessWidget {
  final String image;
  final double height;

  const _ImageCard(this.image, {this.height = 160});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Image.asset(
        image,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}
