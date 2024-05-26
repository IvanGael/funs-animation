// ignore_for_file: library_private_types_in_public_api

import 'dart:math';

import 'package:flutter/material.dart';

class NumbersParticleAnimation extends StatefulWidget {
  const NumbersParticleAnimation({super.key});

  @override
  _ParticleSystemDemoState createState() => _ParticleSystemDemoState();
}

class _ParticleSystemDemoState extends State<NumbersParticleAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _controller.addListener(() {
      setState(() {
        _particles.removeWhere((particle) => particle.isDead);
        for (var particle in _particles) {
          particle.update();
        }
      });
    });
    _controller.repeat();
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
      body: GestureDetector(
        onTap: () {
          _generateParticles();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomPaint(
              size: Size(double.infinity, MediaQuery.of(context).size.height),
              painter: ParticlePainter(particles: _particles),
            ),
          ],
        ),
      ),
    );
  }

  void _generateParticles() {
    final random = Random();
    final numParticles = random.nextInt(30) + 10;

    for (int i = 0; i < numParticles; i++) {
      final particle = Particle(
        position: Offset(
          MediaQuery.of(context).size.width / 2,
          MediaQuery.of(context).size.height / 3,
        ),
        velocity: Offset(
          random.nextDouble() * 6 - 3,
          -random.nextDouble() * 10 - 5,
        ),
        acceleration: const Offset(0, 0.5),
        size: random.nextDouble() * 50 + 10,
        lifespan: Duration(milliseconds: random.nextInt(500) + 500),
        rotation: random.nextDouble() * 2 * pi,
        rotationSpeed: random.nextDouble() * 0.2 - 0.1,
        color: Colors.primaries[random.nextInt(Colors.primaries.length)],
        number: random.nextInt(10),
      );
      _particles.add(particle);
    }
  }
}

class Particle {
  Offset position;
  Offset velocity;
  Offset acceleration;
  double size;
  Duration lifespan;
  bool isDead = false;
  double rotation;
  double rotationSpeed;
  Color color;
  int number;

  Particle({
    required this.position,
    required this.velocity,
    required this.acceleration,
    required this.size,
    required this.lifespan,
    required this.rotation,
    required this.rotationSpeed,
    required this.color,
    required this.number,
  });

  void update() {
    velocity += acceleration;
    position += velocity;
    rotation += rotationSpeed;
    lifespan -= const Duration(milliseconds: 16);
    if (lifespan <= Duration.zero) {
      isDead = true;
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (var particle in particles) {
      paint.color = particle.color.withOpacity(particle.lifespan.inMilliseconds / 1000);
      canvas.save();
      canvas.translate(particle.position.dx, particle.position.dy);
      canvas.rotate(particle.rotation);
      canvas.drawCircle(Offset.zero, particle.size, paint);
      final textStyle = TextStyle(
        color: Colors.pink,
        fontSize: particle.size * 0.8,
        fontWeight: FontWeight.bold,
      );
      final textSpan = TextSpan(
        text: particle.number.toString(),
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(-particle.size / 2, -particle.size / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
