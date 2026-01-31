import 'package:flutter/material.dart';

class SecondRegisterPage extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onNext;

  const SecondRegisterPage({
    super.key,
    required this.onBack,
    required this.onNext,
  });

  @override
  State<SecondRegisterPage> createState() => _SecondRegisterPageState();
}

class _SecondRegisterPageState extends State<SecondRegisterPage> {
  String? favoriteType;
  String? transportType;

  bool get isFormValid => favoriteType != null && transportType != null;

  final Color primaryColor = const Color(0xFF539DF3);
  final Color borderColor = const Color(0xFFE5E7EB);
  final Color activeBg = const Color(0xFFEFF6FF);

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
                      'What Do You Like?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Choose what you enjoy\nwhen traveling.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              _sectionTitle('Favorite travel type'),
              const SizedBox(height: 14),

              Row(
                children: [
                  _optionBox('City'),
                  const SizedBox(width: 12),
                  _optionBox('Culinary'),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _optionBox('Souvenir'),
                  const SizedBox(width: 12),
                  _optionBox('Natural'),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _optionBox('Art & Culture'),
                  const SizedBox(width: 12),
                  _optionBox('History'),
                ],
              ),

              const SizedBox(height: 26),

              _sectionTitle('Preferred transport'),
              const SizedBox(height: 14),

              Row(
                children: [
                  _transportBox('Car'),
                  const SizedBox(width: 12),
                  _transportBox('Train'),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _transportBox('Plane'),
                  const SizedBox(width: 12),
                  _transportBox('Bus'),
                ],
              ),

              const Spacer(),

              // DOT
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _dot(false),
                  _dot(true),
                  _dot(false),
                ],
              ),

              const SizedBox(height: 26),

              // BUTTON
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onBack,
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
                      onPressed: isFormValid ? widget.onNext : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        backgroundColor:
                            isFormValid ? primaryColor : borderColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color:
                              isFormValid ? Colors.white : Colors.black38,
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

  // COMPONENT

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _optionBox(String text) {
    final bool isActive = favoriteType == text;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => favoriteType = text),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: isActive ? activeBg : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive ? primaryColor : borderColor,
              width: 1.4,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _transportBox(String text) {
    final bool isActive = transportType == text;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => transportType = text),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: isActive ? activeBg : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive ? primaryColor : borderColor,
              width: 1.4,
            ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
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
