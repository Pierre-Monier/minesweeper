import 'dart:ui' as ui;

import 'package:flutter/material.dart';

mixin HaloPaintMixin on CustomPainter {
  void drawHaloPaint({required Offset haloCenter, required Canvas canvas}) {
    const double haloStrokeWidth = 3;
    const double haloRadius = 1;

    final haloPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = haloStrokeWidth
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, haloRadius)
      ..shader = ui.Gradient.linear(
        Offset(haloCenter.dx - 1, haloCenter.dy / 2 - 1),
        Offset(haloCenter.dx + 1, haloCenter.dy / 2 + 1),
        [Colors.grey.shade900, Colors.white],
        [0.0, 1.0],
      );

    final haloPath = Path();
    haloPath.addOval(
      Rect.fromCircle(
        center: haloCenter,
        radius: haloRadius,
      ),
    );
    canvas.drawPath(haloPath, haloPaint);
  }
}
