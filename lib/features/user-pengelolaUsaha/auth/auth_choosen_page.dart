import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthChoosenPageManager extends StatefulWidget {
  const AuthChoosenPageManager({super.key});

  @override
  State<AuthChoosenPageManager> createState() => _AuthChoosenPageManagerState();
}

class _AuthChoosenPageManagerState extends State<AuthChoosenPageManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // title
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Grow Your\nTourism Business',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        color: Color(0xff212121),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Image Grid - Menggunakan Expanded untuk responsive
              Expanded(
                child: Row(
                  children: [
                    // LEFT COLUMN
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: _ImageCard('assets/image/bali.jpg'),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            flex: 2,
                            child: _ImageCard('assets/image/lawang_sewu.jpg'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 10),

                    // RIGHT COLUMN
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _ImageCard('assets/image/GWK_Bali.jpg'),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            flex: 2,
                            child: _ImageCard('assets/image/bawah_laut.png'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 20,
                  children: [
                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          context.go('/auth-manager/register');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 48,
                          ),
                          backgroundColor: const Color(0xFF539DF3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    // Google Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE5E7EB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/Google.png',
                              width: 30,
                              height: 30,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Continue with Google',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff2A2A2A),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Sign In Text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff212121),
                          ),
                        ),
                        const SizedBox(width: 2),
                        GestureDetector(
                          onTap: () {
                            context.go('/auth-manager/login');
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff539DF3),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageCard extends StatelessWidget {
  final String image;

  const _ImageCard(this.image);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(image, width: double.infinity, fit: BoxFit.cover),
    );
  }
}
