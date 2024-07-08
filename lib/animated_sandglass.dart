// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class SandglassAnimationScreen extends StatelessWidget {
  const SandglassAnimationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          height: 300,
          child: SandglassAnimation(),
        ),
      ),
    );
  }
}

class SandglassAnimation extends StatefulWidget {
  const SandglassAnimation({super.key});

  @override
  _SandglassAnimationState createState() => _SandglassAnimationState();
}

class _SandglassAnimationState extends State<SandglassAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: SandglassPainter(_controller),
      child: Container(),
    );
  }
}

class SandglassPainter extends CustomPainter {
  final Animation<double> animation;

  SandglassPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown
      ..style = PaintingStyle.fill;

    final width = size.width;
    final height = size.height;
    final centerX = width / 2;

    // Draw the sandglass outline
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(width, 0)
      ..lineTo(centerX, height / 2)
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..lineTo(centerX, height / 2)
      ..close();

    canvas.drawPath(path, paint..color = Colors.black.withOpacity(0.4));

    // Draw the sand
    final sandPath = Path();
    final progress = animation.value;

    // Top half (emptying)
    final topY = height / 2 * progress;
    sandPath.moveTo(0, 0);
    sandPath.lineTo(width, 0);
    sandPath.lineTo(centerX + (width / 2) * (1 - progress), topY);
    sandPath.lineTo(centerX - (width / 2) * (1 - progress), topY);
    sandPath.close();

    // Bottom half (filling)
    final bottomY = height - (height / 2 * (1 - progress));
    sandPath.moveTo(centerX - (width / 2) * progress, bottomY);
    sandPath.lineTo(centerX + (width / 2) * progress, bottomY);
    sandPath.lineTo(width, height);
    sandPath.lineTo(0, height);
    sandPath.close();

    // Draw falling sand
    if (progress > 0 && progress < 1) {
      final fallPath = Path();
      fallPath.moveTo(centerX, height / 2);
      fallPath.lineTo(centerX + 2, height / 2);
      fallPath.lineTo(centerX + 2, bottomY);
      fallPath.lineTo(centerX - 2, bottomY);
      fallPath.close();
      canvas.drawPath(fallPath, paint);
    }

    canvas.drawPath(sandPath, paint..color = Colors.brown);
  }

  @override
  bool shouldRepaint(SandglassPainter oldDelegate) => true;
}