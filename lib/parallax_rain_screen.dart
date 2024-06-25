// ignore_for_file: library_private_types_in_public_api

import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:ui';


class RainOnGlassScreen extends StatelessWidget {
  const RainOnGlassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          // Image.network(
          //   'https://images.unsplash.com/photo-1500964757637-c85e8a162699',
          //   fit: BoxFit.cover,
          //   width: double.infinity,
          //   height: double.infinity,
          // ),

          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.indigo,
                  Colors.pinkAccent, 
                  Colors.teal
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
              )
            ),
          ),
          
          // Frosted Glass Effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          
          // Rain Effect
          const RainEffect(),
        ],
      ),
    );
  }
}

class RainEffect extends StatefulWidget {
  const RainEffect({super.key});

  @override
  _RainEffectState createState() => _RainEffectState();
}

class _RainEffectState extends State<RainEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();

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
          painter: RainPainter(_controller.value, _random),
          child: Container(),
        );
      },
    );
  }
}

class RainPainter extends CustomPainter {
  final double animationValue;
  final Random random;
  final int numberOfDrops = 200;
  final List<Offset> dropPositions = [];

  RainPainter(this.animationValue, this.random) {
    for (int i = 0; i < numberOfDrops; i++) {
      dropPositions.add(Offset(random.nextDouble(), random.nextDouble()));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    for (final position in dropPositions) {
      final double x = position.dx * size.width;
      final double y = (position.dy + animationValue) * size.height % size.height;
      canvas.drawCircle(Offset(x, y), 5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}