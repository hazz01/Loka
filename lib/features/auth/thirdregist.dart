import 'package:flutter/material.dart';

class ThirdRegisterPage extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onFinish;

  const ThirdRegisterPage({
    super.key,
    required this.onBack,
    required this.onFinish,
  });

  @override
  State<ThirdRegisterPage> createState() => _ThirdRegisterPageState();
}

class _ThirdRegisterPageState extends State<ThirdRegisterPage> {
  double budgetValue = 1; // 0 = Budget, 1 = Comfort, 2 = Premium
  String? travelType;

  final Color primaryColor = const Color(0xFF539DF3);
  final Color borderColor = const Color(0xFFE5E7EB);

  bool get isFormValid => travelType != null;

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
                      'Your Travel Style',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Help us recommend trips\nthat fit you best.',
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

              // BUDGET
              const Text(
                'Your budget for travel',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),

              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 6,
                  activeTrackColor: primaryColor,
                  inactiveTrackColor: borderColor,
                  thumbColor: Colors.white,
                  overlayColor: primaryColor.withOpacity(0.2),
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 10,
                  ),
                ),
                child: Slider(
                  min: 0,
                  max: 2,
                  divisions: 2,
                  value: budgetValue,
                  onChanged: (value) {
                    setState(() {
                      budgetValue = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 6),

              // BUDGET LABEL
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _BudgetItem(
                    title: 'Budget-Friendly',
                    price: '< IDR 3.000.000',
                    align: CrossAxisAlignment.start,
                  ),
                  _BudgetItem(
                    title: 'Comfort',
                    price: '> IDR 3.000.000',
                    align: CrossAxisAlignment.center,
                  ),
                  _BudgetItem(
                    title: 'Premium',
                    price: '> IDR 5.000.000',
                    align: CrossAxisAlignment.end,
                  ),
                ],
              ),

              const SizedBox(height: 26),

              // TRAVEL TYPE
              const Text(
                'Your travel type',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 14),

              // GRID
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isSmall = constraints.maxWidth < 360;

                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: isSmall ? 0.9 : 1,
                      ),
                      itemBuilder: (context, index) {
                        final items = [
                          ('Solo Travel', 'assets/icons/solo.jpg'),
                          ('Couple Travel', 'assets/icons/couple.jpg'),
                          ('Friend Travel', 'assets/icons/friend.jpg'),
                          ('Family Travel', 'assets/icons/family.jpg'),
                        ];

                        return _travelCard(items[index].$1, items[index].$2);
                      },
                    );
                  },
                ),
              ),

              // DOT
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [_dot(false), _dot(false), _dot(true)],
              ),

              const SizedBox(height: 22),

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
                      onPressed: isFormValid ? widget.onFinish : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        backgroundColor: isFormValid
                            ? primaryColor
                            : borderColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Finish',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isFormValid ? Colors.white : Colors.black38,
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

  Widget _travelCard(String title, String imagePath) {
    final bool isActive = travelType == title;

    return GestureDetector(
      onTap: () => setState(() => travelType = title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isActive ? primaryColor : borderColor,
            width: isActive ? 2 : 1.2,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              /// IMAGE
              Image.asset(imagePath, fit: BoxFit.cover),

              /// DARK OVERLAY
              Container(color: Colors.black.withOpacity(0.25)),

              /// BLUE OVERLAY WHEN ACTIVE
              if (isActive) Container(color: primaryColor.withOpacity(0.35)),

              /// CHECK ICON
              if (isActive)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check, size: 16, color: primaryColor),
                  ),
                ),

              /// TITLE
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 6,
                        ),
                      ],
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

// BUDGET LABEL

class _BudgetItem extends StatelessWidget {
  final String title;
  final String price;
  final CrossAxisAlignment align;

  const _BudgetItem({
    required this.title,
    required this.price,
    required this.align,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          price,
          style: const TextStyle(fontSize: 11, color: Colors.black54),
        ),
      ],
    );
  }
}
