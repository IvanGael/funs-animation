// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class FoldingPaperWidgetScreen extends StatelessWidget {
  const FoldingPaperWidgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
          child: FoldingPaperWidget(),
        ),
      );
  }
}

class FoldingPaperWidget extends StatefulWidget {
  const FoldingPaperWidget({super.key});

  @override
  _FoldingPaperWidgetState createState() => _FoldingPaperWidgetState();
}

class _FoldingPaperWidgetState extends State<FoldingPaperWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _foldProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..addListener(() {
      setState(() {
        _foldProgress = _controller.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startFolding() {
    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _startFolding,
      child: CustomPaint(
        painter: FoldingPaperPainter(_foldProgress),
        size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
      ),
    );
  }
}

class FoldingPaperPainter extends CustomPainter {
  final double foldProgress;

  FoldingPaperPainter(this.foldProgress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

    final paperWidth = size.width;
    final paperHeight = size.height;
    final foldedWidth = paperWidth * (1 - foldProgress);

    // Draw the main (unfolded) part of the paper
    canvas.drawRect(Rect.fromLTWH(0, 0, foldedWidth, paperHeight), paint);

    // Draw the folded part of the paper
    final foldPath = Path()
      ..moveTo(foldedWidth, 0)
      ..lineTo(paperWidth, 0)
      ..lineTo(foldedWidth, paperHeight * foldProgress)
      ..close();
    canvas.drawPath(foldPath, paint);

    // Draw the shadow cast by the folded part
    final shadowPath = Path()
      ..moveTo(foldedWidth, 0)
      ..lineTo(foldedWidth, paperHeight)
      ..lineTo(foldedWidth - (paperWidth - foldedWidth) * 0.6, paperHeight)
      ..lineTo(foldedWidth, paperHeight * foldProgress)
      ..close();
    canvas.drawPath(shadowPath, shadowPaint);

    // Draw the crease line
    final creasePaint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(foldedWidth, 0),
      Offset(foldedWidth, paperHeight),
      creasePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}