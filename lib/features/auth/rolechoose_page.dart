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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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

              // Traveler Card
              _RoleCard(
                title: "I’m a traveler",
                subtitle: "Explore and enjoy tourist destinations.",
                isSelected: selectedRole == 'traveler',
                onTap: () {
                  setState(() => selectedRole = 'traveler');
                },
              ),

              const SizedBox(height: 16),

              // Tourism Manager Card
              _RoleCard(
                title: "I manage tourism",
                subtitle: "Manage and promote tourist destinations.",
                isSelected: selectedRole == 'manager',
                onTap: () {
                  setState(() => selectedRole = 'manager');
                },
              ),

              const Spacer(),

              // Hint text
              Column(
                children: const [
                  Text("Choose wisely,", style: TextStyle(fontSize: 13)),
                  SizedBox(height: 4),
                  Text(
                    "because you can't change it later.",
                    style: TextStyle(fontSize: 13, color: Color(0xFF3B82F6)),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: selectedRole == null
                      ? null
                      : () {
                          // next page
                          context.go('/opening');
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedRole != null
                        ? const Color(0xFF539DF3) // 🔵 aktif
                        : const Color(0xFFF2F2F2), // ⚪ non-aktif
                    disabledBackgroundColor: const Color(0xFFF2F2F2),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Choose Your Role",
                    style: TextStyle(
                      color: selectedRole != null
                          ? Colors.white
                          : Colors.black54,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF93C5FD) // 🔵 border biru soft
                : const Color(0xFFE5E7EB),
            width: 1.4,
          ),
          color: isSelected
              ? const Color(0xFF3B82F6).withOpacity(0.08) // 🔵 bg biru kalem
              : Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
