// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:async';

import 'diamond_button.dart';

class AnimatedStopwatch extends StatefulWidget {
  const AnimatedStopwatch({super.key});

  @override
  _RadarVibrationAnimationState createState() =>
      _RadarVibrationAnimationState();
}

class _RadarVibrationAnimationState extends State<AnimatedStopwatch>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Timer _timer;
  late int _elapsedSeconds = 0;
  late String _formattedTime = "00:00:00";
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.decelerate);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startStopwatch() {
    _controller.repeat(reverse: false);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _isRunning = true;
        _elapsedSeconds++;
        _formattedTime = _formatTime(_elapsedSeconds);
      });
    });
  }

  void _stopStopwatch() {
    setState(() {
      _isRunning = false;
      _controller.stop();
      _timer.cancel();
    });
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int remainingSeconds = seconds % 3600;
    int minutes = remainingSeconds ~/ 60;
    int secs = remainingSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.black,
          ),
          Center(
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.deepPurpleAccent,
                    Colors.black,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent,
                    blurRadius: 15.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CustomPaint(
                    size: const Size(300, 300),
                    painter: RadarPainter(_animation),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.47,
            left: MediaQuery.of(context).size.width * 0.26,
            child: Text(
              _formattedTime,
              style: const TextStyle(
                color: Colors.white24,
                fontSize: 45,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width * 0.42,
            child: DiamondButton(
              backgroundColor: _isRunning ? Colors.redAccent : Colors.greenAccent,
              onPressed: (){
                if (_isRunning) {
                  _stopStopwatch();
                } else {
                  _startStopwatch();
                }
              },
              child: Text(
                _isRunning ? 'Stop' : 'Start',
                style: const TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class RadarPainter extends CustomPainter {
  final Animation<double> animation;
  RadarPainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    const double strokeWidth = 2.0;
    final Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(Offset(radius, radius), radius - strokeWidth / 2, paint);
    canvas.drawCircle(
        Offset(radius, radius), radius * animation.value, paint);
  }

  @override
  bool shouldRepaint(RadarPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(RadarPainter oldDelegate) => false;
}