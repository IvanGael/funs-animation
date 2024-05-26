// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';



class ColorCycleAnimationScreen extends StatefulWidget {
  const ColorCycleAnimationScreen({super.key});

  @override
  _ColorCycleScreenState createState() => _ColorCycleScreenState();
}

class _ColorCycleScreenState extends State<ColorCycleAnimationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _animation = ColorTween(
      begin: Colors.red,
      end: Colors.blue,
    ).animate(_controller);

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: 200,
              height: 200,
              color: _animation.value,
            );
          },
        ),
      ),
    );
  }
}