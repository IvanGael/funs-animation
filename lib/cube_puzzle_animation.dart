// ignore_for_file: library_private_types_in_public_api

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart' as vmath;

class CubePuzzleAnimationScreen extends StatelessWidget {
  const CubePuzzleAnimationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      body: Center(
        child: CubePuzzleAnimation(),
      ),
    );
  }
}

class CubePuzzleAnimation extends StatefulWidget {
  const CubePuzzleAnimation({super.key});

  @override
  _CubePuzzleAnimationState createState() => _CubePuzzleAnimationState();
}

class _CubePuzzleAnimationState extends State<CubePuzzleAnimation> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isErased = false;
  List<Particle> particles = [];
  final int particleCount = 5000;
  double _rotationAngle = pi * 45;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _generateParticles();
  }

  void _generateParticles() {
    particles = [];
    final rand = math.Random();
    final colors = [
      Colors.white12,
      Colors.white24,
      Colors.white,
      Colors.white38,
      Colors.white54,
      Colors.white60,
    ];

    for (int i = 0; i < particleCount; i++) {
      final x = rand.nextDouble() * 2 - 1;
      final y = rand.nextDouble() * 2 - 1;
      final z = rand.nextDouble() * 2 - 1;
      final position = vmath.Vector3(x, y, z);
      final color = colors[rand.nextInt(colors.length)];
      particles.add(Particle(position, color));
    }
  }

  void _onTap() {
    if (isErased) {
      _controller.reverse(from: 1);
    } else {
      _controller.forward(from: 0);
      Future.delayed(const Duration(seconds: 1), (){
        _controller.reverse(from: 1);
      });
    }
    setState(() {
      isErased = !isErased;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _onTap,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                size: const Size(300, 300),
                painter: isErased
                    ? ParticlePainter(_animation.value, particles)
                    : CubePainter(rotationAngle: _rotationAngle),
              );
            },
          ),
        ),
        Slider(
          value: _rotationAngle,
          min: 0,
          max: 360,
          onChanged: (value) {
            setState(() {
              _rotationAngle = value;
            });
          },
          activeColor: Colors.greenAccent,
        ),
      ],
    );
  }
}

class Particle {
  vmath.Vector3 initialPosition;
  Color color;
  Particle(this.initialPosition, this.color);
}

class ParticlePainter extends CustomPainter {
  final double progress;
  final List<Particle> particles;
  ParticlePainter(this.progress, this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);
    final sideLength = size.width / 4;
    final rand = math.Random();

    for (var particle in particles) {
      final x = lerpDouble(particle.initialPosition.x * sideLength, (rand.nextDouble() * 2 - 1) * size.width, progress)!;
      final y = lerpDouble(particle.initialPosition.y * sideLength, (rand.nextDouble() * 2 - 1) * size.height, progress)!;
      final z = particle.initialPosition.z * (1 - progress);

      final scale = 1 / (z + 2); // Simple perspective scaling
      final px = x * scale + center.dx;
      final py = y * scale + center.dy;

      paint.color = particle.color.withOpacity(1 - progress);
      canvas.drawCircle(Offset(px, py), 2 * (1 - progress), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CubePainter extends CustomPainter {
  final double rotationAngle;
  CubePainter({required this.rotationAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final center = Offset(size.width / 2, size.height / 2);
    final sideLength = size.width / 4;

    // 3D Cube points
    final vertices = [
      vmath.Vector3(-1, -1, -1),
      vmath.Vector3(1, -1, -1),
      vmath.Vector3(1, 1, -1),
      vmath.Vector3(-1, 1, -1),
      vmath.Vector3(-1, -1, 1),
      vmath.Vector3(1, -1, 1),
      vmath.Vector3(1, 1, 1),
      vmath.Vector3(-1, 1, 1),
    ];

    // Apply rotation
    final rotationMatrix = vmath.Matrix4.identity()
      ..rotateY(vmath.radians(rotationAngle))
      ..rotateX(vmath.radians(rotationAngle));
    final transformedVertices = vertices
        .map((vertex) => rotationMatrix.transformed3(vertex))
        .toList();

    // Draw cube faces
    final faces = [
      [0, 1, 2, 3],
      [4, 5, 6, 7],
      [0, 1, 5, 4],
      [2, 3, 7, 6],
      [0, 3, 7, 4],
      [1, 2, 6, 5],
    ];

    final colors = [
      Colors.white12,
      Colors.white24,
      Colors.white,
      Colors.white38,
      Colors.white54,
      Colors.white60,
    ];

    for (int i = 0; i < faces.length; i++) {
      final face = faces[i];
      final path = Path()
        ..moveTo(transformedVertices[face[0]].x * sideLength + center.dx,
            transformedVertices[face[0]].y * sideLength + center.dy)
        ..lineTo(transformedVertices[face[1]].x * sideLength + center.dx,
            transformedVertices[face[1]].y * sideLength + center.dy)
        ..lineTo(transformedVertices[face[2]].x * sideLength + center.dx,
            transformedVertices[face[2]].y * sideLength + center.dy)
        ..lineTo(transformedVertices[face[3]].x * sideLength + center.dx,
            transformedVertices[face[3]].y * sideLength + center.dy)
        ..close();

      paint.color = colors[i];
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
