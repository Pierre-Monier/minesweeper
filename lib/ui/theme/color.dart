import 'package:flutter/material.dart';

class GameColor {
  const GameColor._();

  static const background = Color(0xFFC0C0C0);

  static const cellBorder = Color(0xFF7B7B7B);

  static const firstRevealedMine = Colors.red;

  static const lcdCounterOn = firstRevealedMine;

  static final lcdCounterOff = Colors.grey.shade900;

  static final wrongFlag = firstRevealedMine.shade300;

  static const ({Color lightColor, Color darkColor}) oldSchoolBorder =
      (lightColor: Color(0xFFFFFFFF), darkColor: Color(0xFF808080));

  static const minesAround = [
    Color(0xFF0000FF),
    Color(0xFF017F01),
    Color(0xFFFF0000),
    Color(0xFF010080),
    Color(0xFF810102),
    Color(0xFF008081),
    Color(0xFF000000),
    Color(0xFF808080),
  ];
}
