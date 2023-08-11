import 'package:flutter/material.dart';

class FlagDraw extends StatelessWidget {
  const FlagDraw({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _FlagDrawPainter(),
    );
  }
}

class _FlagDrawPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      Paint()..color = Colors.blue,
    );
  }

  @override
  bool shouldRepaint(covariant _FlagDrawPainter oldDelegate) {
    return false;
  }
}
