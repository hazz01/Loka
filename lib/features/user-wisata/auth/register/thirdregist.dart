import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loka/shared/widgets/toast_components.dart';

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
  final Color activeBg = const Color(0xffeef6fe);

  bool get isFormValid => travelType != null;

  void _handleSubmit() {
    if (travelType == null) {
      ToastNotification.error(
        context,
        message: 'Please select your travel type',
      );
      return;
    }
    context.go('/finish');
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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TITLE
                Padding(
                  padding: EdgeInsets.symmetric(vertical: verticalPadding),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Your Travel Style',
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff212121),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Help us recommend trips\nthat fit you best.',
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

                // BUDGET
                const Text(
                  'Your budget for travel',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff212121),
                  ),
                ),

                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 16,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _BudgetItem(
                      title: 'Budget-Friendly',
                      price: '< IDR 3.000.000',
                      align: CrossAxisAlignment.start,
                      isActive: budgetValue == 0,
                    ),
                    _BudgetItem(
                      title: 'Comfort',
                      price: '> IDR 3.000.000',
                      align: CrossAxisAlignment.center,
                      isActive: budgetValue == 1,
                    ),
                    _BudgetItem(
                      title: 'Premium',
                      price: '> IDR 5.000.000',
                      align: CrossAxisAlignment.end,
                      isActive: budgetValue == 2,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // TRAVEL TYPE
                const Text(
                  'Your travel type',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff212121),
                  ),
                ),

                const SizedBox(height: 8),

                // GRID
                LayoutBuilder(
                  builder: (context, gridConstraints) {
                    final isSmall = gridConstraints.maxWidth < 360;
                    final aspectRatio = isSmall ? 0.9 : 1.0;
                    final itemWidth = (gridConstraints.maxWidth - 14) / 2;
                    final itemHeight = itemWidth / aspectRatio;
                    final gridHeight = (itemHeight * 2) + 14;

                    return SizedBox(
                      height: gridHeight,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: aspectRatio,
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
                      ),
                    );
                  },
                ),
                SizedBox(height: verticalPadding),
              ],
            ),
          ),
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
                children: [_dot(false), _dot(false), _dot(true)],
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
                            isFormValid ? "Finish" : "Fill out the form",
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
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: active ? const Color(0xff757575) : const Color(0xffE5E7EB),
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
  final bool isActive;

  const _BudgetItem({
    required this.title,
    required this.price,
    required this.align,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isActive ? const Color(0xff212121) : const Color(0xff757575),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          price,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.normal,
            color: isActive ? const Color(0xff539DF3) : const Color(0xff9CA3AF),
          ),
        ),
      ],
    );
  }
}
