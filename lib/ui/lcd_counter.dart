import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mines_sweeper/ui/theme/color.dart';
import 'package:mines_sweeper/ui/theme/size.dart';

class LCDCounter extends StatelessWidget {
  const LCDCounter({required this.number, super.key});

  final int number;

  static const _totalWidth = 56.0;

  static const _padding = 2.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: GameSizes.gameBarItem,
      width: _totalWidth,
      padding: const EdgeInsets.all(2),
      child: CustomPaint(
        painter: _LCDCounterPainter(
          number: number,
          totalWidth: _totalWidth - _padding,
          spacing: _padding,
        ),
      ),
    );
  }
}

class _LCDCounterPainter extends CustomPainter {
  const _LCDCounterPainter({
    required this.number,
    required this.totalWidth,
    required this.spacing,
  });

  final int number;
  final double totalWidth;
  final double spacing;

  double get numberWidth => (totalWidth - (3 * spacing)) / 3;

  double _getNumberHeight(double canvasHeight) => canvasHeight / 2;

  static const numbersThickness = 2.5;

  @override
  void paint(Canvas canvas, Size size) {
    // We set the limit to 999
    final numbers = min(number, 999).toString().padLeft(3, '0').split('');

    _drawNumber(
      0,
      canvas: canvas,
      size: size,
      lcdPattern: _getLCDPattern(numbers[0]),
    );
    _drawNumber(
      1,
      canvas: canvas,
      size: size,
      lcdPattern: _getLCDPattern(numbers[1]),
    );
    _drawNumber(
      2,
      canvas: canvas,
      size: size,
      lcdPattern: _getLCDPattern(numbers[2]),
    );
  }

  void _drawNumber(
    int position, {
    required Canvas canvas,
    required Size size,
    required _LCDPattern lcdPattern,
  }) {
    canvas.drawPath(
      _getLeftPath(position, verticalPosition: 0, canvasHeight: size.height),
      Paint()
        ..color = _getNumberColor(
          lcdPattern.left1,
        ),
    );
    canvas.drawPath(
      _getLeftPath(position, verticalPosition: 1, canvasHeight: size.height),
      Paint()
        ..color = _getNumberColor(
          lcdPattern.left2,
        ),
    );
    canvas.drawPath(
      _getBottomPath(position, canvasHeight: size.height),
      Paint()
        ..color = _getNumberColor(
          lcdPattern.bottom,
        ),
    );
    canvas.drawPath(
      _getRightPath(position, verticalPosition: 1, canvasHeight: size.height),
      Paint()
        ..color = _getNumberColor(
          lcdPattern.right2,
        ),
    );
    canvas.drawPath(
      _getRightPath(position, verticalPosition: 0, canvasHeight: size.height),
      Paint()
        ..color = _getNumberColor(
          lcdPattern.right1,
        ),
    );
    canvas.drawPath(
      _getUpPath(position),
      Paint()
        ..color = _getNumberColor(
          lcdPattern.up,
        ),
    );
    canvas.drawPath(
      _getMiddlePath(position, canvasHeight: size.height),
      Paint()
        ..color = _getNumberColor(
          lcdPattern.middle,
        ),
    );
  }

  Path _getUpPath(int position) {
    final left = _getLeft(position);
    final right = _getRight(position);

    final partRight = _getPartDistance(right - left);

    return Path()
      ..moveTo(left, 0.0)
      ..lineTo(left + partRight.$1, numbersThickness)
      ..lineTo(left + partRight.$2, numbersThickness)
      ..lineTo(left + partRight.$3, 0.0)
      ..lineTo(left, 0.0)
      ..close();
  }

  Path _getMiddlePath(int position, {required double canvasHeight}) {
    final left = _getLeft(position);
    final right = _getRight(position);
    final height = canvasHeight / 2;

    final partRight = _getPartDistance(right - left);

    return Path()
      ..moveTo(left, height)
      ..lineTo(left + partRight.$1, height - numbersThickness / 2)
      ..lineTo(left + partRight.$2, height - numbersThickness / 2)
      ..lineTo(left + partRight.$3, height)
      ..lineTo(left + partRight.$2, height + numbersThickness / 2)
      ..lineTo(left + partRight.$1, height + numbersThickness / 2)
      ..lineTo(left, height)
      ..close();
  }

  Path _getBottomPath(int position, {required double canvasHeight}) {
    final left = _getLeft(position);
    final right = _getRight(position);

    final partRight = _getPartDistance(right - left);

    return Path()
      ..moveTo(left, canvasHeight)
      ..lineTo(left + partRight.$1, canvasHeight - numbersThickness)
      ..lineTo(left + partRight.$2, canvasHeight - numbersThickness)
      ..lineTo(left + partRight.$3, canvasHeight)
      ..lineTo(left, canvasHeight)
      ..close();
  }

  Path _getLeftPath(
    int position, {
    required double verticalPosition,
    required double canvasHeight,
  }) {
    final numberHeight = _getNumberHeight(canvasHeight);
    final partHeight = _getPartDistance(numberHeight);

    final top = verticalPosition * numberHeight;
    final left = _getLeft(position);

    return Path()
      ..moveTo(left, top)
      ..lineTo(left + numbersThickness, top + partHeight.$1)
      ..lineTo(left + numbersThickness, top + partHeight.$2)
      ..lineTo(left, top + partHeight.$3)
      ..lineTo(left, top)
      ..close();
  }

  Path _getRightPath(
    int position, {
    required double verticalPosition,
    required double canvasHeight,
  }) {
    final numberHeight = _getNumberHeight(canvasHeight);
    final partHeight = _getPartDistance(numberHeight);

    final top = verticalPosition * numberHeight;
    final right = _getRight(position);

    return Path()
      ..moveTo(right, top)
      ..lineTo(right - numbersThickness, top + partHeight.$1)
      ..lineTo(right - numbersThickness, top + partHeight.$2)
      ..lineTo(right, top + partHeight.$3)
      ..lineTo(right, top)
      ..close();
  }

  double _getLeft(int position) {
    return (position * numberWidth) + _getExtraSpacing(position);
  }

  double _getRight(int position) {
    return (position * numberWidth) + numberWidth + _getExtraSpacing(position);
  }

  double _getExtraSpacing(int position) => position * spacing;

  (double first, double second, double last) _getPartDistance(
    double distance,
  ) =>
      (distance / 4, (distance / 4) * 3, distance);

  _LCDPattern _getLCDPattern(String input) {
    switch (input) {
      case '0':
        return _LCDPattern.zero;
      case '1':
        return _LCDPattern.one;
      case '2':
        return _LCDPattern.two;
      case '3':
        return _LCDPattern.three;
      case '4':
        return _LCDPattern.four;
      case '5':
        return _LCDPattern.five;
      case '6':
        return _LCDPattern.six;
      case '7':
        return _LCDPattern.seven;
      case '8':
        return _LCDPattern.height;
      case '9':
        return _LCDPattern.nine;
      case '-':
        return _LCDPattern.minus;
      default:
        return _LCDPattern.unknown;
    }
  }

  Color _getNumberColor(bool isDisplayed) =>
      isDisplayed ? GameColor.lcdCounterOn : GameColor.lcdCounterOff;

  @override
  bool shouldRepaint(covariant _LCDCounterPainter oldDelegate) {
    return oldDelegate.number != number;
  }
}

enum _LCDPattern {
  zero(
    bottom: true,
    up: true,
    left1: true,
    left2: true,
    right1: true,
    right2: true,
  ),
  one(
    right1: true,
    right2: true,
  ),
  two(
    up: true,
    right1: true,
    middle: true,
    left2: true,
    bottom: true,
  ),
  three(
    up: true,
    right1: true,
    middle: true,
    right2: true,
    bottom: true,
  ),
  four(
    left1: true,
    middle: true,
    right1: true,
    right2: true,
  ),
  five(
    up: true,
    left1: true,
    middle: true,
    right2: true,
    bottom: true,
  ),
  six(
    up: true,
    left1: true,
    left2: true,
    middle: true,
    right2: true,
    bottom: true,
  ),
  seven(
    up: true,
    right1: true,
    right2: true,
  ),
  height(
    up: true,
    left1: true,
    left2: true,
    bottom: true,
    right2: true,
    right1: true,
    middle: true,
  ),
  nine(
    up: true,
    left1: true,
    middle: true,
    right1: true,
    right2: true,
    bottom: true,
  ),
  minus(middle: true),
  unknown();

  final bool up;
  final bool left1;
  final bool left2;
  final bool bottom;
  final bool right2;
  final bool right1;
  final bool middle;

  const _LCDPattern({
    this.up = false,
    this.left1 = false,
    this.left2 = false,
    this.bottom = false,
    this.right2 = false,
    this.right1 = false,
    this.middle = false,
  });
}
