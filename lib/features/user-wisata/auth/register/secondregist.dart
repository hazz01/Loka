import 'package:flutter/material.dart';
import 'package:loka/shared/widgets/toast_components.dart';

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
  Set<String> favoriteTypes = {};
  Set<String> transportTypes = {};

  bool get isFormValid => favoriteTypes.isNotEmpty && transportTypes.isNotEmpty;

  final Color primaryColor = const Color(0xff539DF3);
  final Color borderColor = const Color(0xffE5E7EB);
  final Color activeBg = const Color(0xffeef6fe);

  void _handleSubmit() {
    if (favoriteTypes.isEmpty) {
      ToastNotification.error(
        context,
        message: 'Please select at least one favorite travel type',
      );
      return;
    }
    if (transportTypes.isEmpty) {
      ToastNotification.error(
        context,
        message: 'Please select at least one preferred transport',
      );
      return;
    }
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive padding
    final horizontalPadding = screenWidth > 600 ? 48.0 : 24.0;
    final verticalPadding = screenHeight > 800 ? 40.0 : 24.0;

    // Responsive font sizes
    final titleFontSize = screenWidth > 600 ? 32.0 : 28.0;
    final subtitleFontSize = screenWidth > 600 ? 16.0 : 14.0;
    final buttonFontSize = screenWidth > 600 ? 18.0 : 16.0;

    // Responsive spacing
    final buttonHeight = screenHeight > 800 ? 56.0 : 50.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // title
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: verticalPadding,
                          ),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'What Do You Like?',
                                  style: TextStyle(
                                    fontSize: titleFontSize,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff212121),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Choose what you enjoy\nwhen traveling.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: subtitleFontSize,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff757575),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // content
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [_dot(false), _dot(true), _dot(false)],
              ),
              const SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      height: buttonHeight,
                      child: ElevatedButton(
                        onPressed: widget.onBack,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          side: const BorderSide(
                            color: Color(0xffE5E7EB),
                            width: 1,
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight > 800 ? 14.0 : 12.0,
                            horizontal: screenWidth > 600 ? 24.0 : 20.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          "Back",
                          style: TextStyle(
                            fontSize: buttonFontSize,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff212121),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth > 600 ? 16.0 : 10.0),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      height: buttonHeight,
                      child: ElevatedButton(
                        onPressed: isFormValid ? _handleSubmit : null,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: isFormValid
                              ? const Color(0xFF539DF3)
                              : const Color(0xffF3F4F6),
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight > 800 ? 14.0 : 12.0,
                            horizontal: screenWidth > 600 ? 24.0 : 20.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            isFormValid ? "Continue" : "Fill out the form",
                            style: TextStyle(
                              fontSize: buttonFontSize,
                              fontWeight: FontWeight.w600,
                              color: isFormValid
                                  ? Colors.white
                                  : const Color(0xff757575),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xff212121),
      ),
    );
  }

  Widget _optionBox(String text) {
    final bool isActive = favoriteTypes.contains(text);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (isActive) {
              favoriteTypes.remove(text);
            } else {
              favoriteTypes.add(text);
            }
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isActive ? activeBg : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? primaryColor : borderColor,
              width: 1,
            ),
          ),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                color: const Color(0xff212121),
              ),
              child: Text(text),
            ),
          ),
        ),
      ),
    );
  }

  Widget _transportBox(String text) {
    final bool isActive = transportTypes.contains(text);

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (isActive) {
              transportTypes.remove(text);
            } else {
              transportTypes.add(text);
            }
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isActive ? activeBg : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? primaryColor : borderColor,
              width: 1,
            ),
          ),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                color: const Color(0xff212121),
              ),
              child: Text(text),
            ),
          ),
        ),
      ),
    );
  }

  Widget _dot(bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: active ? const Color(0xff757575) : const Color(0xffE5E7EB),
        shape: BoxShape.circle,
      ),
    );
  }
}
