import 'package:flutter/foundation.dart';
import 'package:mines_sweeper/game/mine.dart';

abstract class Cell {
  Cell()
      : neighbors = [],
        displayMode = ValueNotifier(DisplayMode.hidden);

  final List<Cell> neighbors;

  ValueNotifier<DisplayMode> displayMode;

  void toggleFlag() {
    displayMode.value = displayMode.value == DisplayMode.flagged
        ? DisplayMode.hidden
        : DisplayMode.flagged;
  }

  void reveal();

  int get minesAround => neighbors.whereType<Mine>().length;

  @override
  String toString() {
    return '$runtimeType#$hashCode, displayMode #${displayMode.value},neighbors [${neighbors.map((e) => '${e.runtimeType}#${e.hashCode}').join(',')}]';
  }
}

enum DisplayMode {
  hidden,
  revealed,
  flagged,
}
