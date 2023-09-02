import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mines_sweeper/ui/theme/color.dart';
import 'package:mines_sweeper/ui/theme/size.dart';

class OldSchoolBorder extends StatefulWidget {
  const OldSchoolBorder({
    required this.child,
    this.isTapEnabled = true,
    this.shouldShowBorder = true,
    this.isReversed = false,
    this.onTapDown,
    this.onTapUp,
    super.key,
  });

  final Widget child;
  final bool isTapEnabled;
  final bool shouldShowBorder;
  final bool isReversed;
  final VoidCallback? onTapUp;
  final VoidCallback? onTapDown;

  @override
  State<OldSchoolBorder> createState() => _OldSchoolBorderState();
}

class _OldSchoolBorderState extends State<OldSchoolBorder> {
  late var _shouldShowBorder = widget.shouldShowBorder;

  @override
  void didUpdateWidget(covariant OldSchoolBorder oldWidget) {
    setState(() {
      _shouldShowBorder = widget.shouldShowBorder;
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.all(GameSizes.oldSchoolBorder),
      child: widget.child,
    );

    final child = widget.isTapEnabled
        ? GestureDetector(
            onTapUp: (_) {
              widget.onTapUp?.call();
            },
            onTapCancel: () {
              widget.onTapUp?.call();
            },
            onTapDown: (_) {
              setState(() {
                _shouldShowBorder = false;
              });
              widget.onTapDown?.call();
            },
            child: content,
          )
        : content;

    return _OldSchoolBorder(
      shouldShowBorder: _shouldShowBorder,
      isReversed: widget.isReversed,
      child: child,
    );
  }
}

class _OldSchoolBorder extends SingleChildRenderObjectWidget {
  const _OldSchoolBorder({
    required super.child,
    required this.shouldShowBorder,
    required this.isReversed,
  });

  final bool shouldShowBorder;
  final bool isReversed;

  @override
  _OldSchoolBorderRenderObject createRenderObject(BuildContext context) {
    return _OldSchoolBorderRenderObject(
      shouldShowBorder: shouldShowBorder,
      isReversed: isReversed,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _OldSchoolBorderRenderObject renderObject,
  ) {
    renderObject.shouldShowBorder = shouldShowBorder;
    renderObject.shouldShowBorder = shouldShowBorder;
  }
}

class _OldSchoolBorderRenderObject extends RenderProxyBox {
  _OldSchoolBorderRenderObject({
    required bool shouldShowBorder,
    required bool isReversed,
  })  : _shouldShowBorder = shouldShowBorder,
        _isReversed = isReversed;

  bool _shouldShowBorder;
  bool get shouldShowBorder => _shouldShowBorder;
  set shouldShowBorder(bool value) {
    if (value == _shouldShowBorder) return;
    _shouldShowBorder = value;
    markNeedsPaint();
  }

  bool _isReversed;
  bool get isReversed => _isReversed;
  set isReversed(bool value) {
    if (value == _isReversed) return;
    _isReversed = value;
    markNeedsPaint();
  }

  double get _borderWidth => GameSizes.oldSchoolBorder;

  @override
  void performLayout() {
    child!.layout(constraints, parentUsesSize: true);
    size = child!.size;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.paintChild(child!, offset);

    final maxWidth = size.width + offset.dx;
    final maxHeight = size.height + offset.dy;

    final upPath = Path()
      ..moveTo(maxWidth, offset.dy)
      ..lineTo(offset.dx, offset.dy)
      ..lineTo(offset.dx, maxHeight)
      ..lineTo(offset.dx + _borderWidth, maxHeight - _borderWidth)
      ..lineTo(offset.dx + _borderWidth, offset.dy + _borderWidth)
      ..lineTo(maxWidth - _borderWidth, offset.dy + _borderWidth)
      ..lineTo(maxWidth, offset.dy)
      ..close();

    context.canvas.drawPath(
      upPath,
      Paint()
        ..color = _upColor
        ..strokeWidth = _borderWidth,
    );

    if (!shouldShowBorder) return;

    final downPath = Path()
      ..moveTo(maxWidth, offset.dy)
      ..lineTo(maxWidth, maxHeight)
      ..lineTo(offset.dx, maxHeight)
      ..lineTo(offset.dx + _borderWidth, maxHeight - _borderWidth)
      ..lineTo(maxWidth - _borderWidth, maxHeight - _borderWidth)
      ..lineTo(maxWidth - _borderWidth, offset.dy + _borderWidth)
      ..lineTo(maxWidth, offset.dy)
      ..close();

    context.canvas.drawPath(
      downPath,
      Paint()
        ..color = _downColor
        ..strokeWidth = _borderWidth,
    );
  }

  Color get _upColor => shouldShowBorder && !isReversed
      ? GameColor.oldSchoolBorder.lightColor
      : GameColor.oldSchoolBorder.darkColor;

  Color get _downColor => !isReversed
      ? GameColor.oldSchoolBorder.darkColor
      : GameColor.oldSchoolBorder.lightColor;
}
