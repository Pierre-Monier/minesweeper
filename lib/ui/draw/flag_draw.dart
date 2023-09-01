import 'package:flutter/material.dart';

// FlagDraw is a StatelessWidget that draws a flag using CustomPaint.
class FlagDraw extends StatelessWidget {
  const FlagDraw({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _FlagDrawPainter(),
    );
  }
}

// _FlagDrawPainter is a CustomPainter that paints a flag.
class _FlagDrawPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const margin = 1.0;
    final maxWidth = size.width / 3 * 2;
    final maxHeight = size.height - margin;
    final firstBaseHeight = maxHeight - 3;
    final secondBaseTop = firstBaseHeight - 1.5;
    final firstBaseWidth = maxWidth;
    final secondBaseWidth = maxWidth / 1.75;
    const corpsWidth = 2.0;

    final corpsPaint = _createCorpsPaint(corpsWidth);

    _drawBase(
      canvas,
      size,
      firstBaseWidth,
      firstBaseHeight,
      maxHeight,
    );
    _drawBase(
      canvas,
      size,
      secondBaseWidth,
      secondBaseTop,
      maxHeight,
    );

    final corpsXCenter = size.width / 2 + .5;
    _drawCorps(canvas, corpsXCenter, secondBaseTop, margin, corpsPaint);

    _drawFlag(
      canvas,
      size,
      corpsXCenter,
      corpsWidth,
      margin,
      secondBaseTop,
      maxWidth,
    );
  }

  Paint _createFlagPaint(Size size) {
    return Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        colors: [Colors.red, Colors.black],
        stops: [0.33, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;
  }

  Paint _createCorpsPaint(double corpsWidth) {
    return Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = corpsWidth;
  }

  void _drawBase(
    Canvas canvas,
    Size size,
    double baseWidth,
    double baseTop,
    double maxHeight,
  ) {
    final basePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromLTRBR(
        (size.width - baseWidth) / 2,
        baseTop,
        baseWidth + (size.width - baseWidth) / 2,
        maxHeight,
        const Radius.circular(1.0),
      ),
      basePaint,
    );
  }

  void _drawCorps(
    Canvas canvas,
    double corpsXCenter,
    double baseTop,
    double margin,
    Paint corpsPaint,
  ) {
    canvas.drawLine(
      Offset(corpsXCenter, baseTop),
      Offset(corpsXCenter, margin + 1),
      corpsPaint,
    );
  }

  void _drawFlag(
    Canvas canvas,
    Size size,
    double corpsXCenter,
    double corpsWidth,
    double margin,
    double secondBaseTop,
    double maxWidth,
  ) {
    final path = Path();
    final flagBottom = secondBaseTop - 1;
    final flagLeft = (corpsXCenter + (corpsWidth / 2)) - maxWidth / 1.5;
    final flagLeftY = (secondBaseTop - 2) / 4;
    const controlDepth = 3.0;

    path.moveTo(corpsXCenter + (corpsWidth / 2), margin);
    path.lineTo(
      corpsXCenter + (corpsWidth / 2),
      flagBottom,
    );

    final controlPoint1 =
        Offset(corpsXCenter + (corpsWidth / 2), flagBottom - controlDepth);
    final controlPoint2 = Offset(
      flagLeft,
      flagLeftY + controlDepth,
    );
    final controlPoint3 = Offset(
      corpsXCenter + (corpsWidth / 2),
      margin - (controlDepth - 1),
    );

    path.cubicTo(
      controlPoint1.dx,
      controlPoint1.dy,
      controlPoint2.dx,
      controlPoint2.dy,
      flagLeft,
      flagLeftY,
    );

    path.cubicTo(
      controlPoint2.dx,
      controlPoint2.dy,
      controlPoint3.dx,
      controlPoint3.dy,
      corpsXCenter + (corpsWidth / 2),
      margin,
    );

    path.close();

    final flagPaint = _createFlagPaint(size);

    canvas.drawPath(path, flagPaint);
  }

  @override
  bool shouldRepaint(covariant _FlagDrawPainter oldDelegate) {
    return false;
  }
}
