import 'package:mines_sweeper/game/mine.dart';

abstract class Cell {
  Cell({required this.neighbors, this.displayMode = DisplayMode.hidden});

  final List<Cell> neighbors;

  DisplayMode displayMode;

  void reveal();

  int get minesAround => neighbors.whereType<Mine>().length;
}

enum DisplayMode {
  hidden,
  revealed,
}
