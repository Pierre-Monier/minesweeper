import 'package:flutter/material.dart';

class FaceDraw extends StatelessWidget {
  const FaceDraw({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _FaceDrawPainter(),
    );
  }
}

class _FaceDrawPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      Paint()..color = Colors.yellow,
    );
  }

  @override
  bool shouldRepaint(covariant _FaceDrawPainter oldDelegate) {
    return false;
  }
}
