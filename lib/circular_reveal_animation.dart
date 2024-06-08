// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class CircularRevealAnimation extends StatefulWidget {
  const CircularRevealAnimation({super.key});

  @override
  _CircularRevealAnimationState createState() =>
      _CircularRevealAnimationState();
}

class _CircularRevealAnimationState extends State<CircularRevealAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    _animation = Tween<double>(
      begin: 0,
      end: 40,
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomPaint(
          painter: _CircularRevealPainter(
            fraction: _animation.value,
            color: Colors.indigoAccent,
          ),
          child: ElevatedButton(
            onPressed: () {
              if (_controller.status == AnimationStatus.completed) {
                _controller.reverse();
                setState(() {
                  
                });
              } else {
                _controller.forward();
                setState(() {
                  
                });
                // // Navigate to a new screen when the animation is complete
                // Future.delayed(const Duration(milliseconds: 500), () {
                //   Navigator.of(context)
                //       .push(MaterialPageRoute(
                //         builder: (_) => const SecondScreen(),
                //         maintainState: false
                //         )
                //       );
                // });
              }
            },
            child: const Text("Discover"),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _CircularRevealPainter extends CustomPainter {
  _CircularRevealPainter({
    required this.fraction,
    required this.color,
  });

  final double fraction;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width * fraction;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_CircularRevealPainter oldDelegate) {
    return oldDelegate.fraction != fraction;
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
      ),
      body: const Center(
        child: Text(
          'This is the second screen',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
