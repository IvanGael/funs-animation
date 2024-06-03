// ignore_for_file: library_private_types_in_public_api

import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:async';

class FlipClockScreen extends StatefulWidget {
  const FlipClockScreen({super.key});

  @override
  _FlipClockState createState() => _FlipClockState();
}

class _FlipClockState extends State<FlipClockScreen> {
  late Timer _timer;
  late DateTime _dateTime;

  @override
  void initState() {
    super.initState();
    _dateTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTime);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime(Timer timer) {
    setState(() {
      _dateTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: Center(
        child: Container(
          height: 180,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.2),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.5), width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlipColumn(
                      value: _dateTime.hour ~/ 10,
                      title: 'H',
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    FlipColumn(
                      value: _dateTime.hour % 10,
                      title: 'H',
                    ),
                    Transform.translate(
                      offset: const Offset(0, 14),
                      child: const Text(
                        ":",
                        style: TextStyle(
                          fontSize: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    FlipColumn(
                      value: _dateTime.minute ~/ 10,
                      title: 'M',
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    FlipColumn(
                      value: _dateTime.minute % 10,
                      title: 'M',
                    ),
                    Transform.translate(
                      offset: const Offset(0, 14),
                      child: const Text(
                        ":",
                        style: TextStyle(
                          fontSize: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    FlipColumn(
                      value: _dateTime.second ~/ 10,
                      title: 'S',
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    FlipColumn(
                      value: _dateTime.second % 10,
                      title: 'S',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FlipColumn extends StatelessWidget {
  final int value;
  final String title;

  const FlipColumn({
    super.key,
    required this.value,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        FlipCard(value: value),
      ],
    );
  }
}

class FlipCard extends StatefulWidget {
  final int value;

  const FlipCard({
    super.key,
    required this.value,
  });

  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late int _previousValue;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void didUpdateWidget(FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final isFirstHalf = _animation.value < 0.5;
        final displayValue = isFirstHalf ? _previousValue : widget.value;
        final transformValue = isFirstHalf ? _animation.value * 2 : (1 - _animation.value) * 2;

        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(transformValue * 3.14),
          alignment: Alignment.center,
          child: Container(
            width: 60,
            height: 80,
            decoration: BoxDecoration(
              // color: Colors.grey[800],
              gradient: const LinearGradient(
                  colors: [Colors.deepPurpleAccent, Colors.greenAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0, 1]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '$displayValue',
                style: const TextStyle(
                  fontSize: 60,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
