// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class FlipBookAnimationScreen extends StatefulWidget {
  const FlipBookAnimationScreen({super.key});

  @override
  _FlipBookScreenState createState() => _FlipBookScreenState();
}

class _FlipBookScreenState extends State<FlipBookAnimationScreen>
    with SingleTickerProviderStateMixin {
  List<String> images = [
    'assets/manga1.jpg',
    'assets/manga2.jpg',
    'assets/manga3.jpg'
  ];

  int _currentIndex = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    // _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    // with Shadows and Curves:
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _nextImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % images.length;
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onTap: _nextImage,
          child: AnimatedBuilder(
            animation: _animation,
            // builder: (context, child) {
            //   final isFirstHalf = _animation.value <= 0.5;
            //   final angle = isFirstHalf ? _animation.value * 2 * 3.14159 : (1 - _animation.value) * 2 * 3.14159;
            //   return Transform(
            //     transform: Matrix4.rotationY(angle),
            //     alignment: Alignment.center,
            //     child: isFirstHalf
            //         ? Image.asset(images[_currentIndex])
            //         : Image.asset(images[(_currentIndex + 1) % images.length]),
            //   );
            // },
            // with Shadows and Curves:
            builder: (context, child) {
              final isFirstHalf = _animation.value <= 0.5;
              final angle = isFirstHalf
                  ? _animation.value * 2 * 3.14159
                  : (1 - _animation.value) * 2 * 3.14159;
              return Transform(
                transform: Matrix4.rotationY(angle)
                  ..setEntry(3, 2, 0.001), // Adding perspective
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 5,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: isFirstHalf
                      ? Image.asset(images[_currentIndex])
                      : Image.asset(
                          images[(_currentIndex + 1) % images.length]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
