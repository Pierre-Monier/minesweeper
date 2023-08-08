import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mines_sweeper/ui/theme/color.dart';

class OldSchoolBorder extends SingleChildRenderObjectWidget {
  const OldSchoolBorder({required super.child, super.key});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _OldSchoolBorderRenderObject();
  }
}

class _OldSchoolBorderRenderObject extends RenderProxyBox {
  _OldSchoolBorderRenderObject();

  static const _borderWidth = 4.0;

  @override
  void performLayout() {
    child!.layout(constraints, parentUsesSize: true);
    size = child!.size;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.paintChild(child!, offset);

    final whitePath = Path()
      ..moveTo(child!.size.width, offset.dy)
      ..lineTo(offset.dx, offset.dy)
      ..lineTo(offset.dx, size.height)
      ..lineTo(offset.dx + _borderWidth, size.height - _borderWidth)
      ..lineTo(offset.dx + _borderWidth, offset.dy + _borderWidth)
      ..lineTo(child!.size.width - _borderWidth, offset.dy + _borderWidth)
      ..lineTo(child!.size.width, offset.dy)
      ..close();

    context.canvas.drawPath(
      whitePath,
      Paint()
        ..color = GameColor.oldSchoolBorder.lightColor
        ..strokeWidth = _borderWidth,
    );

    final blackPath = Path()
      ..moveTo(child!.size.width, offset.dy)
      ..lineTo(child!.size.width, size.height)
      ..lineTo(offset.dx, size.height)
      ..lineTo(offset.dx + _borderWidth, size.height - _borderWidth)
      ..lineTo(child!.size.width - _borderWidth, size.height - _borderWidth)
      ..lineTo(child!.size.width - _borderWidth, offset.dy + _borderWidth)
      ..lineTo(child!.size.width, offset.dy)
      ..close();

    context.canvas.drawPath(
      blackPath,
      Paint()
        ..color = GameColor.oldSchoolBorder.darkColor
        ..strokeWidth = _borderWidth,
    );
  }
}
