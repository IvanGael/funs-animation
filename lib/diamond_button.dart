
import 'package:flutter/material.dart';

class DiamondButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color backgroundColor;

  const DiamondButton({super.key, required this.onPressed, required this.child,
  required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CustomPaint(
        painter: DiamondPainter(backgroundColor: backgroundColor),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}

class DiamondPainter extends CustomPainter {
  final Color backgroundColor;

  DiamondPainter({required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, size.height / 2);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}