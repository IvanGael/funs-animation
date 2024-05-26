
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';


class AvatarAnimationScreen extends StatefulWidget {
  const AvatarAnimationScreen({super.key});

  @override
  _AvatarAnimationDemoState createState() => _AvatarAnimationDemoState();
}

class _AvatarAnimationDemoState extends State<AvatarAnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<String> avatarList = [
    'assets/manga1.jpg',
    'assets/manga2.jpg',
    'assets/manga3.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          children: avatarList.map((avatar) {
            return AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animation.value,
                  child: child,
                );
              },
              child: GestureDetector(
                onTap: () {
                  if (_controller.isAnimating) {
                    _controller.stop();
                  } else {
                    _controller.repeat(reverse: true);
                  }
                },
                child: Image.asset(
                  avatar,
                  width: 80,
                  height: 80,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
