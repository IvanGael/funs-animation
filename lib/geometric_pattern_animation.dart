// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:math';

class GeometricPatternAnimationScreen extends StatelessWidget {
  const GeometricPatternAnimationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: AnimatedGeometricPattern(),
      );
  }
}

class AnimatedGeometricPattern extends StatefulWidget {
  const AnimatedGeometricPattern({super.key});

  @override
  _AnimatedGeometricPatternState createState() => _AnimatedGeometricPatternState();
}

class _AnimatedGeometricPatternState extends State<AnimatedGeometricPattern> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: GeometricPatternPainter(_controller.value),
          child: Container(),
        );
      },
    );
  }
}

class GeometricPatternPainter extends CustomPainter {
  final double animationValue;

  GeometricPatternPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = Colors.red.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final paint3 = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    for (int i = 0; i < 10; i++) {
      final angle = (2 * pi / 10) * i + (2 * pi * animationValue);
      final radius = 100.0 + 20.0 * i;
      final offset = Offset(
        centerX + radius * cos(angle),
        centerY + radius * sin(angle),
      );
      canvas.drawCircle(offset, 30, paint);
    }

    for (int i = 0; i < 10; i++) {
      final angle = (2 * pi / 10) * i + (2 * pi * animationValue);
      final radius = 100.0 + 20.0 * i;
      final offset = Offset(
        centerX + radius * cos(angle + pi / 5),
        centerY + radius * sin(angle + pi / 5),
      );
      canvas.drawCircle(offset, 20, paint2);
    }

    for (int i = 0; i < 10; i++) {
      final angle = (2 * pi / 10) * i + (2 * pi * animationValue);
      final radius = 100.0 + 20.0 * i;
      final offset = Offset(
        centerX + radius * cos(angle + pi / 2.5),
        centerY + radius * sin(angle + pi / 2.5),
      );
      canvas.drawCircle(offset, 10, paint3);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
