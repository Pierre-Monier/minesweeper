import 'package:flutter/material.dart';

class MineDraw extends StatelessWidget {
  const MineDraw({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MineDrawPainter(),
    );
  }
}

class _MineDrawPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      Paint()..color = Colors.red,
    );
  }

  @override
  bool shouldRepaint(covariant _MineDrawPainter oldDelegate) {
    return false;
  }
}
