import 'package:flutter/material.dart';
import 'package:zithara_ai_assignment/screens/login_screen.dart';
import 'package:zithara_ai_assignment/screens/widgets/shimmer_text.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  void initState() {
    _navigateToLoginScreen();
    super.initState();
  }

  _navigateToLoginScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 4),
            Container(
              alignment: Alignment.center,
              child: Image.asset("assets/logo.png"),
            ),
            const Spacer(flex: 1),
            const ShimmerText(
              text: "Chamkao Apne Bussiness Ka sitara",
              fontSize: 28,
            ),
            const Spacer(flex: 4),
          ],
        ),
      ),
    );
  }
}
