// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class AnimatedProgressBarWithGradient extends StatefulWidget {
  final double value; // Current progress value (between 0 and 1)

  const AnimatedProgressBarWithGradient({super.key, required this.value});

  @override
  _AnimatedProgressBarState createState() => _AnimatedProgressBarState();
}

class _AnimatedProgressBarState extends State<AnimatedProgressBarWithGradient>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _colorAnimation = ColorTween(
      begin: Colors.blue,
      end: Colors.green,
    ).animate(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AnimatedProgressBarWithGradient oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animationController.forward(from: 0.0); // Restart animation on value change
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Container(
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.blue, _colorAnimation.value!],
            ),
          ),
          width: MediaQuery.of(context).size.width * widget.value,
        );
      },
    );
  }
}



class AnimatedProgressBarWithGradientScreen extends StatelessWidget {
  const AnimatedProgressBarWithGradientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AnimatedProgressBarWithGradient(value: 1), 
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    
                  },
                  child: const Text('Update Progress'),
                ),
              ],
            ),
          ),
        ),
      );
  }
}