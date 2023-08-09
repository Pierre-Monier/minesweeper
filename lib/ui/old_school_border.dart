import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mines_sweeper/ui/theme/color.dart';

class OldSchoolBorder extends StatefulWidget {
  const OldSchoolBorder({
    required this.child,
    this.isTapEnabled = true,
    super.key,
  });

  final Widget child;
  final bool isTapEnabled;

  static const borderWidth = 3.0;

  @override
  State<OldSchoolBorder> createState() => _OldSchoolBorderState();
}

class _OldSchoolBorderState extends State<OldSchoolBorder> {
  var _shouldShowBorder = true;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.all(OldSchoolBorder.borderWidth),
      child: widget.child,
    );

    final child = widget.isTapEnabled
        ? GestureDetector(
            onTapDown: (_) {
              setState(() {
                _shouldShowBorder = false;
              });
            },
            child: content,
          )
        : content;

    return _OldSchoolBorder(
      shouldShowBorder: _shouldShowBorder,
      child: child,
    );
  }
}

class _OldSchoolBorder extends SingleChildRenderObjectWidget {
  const _OldSchoolBorder({required super.child, this.shouldShowBorder = true});

  final bool shouldShowBorder;

  @override
  _OldSchoolBorderRenderObject createRenderObject(BuildContext context) {
    return _OldSchoolBorderRenderObject(shouldShowBorder: shouldShowBorder);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _OldSchoolBorderRenderObject renderObject,
  ) {
    renderObject.shouldShowBorder = shouldShowBorder;
  }
}

class _OldSchoolBorderRenderObject extends RenderProxyBox {
  _OldSchoolBorderRenderObject({required bool shouldShowBorder})
      : _shouldShowBorder = shouldShowBorder;

  bool _shouldShowBorder;
  bool get shouldShowBorder => _shouldShowBorder;
  set shouldShowBorder(bool value) {
    if (value == _shouldShowBorder) return;
    _shouldShowBorder = value;
    markNeedsPaint();
  }

  double get _borderWidth => OldSchoolBorder.borderWidth;

  @override
  void performLayout() {
    child!.layout(constraints, parentUsesSize: true);
    size = child!.size;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.paintChild(child!, offset);

    if (!shouldShowBorder) return;

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
