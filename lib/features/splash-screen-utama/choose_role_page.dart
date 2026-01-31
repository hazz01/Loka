import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChooseRolePage extends StatefulWidget {
  const ChooseRolePage({super.key});

  @override
  State<ChooseRolePage> createState() => _ChooseRolePageState();
}

class _ChooseRolePageState extends State<ChooseRolePage> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Title
              const Text(
                'Welcome to Loka!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Let’s get started by choosing\nhow you’d like to use Loka.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 32),

              // Traveler Option
              GestureDetector(
                onTap: () {
                  setState(() {
                    // Toggle: jika sudah dipilih, batalkan pilihan
                    selectedRole = selectedRole == 'traveler'
                        ? null
                        : 'traveler';
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 25,
                  ),
                  decoration: BoxDecoration(
                    color: selectedRole == 'traveler'
                        ? const Color(0xffeef6fe)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selectedRole == 'traveler'
                          ? const Color(0xff539DF3)
                          : const Color(0xffE5E7EB),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "I'm a traveler",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: selectedRole == 'traveler'
                              ? const Color(0xff212121)
                              : const Color(0xff757575),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Explore and enjoy tourist destinations.",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: selectedRole == 'traveler'
                              ? const Color(0xff212121)
                              : const Color(0xff757575),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Manager Option
              GestureDetector(
                onTap: () {
                  setState(() {
                    // Toggle: jika sudah dipilih, batalkan pilihan
                    selectedRole = selectedRole == 'manager' ? null : 'manager';
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 25,
                  ),
                  decoration: BoxDecoration(
                    color: selectedRole == 'manager'
                        ? const Color(0xffeef6fe)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selectedRole == 'manager'
                          ? const Color(0xff539DF3)
                          : const Color(0xffE5E7EB),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "I manage tourism",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: selectedRole == 'manager'
                              ? const Color(0xff212121)
                              : const Color(0xff757575),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Manage and promote tourist destinations.",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: selectedRole == 'manager'
                              ? const Color(0xff212121)
                              : const Color(0xff757575),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Continue button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Choose wisely",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff212121),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "because you can't change it later.",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff539DF3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 35),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ElevatedButton(
                        onPressed: selectedRole != null
                            ? () {
                                if (selectedRole == 'traveler') {
                                  context.go('/opening');
                                } else {
                                  // Navigasi ke onboarding manager dulu
                                  context.go('/manager-onboarding');
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 48,
                          ),
                          backgroundColor: const Color(0xff539DF3),
                          disabledBackgroundColor: const Color(0xffF3F4F6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: Tween<Offset>(
                                      begin: const Offset(0, 0.2),
                                      end: Offset.zero,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                );
                              },
                          child: Text(
                            selectedRole == null
                                ? 'Choose Your Role'
                                : selectedRole == 'traveler'
                                ? 'Continue as Traveler'
                                : 'Continue as Manager',
                            key: ValueKey<String>(
                              selectedRole == null
                                  ? 'none'
                                  : selectedRole == 'traveler'
                                  ? 'traveler'
                                  : 'manager',
                            ),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: selectedRole != null
                                  ? Colors.white
                                  : const Color(0xff757575),
                            ),
                          ),
                        ),
                      ),
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
