import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FirstRegister extends StatefulWidget {
  final VoidCallback onNext;

  const FirstRegister({super.key, required this.onNext});

  @override
  State<FirstRegister> createState() => _FirstRegisterState();
}

class _FirstRegisterState extends State<FirstRegister> {
  bool? isMan;
  bool obscure = true;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final locationController = TextEditingController();
  final ageController = TextEditingController();

  final Color primaryColor = const Color(0xFF539DF3);
  final Color borderColor = const Color(0xFFE5E7EB);
  final Color activeBg = const Color(0xFFEFF6FF);

  bool get isValid =>
      nameController.text.isNotEmpty &&
      emailController.text.isNotEmpty &&
      passwordController.text.isNotEmpty &&
      locationController.text.isNotEmpty &&
      ageController.text.isNotEmpty &&
      isMan != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // TITLE
              const Center(
                child: Column(
                  children: [
                    Text(
                      "Tell Us About You",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Basic information to create your account.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              _label("Enter your name"),
              _input(nameController),

              _label("Enter your email"),
              _input(emailController),

              _label("Enter your password"),
              _input(
                passwordController,
                obscure: obscure,
                suffix: IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () => setState(() => obscure = !obscure),
                ),
              ),

              _label("Enter your location"),
              _input(
                locationController,
                suffix: const Icon(Icons.location_on_outlined),
              ),

              _label("Enter your age"),
              _input(
                ageController,
                keyboardType: TextInputType.number,
                suffix: const Icon(Icons.keyboard_arrow_down),
              ),

              const SizedBox(height: 20),

              // GENDER
              const Text(
                "Enter your Gender",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  _genderButton("I'm a Man", true),
                  const SizedBox(width: 12),
                  _genderButton("I'm a Woman", false),
                ],
              ),

              // PUSH CONTENT UP (BIAR DOT & BUTTON KE BAWAH)
              const Spacer(),

              // DOT
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [_dot(true), _dot(false), _dot(false)],
              ),

              const SizedBox(height: 26),

              // BUTTON
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>context.go('/preregister'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        side: BorderSide(color: borderColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: isValid ? widget.onNext : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        backgroundColor: isValid ? primaryColor : borderColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isValid ? Colors.white : Colors.black38,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 26),
            ],
          ),
        ),
      ),
    );
  }

  // COMPONENTS

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _input(
    TextEditingController controller, {
    bool obscure = false,
    Widget? suffix,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          suffixIcon: suffix,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _genderButton(String text, bool value) {
    final bool active = isMan == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isMan = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: active ? activeBg : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: active ? primaryColor : borderColor,
              width: 1.4,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: active ? primaryColor : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dot(bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? primaryColor : borderColor,
        shape: BoxShape.circle,
      ),
    );
  }
}
