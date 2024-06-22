// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:math';

class BeerFromAnimationScreen extends StatefulWidget {
  const BeerFromAnimationScreen({super.key});

  @override
  _BeerFromAnimationScreenState createState() => _BeerFromAnimationScreenState();
}

class _BeerFromAnimationScreenState extends State<BeerFromAnimationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showText = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..addListener((){{
      if(_controller.value >= 0.5){
        setState(() {
          _showText = true;
        });
      } else {
        setState(() {
          _showText = false;
        });
      }
    }});
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _controller.value -= details.delta.dy / 300;
              });
            },
            child: Center(
              child: CustomPaint(
                painter: BeerPainter(_animation),
                child: Container(),
              ),
            ),
          ),
          if(_showText == true)
          const Center(
            child: Text(
              "Welcome",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BeerPainter extends CustomPainter {
  final Animation<double> animation;

  BeerPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final gradient = LinearGradient(
      colors: [Colors.indigoAccent, Colors.deepPurpleAccent, Colors.indigo.shade500],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final foamPaint = Paint()
      ..color = Colors.deepPurpleAccent
      ..style = PaintingStyle.fill;

    // Draw the beer with wave effect
    final path = Path();
    const waveHeight = 20.0;
    final waveLength = size.width / 2;
    final yOffset = size.height * (1 - animation.value);

    path.moveTo(0, yOffset);
    for (double x = 0; x <= size.width; x++) {
      final y = yOffset + sin((x / waveLength) * 2 * pi) * waveHeight;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Draw the foam
    final foamPath = Path();
    foamPath.moveTo(0, yOffset - waveHeight);
    for (double x = 0; x <= size.width; x++) {
      final y = yOffset - waveHeight + sin((x / waveLength) * 2 * pi) * waveHeight;
      foamPath.lineTo(x, y);
    }
    foamPath.lineTo(size.width, yOffset - waveHeight - 20);
    foamPath.lineTo(0, yOffset - waveHeight - 20);
    foamPath.close();

    canvas.drawPath(foamPath, foamPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
