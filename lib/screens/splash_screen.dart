import 'package:flutter/material.dart';
import 'package:zithara_ai_assignment/screens/intro_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToIntroScreen();
  }

  _navigateToIntroScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const IntroScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            const Spacer(flex: 5),
            Image.asset("assets/logo.png"),
            const Spacer(flex: 7),
          ],
        ),
      ),
    );
  }
}
