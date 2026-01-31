import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loka/shared/widgets/text_field_header.dart';
import 'package:loka/shared/widgets/toast_components.dart';

class LoginPageManager extends StatefulWidget {
  const LoginPageManager({super.key});

  @override
  State<LoginPageManager> createState() => _LoginPageManagerState();
}

class _LoginPageManagerState extends State<LoginPageManager> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
    return null;
  }

  bool _isFormValid() {
    return _emailController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      ToastNotification.success(context, message: 'Login successful!');
      context.go('/auth-manager/login/success-login');
    } else {
      // Show first error
      final emailError = _validateEmail(_emailController.text);
      final passwordError = _validatePassword(_passwordController.text);

      if (emailError != null) {
        ToastNotification.error(context, message: emailError);
      } else if (passwordError != null) {
        ToastNotification.error(context, message: passwordError);
      }
    }
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
    final formSpacing = screenHeight > 800 ? 20.0 : 15.0;
    final bottomSpacing = screenHeight > 800 ? 120.0 : 80.0;
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
                                    "Good to See\nYou Again",
                                    style: TextStyle(
                                      fontSize: titleFontSize,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xff212121),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Let’s continue managing your\ndestinations together.",
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
                            spacing: formSpacing,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFieldWithHeader(
                                headerTitle: "Enter your email",
                                placeholder: "email",
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailController,
                                validator: _validateEmail,
                                onChanged: (_) => setState(() {}),
                              ),
                              TextFieldWithHeader(
                                headerTitle: "Enter your password",
                                placeholder: "password",
                                isPassword: true,
                                keyboardType: TextInputType.visiblePassword,
                                controller: _passwordController,
                                validator: _validatePassword,
                                onChanged: (_) => setState(() {}),
                              ),
                            ],
                          ),
                          SizedBox(height: bottomSpacing),
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
          child: Row(
            spacing: screenWidth > 600 ? 16.0 : 10.0,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  height: buttonHeight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
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
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  height: buttonHeight,
                  child: ElevatedButton(
                    onPressed: _isFormValid() ? _handleSubmit : null,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: _isFormValid()
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
                        _isFormValid() ? "Login" : "Fill out the form",
                        style: TextStyle(
                          fontSize: buttonFontSize,
                          fontWeight: FontWeight.w600,
                          color: _isFormValid()
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
        ),
      ),
    );
  }
}
