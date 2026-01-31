import 'package:flutter/material.dart';
import 'firstregist.dart';
import 'secondregist.dart';
import 'thirdregist.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  void nextPage() {
    if (currentIndex < 2) {
      _controller.jumpToPage(currentIndex + 1);
    }
  }

  void previousPage() {
    if (currentIndex > 0) {
      _controller.jumpToPage(currentIndex - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: [
          FirstRegister(onNext: nextPage),

          SecondRegisterPage(onNext: nextPage, onBack: previousPage),

          ThirdRegisterPage(
            onBack: previousPage,
            onFinish: () {
              print("REGISTER COMPLETED");
            },
          ),
        ],
      ),
    );
  }
}
