import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gradient_animation_text/flutter_gradient_animation_text.dart';

class AnimatedMeshgradientText extends StatelessWidget {
  const AnimatedMeshgradientText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GradientAnimationText(
                    text: Text(
                      'Meshing',
                      style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 8),
                    ),
                    colors: [
                      Color(0xff8f00ff), // violet
                      Colors.indigo,
                      Colors.blue,
                      Colors.green,
                      Colors.yellow,
                      Colors.orange,
                      Colors.red,
                    ],
                    duration: Duration(seconds: 5),
                    reverse: true, // reverse the animation
                    transform:
                        GradientRotation(pi / 4), // transform the gradient
                  ),
      ),
    );
  }
}
