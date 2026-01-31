import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loka/shared/widgets/text_field_header.dart';
import 'package:loka/shared/widgets/toast_components.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class FirstRegister extends StatefulWidget {
  final VoidCallback onNext;

  const FirstRegister({super.key, required this.onNext});

  @override
  State<FirstRegister> createState() => _FirstRegisterState();
}

class _FirstRegisterState extends State<FirstRegister> {
  final _formKey = GlobalKey<FormState>();
  bool? isMan;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final locationController = TextEditingController();
  final ageController = TextEditingController();

  final Color primaryColor = const Color(0xff539DF3);
  final Color borderColor = const Color(0xffE5E7EB);
  final Color activeBg = const Color(0xFFEFF6FF);

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    locationController.dispose();
    ageController.dispose();
    super.dispose();
  }

  bool get isValid =>
      nameController.text.isNotEmpty &&
      emailController.text.isNotEmpty &&
      passwordController.text.isNotEmpty &&
      locationController.text.isNotEmpty &&
      ageController.text.isNotEmpty &&
      isMan != null;

  // ================= VALIDATORS =================

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  String? _validateLocation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Location is required';
    }
    return null;
  }

  String? _validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Age is required';
    }
    final age = int.tryParse(value);
    if (age == null || age < 1 || age > 120) {
      return 'Please enter a valid age';
    }
    return null;
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (isMan == null) {
        ToastNotification.error(context, message: 'Please select your gender');
        return;
      }
      widget.onNext();
    } else {
      // Show first error
      final nameError = _validateName(nameController.text);
      final emailError = _validateEmail(emailController.text);
      final passwordError = _validatePassword(passwordController.text);
      final locationError = _validateLocation(locationController.text);
      final ageError = _validateAge(ageController.text);

      if (nameError != null) {
        ToastNotification.error(context, message: nameError);
      } else if (emailError != null) {
        ToastNotification.error(context, message: emailError);
      } else if (passwordError != null) {
        ToastNotification.error(context, message: passwordError);
      } else if (locationError != null) {
        ToastNotification.error(context, message: locationError);
      } else if (ageError != null) {
        ToastNotification.error(context, message: ageError);
      }
    }
  }

  // =================================================

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
    final formSpacing = screenHeight > 800 ? 20.0 : 15.0;
    final bottomSpacing = screenHeight > 800 ? 40.0 : 30.0;
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
                    child: Form(
                      key: _formKey,
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
                                    "Tell Us About You",
                                    style: TextStyle(
                                      fontSize: titleFontSize,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xff212121),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Basic information to create your account.",
                                    style: TextStyle(
                                      fontSize: subtitleFontSize,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff757575),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // form
                          Column(
                            spacing: 15,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFieldWithHeader(
                                headerTitle: "Enter your name",
                                placeholder: "full name",
                                keyboardType: TextInputType.name,
                                controller: nameController,
                                validator: _validateName,
                                onChanged: (_) => setState(() {}),
                              ),
                              TextFieldWithHeader(
                                headerTitle: "Enter your email",
                                placeholder: "email",
                                keyboardType: TextInputType.emailAddress,
                                controller: emailController,
                                validator: _validateEmail,
                                onChanged: (_) => setState(() {}),
                              ),
                              TextFieldWithHeader(
                                headerTitle: "Enter your password",
                                placeholder: "password",
                                isPassword: true,
                                keyboardType: TextInputType.visiblePassword,
                                controller: passwordController,
                                validator: _validatePassword,
                                onChanged: (_) => setState(() {}),
                              ),
                              TextFieldWithHeader(
                                headerTitle: "Enter your location",
                                placeholder: "location",
                                keyboardType: TextInputType.text,
                                controller: locationController,
                                validator: _validateLocation,
                                suffixIcon: LucideIcons.mapPin,
                                onChanged: (_) => setState(() {}),
                              ),
                              TextFieldWithHeader(
                                headerTitle: "Enter your age",
                                placeholder: "age",
                                keyboardType: TextInputType.number,
                                controller: ageController,
                                validator: _validateAge,
                                onChanged: (_) => setState(() {}),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Enter your Gender",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff212121),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _genderButton("I'm a Man", true),
                                      const SizedBox(width: 12),
                                      _genderButton("I'm a Woman", false),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
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
                children: [_dot(true), _dot(false), _dot(false)],
              ),
              SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      height: buttonHeight,
                      child: ElevatedButton(
                        onPressed: () {
                          context.go('/preregister');
                        },
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
                        onPressed: isValid ? _handleSubmit : null,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: isValid
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
                            isValid ? "Continue" : "Fill out the form",
                            style: TextStyle(
                              fontSize: buttonFontSize,
                              fontWeight: FontWeight.w600,
                              color: isValid
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

  Widget _genderButton(String text, bool value) {
    final bool active = isMan == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => isMan = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: active ? activeBg : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: active ? primaryColor : borderColor,
              width: 1,
            ),
          ),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              style: TextStyle(
                fontSize: 15,
                fontWeight: active ? FontWeight.w500 : FontWeight.w400,
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
        color: active ? Color(0xff757575) : Color(0xffE5E7EB),
        shape: BoxShape.circle,
      ),
    );
  }
}
