import 'package:mines_sweeper/game/cell.dart';

class Safe extends Cell {
  Safe({required super.neighbors});

  @override
  void reveal() {
    displayMode = DisplayMode.revealed;

    if (minesAround != 0) return;

    final hiddenNeighbors =
        neighbors.where((n) => n.displayMode == DisplayMode.hidden);

    for (final hiddenNeighbor in hiddenNeighbors) {
      hiddenNeighbor.reveal();
    }
  }
}
