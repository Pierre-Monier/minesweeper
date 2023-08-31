import 'dart:math';
import 'dart:ui' as ui;

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
    // Constants for readability
    const double radiusReduction = 1.5;
    const double spikeLengthIncrease = 0.25;
    const double baseStrokeWidth = 3;
    const double haloStrokeWidth = 3;
    const double haloRadius = 1;

    // Calculate dimensions
    final double maxWidth = (size.width / 2) - 2;
    final double maxHeight = (size.height / 2) - 2;
    final double radius = (size.width / 3) - radiusReduction;

    // Define paints
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final spikePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Define paths
    final path = Path();
    final spikePath = Path();

    // Draw the main body of the mine
    path.addOval(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: radius,
      ),
    );
    canvas.drawPath(path, paint);

    // Draw the spikes of the mine
    for (int i = 0; i < 360; i += 45) {
      final isHorizontalOrVertical = [0, 90, 180, 270].contains(i);
      final isException = [270].contains(i);

      final double reducedMaxWidth =
          isHorizontalOrVertical ? maxWidth : maxWidth - spikeLengthIncrease;
      final double reducedMaxHeight =
          isHorizontalOrVertical ? maxHeight : maxHeight - spikeLengthIncrease;

      final double dx = reducedMaxWidth * cos(i * pi / 180);
      final double dy = reducedMaxHeight * sin(i * pi / 180);

      spikePath.moveTo(size.width / 2, size.height / 2);
      spikePath.lineTo(size.width / 2 + dx, size.height / 2 + dy);
      canvas.drawPath(spikePath, spikePaint);

      if (isHorizontalOrVertical && !isException) continue;

      // Draw a thicker part at the base of the spike
      final baseSpikePaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = baseStrokeWidth;

      final baseSpikePath = Path();
      final double baseDx = (radius - spikeLengthIncrease) * cos(i * pi / 180);
      final double baseDy = (radius - spikeLengthIncrease) * sin(i * pi / 180);
      baseSpikePath.moveTo(size.width / 2 + baseDx, size.height / 2 + baseDy);

      final baseControlPoint = Offset(
        size.width / 2 + baseDx + dx / 100,
        size.height / 2 + baseDy + dy / 100,
      );
      baseSpikePath.quadraticBezierTo(
        baseControlPoint.dx,
        baseControlPoint.dy,
        size.width / 2 + baseDx + dx / 250,
        size.height / 2 + baseDy + dy / 250,
      );
      canvas.drawPath(baseSpikePath, baseSpikePaint);
    }

    // Draw a white halo on top of the main circle of the mine
    final haloCenter = Offset((size.width / 2) - 1, (size.height / 2) - 1);
    final haloPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = haloStrokeWidth
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1)
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

  @override
  bool shouldRepaint(covariant _MineDrawPainter oldDelegate) {
    return false;
  }
}
