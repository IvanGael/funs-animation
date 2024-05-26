import 'dart:math';
import 'package:flutter/material.dart';

class PullToRefreshAnimationScreen extends StatelessWidget {
  const PullToRefreshAnimationScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Column(
        children: [
          const PullToRefreshWidget(),
          Expanded(
            child: ListView.builder(
              itemCount: 50,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Item $index'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PullToRefreshWidget extends StatefulWidget {
  const PullToRefreshWidget({Key? key});

  @override
  _PullToRefreshWidgetState createState() => _PullToRefreshWidgetState();
}

class _PullToRefreshWidgetState extends State<PullToRefreshWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutBack,
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
        // Simulate data loading completion
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            _isRefreshing = false;
          });
        });
      }
    });

    _controller.forward();
  }

  void _handleRefresh() {
    setState(() {
      _isRefreshing = true;
      _controller.forward();
      // Simulate data loading process
      // Replace this with your actual data loading logic
      Future.delayed(const Duration(seconds: 2), () {
        _controller.forward();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta?.isNegative ?? false) {
          if (!_isRefreshing) {
            _handleRefresh();
          }
        }
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: PullToRefreshPainter(_animation.value),
            child: Container(
              alignment: Alignment.center,
              height: 80.0,
              width: double.infinity,
              child: _isRefreshing
                  ? CircularProgressIndicator(
                      value: _animation.value,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 40.0,
                    ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class PullToRefreshPainter extends CustomPainter {
  final double progress;

  PullToRefreshPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    const double radius = 20.0;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      0,
      2 * progress * pi,
      false,
      paint,
    );

    const double lineLength = 20.0;
    const double startAngle = -0.5 * pi;
    final double endAngle = startAngle + progress * pi;

    final double x1 = centerX + radius * cos(startAngle);
    final double y1 = centerY + radius * sin(startAngle);
    final double x2 = centerX + (radius + lineLength) * cos(endAngle);
    final double y2 = centerY + (radius + lineLength) * sin(endAngle);

    canvas.drawLine(
      Offset(x1, y1),
      Offset(x2, y2),
      paint,
    );
  }

  @override
  bool shouldRepaint(PullToRefreshPainter oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
