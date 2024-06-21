import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:final_project/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Expanded(
            child: Center(
              child: LottieBuilder.asset('assets/lottie/shop.json'),
            ),
          ),
          const Text(
            'Easy POS',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ],
      ),
      nextScreen: const HomePage(),
      splashIconSize: 200,
      duration: 4000,
      backgroundColor: Colors.white,
    );
  }
}
