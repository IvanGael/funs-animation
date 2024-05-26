// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashAnimation extends StatefulWidget {
  const SplashAnimation({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();

    // You can add more animations or navigation logic here
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Navigator.pushReplacement(...) // Navigate to next screen
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/dash.png",
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 20),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Dashit coll Rnc.',
                      textStyle: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                      speed: const Duration(milliseconds: 600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
