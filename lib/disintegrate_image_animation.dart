// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:ui' as ui;


class DisintegrateImageAnimation extends StatelessWidget {
  const DisintegrateImageAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
          child: DisintegrateImage(),
        ),
      );
  }
}

class DisintegrateImage extends StatefulWidget {
  const DisintegrateImage({super.key});

  @override
  _DisintegrateImageState createState() => _DisintegrateImageState();
}

class _DisintegrateImageState extends State<DisintegrateImage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isDisintegrated = false;
  late ui.Image _image;
  bool _isImageLoaded = false;
  Offset? _startPoint;
  Offset? _endPoint;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _loadImage();
  }

  void _loadImage() async {
    final image = await _loadAssetImage('assets/nature2.jpg');
    setState(() {
      _image = image;
      _isImageLoaded = true;
    });
  }

  Future<ui.Image> _loadAssetImage(String path) async {
    final data = await DefaultAssetBundle.of(context).load(path);
    return decodeImageFromList(data.buffer.asUint8List());
  }

  void _onPanStart(DragStartDetails details) {
    _startPoint = details.localPosition;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _endPoint = details.localPosition;
    setState(() {});
  }

  void _onPanEnd(DragEndDetails details) {
    if (_startPoint != null && _endPoint != null) {
      final distance = (_endPoint! - _startPoint!).distance;
      if (distance > 50) {
        _controller.forward(from: 0);
        setState(() {
          _isDisintegrated = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: CustomPaint(
        size: const Size(300, 300),
        painter: _isImageLoaded
            ? _isDisintegrated
                ? DisintegratePainter(_image, _animation.value)
                : ImagePainter(_image, _startPoint, _endPoint)
            : null,
      ),
    );
  }
}

class ImagePainter extends CustomPainter {
  final ui.Image image;
  final Offset? startPoint;
  final Offset? endPoint;

  ImagePainter(this.image, this.startPoint, this.endPoint);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );

    if (startPoint != null && endPoint != null) {
      final redPaint = Paint()
        ..color = Colors.red
        ..strokeWidth = 4;
      canvas.drawLine(startPoint!, endPoint!, redPaint);
      final center = Offset(size.width / 2, size.height / 2);
      canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), redPaint);
      canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), redPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DisintegratePainter extends CustomPainter {
  final ui.Image image;
  final double progress;

  DisintegratePainter(this.image, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final parts = [
      Rect.fromLTRB(0, 0, center.dx, center.dy),
      Rect.fromLTRB(center.dx, 0, size.width, center.dy),
      Rect.fromLTRB(0, center.dy, center.dx, size.height),
      Rect.fromLTRB(center.dx, center.dy, size.width, size.height),
    ];

    final paint = Paint();
    for (var i = 0; i < parts.length; i++) {
      final rect = parts[i];
      final xOffset = (i % 2 == 0 ? -1 : 1) * 100 * progress;
      final yOffset = (i < 2 ? -1 : 1) * 100 * progress;
      canvas.save();
      canvas.translate(xOffset, yOffset);
      canvas.drawImageRect(
        image,
        Rect.fromLTWH(rect.left, rect.top, rect.width, rect.height),
        rect,
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
