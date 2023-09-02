import 'package:flutter/material.dart';
import 'package:mines_sweeper/notifier/face_draw_type_notifier.dart';
import 'package:mines_sweeper/notifier/game_notifier.dart';
import 'package:mines_sweeper/notifier/is_player_tapping_notifier.dart';
import 'package:mines_sweeper/ui/draw/halo_paint_mixin.dart';

class FaceDraw extends StatelessWidget {
  const FaceDraw({super.key});

  @override
  Widget build(BuildContext context) {
    final isPlayerTappingNotifier = IsPlayerTappingNotifierProvider.of(context);

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ValueListenableBuilder(
        valueListenable: GameNotifierProvider.of(context),
        builder: (context, game, child) {
          return CustomPaint(
            painter: _FaceDrawPainter(
              drawTypeNotifier: FaceDrawTypeNotifier(
                gameStatus: game.gameStatus,
                isPlayerTappingNotifier: isPlayerTappingNotifier,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FaceDrawPainter extends CustomPainter with HaloPaintMixin {
  const _FaceDrawPainter({required this.drawTypeNotifier})
      : super(repaint: drawTypeNotifier);

  final FaceDrawTypeNotifier drawTypeNotifier;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.yellow, Colors.grey.shade700],
        stops: const [0.25, 1.0],
      ).createShader(Rect.fromLTWH(0.0, 0.0, size.width, size.height));
    final center = Offset(size.width / 2, size.height / 2);

    // Draw face
    canvas.drawCircle(center, size.width / 2, paint);
    // Draw black circle surrounding the face
    final blackPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, size.width / 2, blackPaint);

    final haloDx = center.dx - (size.width / 6) - 3;
    final haloDy = center.dy - (size.width / 6) - 3;
    final haloCenter = Offset(
      haloDx,
      haloDy,
    );

    drawHaloPaint(canvas: canvas, haloCenter: haloCenter);

    switch (drawTypeNotifier.value) {
      case FaceDrawType.happy:
        _drawHappyFace(canvas, size, center);
      case FaceDrawType.dead:
        _drawDeadFace(canvas, size, center);
      case FaceDrawType.cool:
        _drawCoolFace(canvas, size, center);
      case FaceDrawType.surprised:
        _drawSurprisedFace(canvas, size, center);
    }
  }

  void _drawHappyFace(
    Canvas canvas,
    Size size,
    Offset center,
  ) {
    final smileRadius = size.width / 4;
    final eyeRadius = size.width / 12;
    final eyeOffset = size.width / 6;

    // Draw eyes
    canvas.drawCircle(
      Offset(center.dx - eyeOffset, center.dy - eyeOffset),
      eyeRadius,
      Paint(),
    );
    canvas.drawCircle(
      Offset(center.dx + eyeOffset, center.dy - eyeOffset),
      eyeRadius,
      Paint(),
    );

    // Draw smile
    final smileStart =
        Offset(center.dx - smileRadius, center.dy + smileRadius / 2);
    final smileEnd =
        Offset(center.dx + smileRadius, center.dy + smileRadius / 2);
    final smileControlPoint1 =
        Offset(center.dx - smileRadius / 2, center.dy + smileRadius);
    final smileControlPoint2 =
        Offset(center.dx + smileRadius / 2, center.dy + smileRadius);

    final path = Path()
      ..moveTo(smileStart.dx, smileStart.dy)
      ..cubicTo(
        smileControlPoint1.dx,
        smileControlPoint1.dy,
        smileControlPoint2.dx,
        smileControlPoint2.dy,
        smileEnd.dx,
        smileEnd.dy,
      );

    canvas.drawPath(
      path,
      Paint()
        ..strokeWidth = 2.0
        ..color = Colors.black
        ..style = PaintingStyle.stroke,
    );
  }

  void _drawDeadFace(
    Canvas canvas,
    Size size,
    Offset center,
  ) {
    final eyeRadius = size.width / 12;
    final eyeOffset = size.width / 6;
    final mouthRadius = size.width / 4;

    // Draw eyes as X
    final eyesPaint = Paint()
      ..strokeWidth = 1.5
      ..color = Colors.black
      ..style = PaintingStyle.stroke;

    final enlargedEyeRadius = eyeRadius * 2; // Increase the size of the x eyes
    canvas.drawLine(
      Offset(
        center.dx - eyeOffset - enlargedEyeRadius / 2,
        center.dy - eyeOffset - enlargedEyeRadius / 2,
      ),
      Offset(
        center.dx - eyeOffset + enlargedEyeRadius / 2,
        center.dy - eyeOffset + enlargedEyeRadius / 2,
      ),
      eyesPaint,
    );
    canvas.drawLine(
      Offset(
        center.dx - eyeOffset - enlargedEyeRadius / 2,
        center.dy - eyeOffset + enlargedEyeRadius / 2,
      ),
      Offset(
        center.dx - eyeOffset + enlargedEyeRadius / 2,
        center.dy - eyeOffset - enlargedEyeRadius / 2,
      ),
      eyesPaint,
    );
    canvas.drawLine(
      Offset(
        center.dx + eyeOffset - enlargedEyeRadius / 2,
        center.dy - eyeOffset - enlargedEyeRadius / 2,
      ),
      Offset(
        center.dx + eyeOffset + enlargedEyeRadius / 2,
        center.dy - eyeOffset + enlargedEyeRadius / 2,
      ),
      eyesPaint,
    );
    canvas.drawLine(
      Offset(
        center.dx + eyeOffset - enlargedEyeRadius / 2,
        center.dy - eyeOffset + enlargedEyeRadius / 2,
      ),
      Offset(
        center.dx + eyeOffset + enlargedEyeRadius / 2,
        center.dy - eyeOffset - enlargedEyeRadius / 2,
      ),
      eyesPaint,
    );

    // Draw mouth as reverse smile
    final yBasePoint = center.dy + 1;
    final mouthStart =
        Offset(center.dx - mouthRadius, yBasePoint + mouthRadius / 2);
    final mouthEnd =
        Offset(center.dx + mouthRadius, yBasePoint + mouthRadius / 2);
    final mouthControlPoint1 = Offset(center.dx - mouthRadius / 2, yBasePoint);
    final mouthControlPoint2 = Offset(center.dx + mouthRadius / 2, yBasePoint);

    final path = Path()
      ..moveTo(mouthStart.dx, mouthStart.dy)
      ..cubicTo(
        mouthControlPoint1.dx,
        mouthControlPoint1.dy,
        mouthControlPoint2.dx,
        mouthControlPoint2.dy,
        mouthEnd.dx,
        mouthEnd.dy,
      );

    canvas.drawPath(
      path,
      Paint()
        ..strokeWidth = 2.0
        ..color = Colors.black
        ..style = PaintingStyle.stroke,
    );
  }

  void _drawSurprisedFace(
    Canvas canvas,
    Size size,
    Offset center,
  ) {
    final eyeRadius = size.width / 12;
    final eyeOffset = size.width / 6;
    const mouthRadius = 3.0;

    // Draw eyes a bit higher
    canvas.drawCircle(
      Offset(center.dx - eyeOffset, center.dy - eyeOffset - eyeRadius),
      eyeRadius,
      Paint(),
    );
    canvas.drawCircle(
      Offset(center.dx + eyeOffset, center.dy - eyeOffset - eyeRadius),
      eyeRadius,
      Paint(),
    );

    // Draw mouth as a circle
    final mouthCenter = Offset(center.dx, center.dy + mouthRadius / 2);
    canvas.drawCircle(
      mouthCenter,
      mouthRadius,
      Paint()
        ..strokeWidth = 2.0
        ..color = Colors.black
        ..style = PaintingStyle.stroke,
    );
  }

  void _drawCoolFace(
    Canvas canvas,
    Size size,
    Offset center,
  ) {
    // Define constants and variables
    final eyeOffset = size.width / 6;
    final smileRadius = size.width / 4;
    final glassesWidth = size.width / 3;
    const glassesBridgeSize = 2.0;
    const glassesBranchSize = 1.5;
    const glassesRadius = 2.0;
    final glassesHeight = size.width / 4;
    final glassesTop = center.dy - eyeOffset - glassesHeight / 2;
    final leftGlassesLeft =
        center.dx - eyeOffset - (glassesWidth - (glassesBridgeSize / 2)) / 2;
    final rightGlassesRight =
        center.dx + eyeOffset + (glassesWidth - (glassesBridgeSize / 2)) / 2;
    const halfBranchSize = glassesBranchSize / 2;

    // Define paints
    final glassesPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    final glassesBridgePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = glassesBridgeSize;
    final glassesBranchPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = glassesBranchSize;

    // Draw smile
    final smileStart =
        Offset(center.dx - smileRadius, center.dy + smileRadius / 2);
    final smileEnd =
        Offset(center.dx + smileRadius, center.dy + smileRadius / 2);
    final smileControlPoint1 =
        Offset(center.dx - smileRadius / 2, center.dy + smileRadius);
    final smileControlPoint2 =
        Offset(center.dx + smileRadius / 2, center.dy + smileRadius);

    final path = Path()
      ..moveTo(smileStart.dx, smileStart.dy)
      ..cubicTo(
        smileControlPoint1.dx,
        smileControlPoint1.dy,
        smileControlPoint2.dx,
        smileControlPoint2.dy,
        smileEnd.dx,
        smileEnd.dy,
      );

    canvas.drawPath(
      path,
      Paint()
        ..strokeWidth = 2.0
        ..color = Colors.black
        ..style = PaintingStyle.stroke,
    );

    // Draw glasses
    // Left glass
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(
          leftGlassesLeft,
          glassesTop,
          center.dx - eyeOffset + (glassesWidth - (glassesBridgeSize / 2)) / 2,
          center.dy - eyeOffset + glassesHeight / 2,
        ),
        const Radius.circular(glassesRadius),
      ),
      glassesPaint,
    );

    // Right glass
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(
          center.dx + eyeOffset - (glassesWidth - (glassesBridgeSize / 2)) / 2,
          glassesTop,
          rightGlassesRight,
          center.dy - eyeOffset + glassesHeight / 2,
        ),
        const Radius.circular(glassesRadius),
      ),
      glassesPaint,
    );

    // Draw glasses bridge
    canvas.drawLine(
      Offset(leftGlassesLeft, glassesTop + glassesBridgeSize / 2),
      Offset(rightGlassesRight, glassesTop + glassesBridgeSize / 2),
      glassesBridgePaint,
    );

    // Draw glasses branches
    // Left branch
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(
        leftGlassesLeft + halfBranchSize,
        glassesTop + halfBranchSize,
      ),
      glassesBranchPaint,
    );

    // Right branch
    canvas.drawLine(
      Offset(size.width, size.height / 2),
      Offset(rightGlassesRight - halfBranchSize, glassesTop + halfBranchSize),
      glassesBranchPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _FaceDrawPainter oldDelegate) {
    return true;
  }
}
