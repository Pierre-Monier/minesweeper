import 'package:mines_sweeper/game/cell.dart';

class Safe extends Cell {
  Safe();

  @override
  void reveal() {
    displayMode.value = DisplayMode.revealed;

    if (minesAround != 0) return;

    final hiddenNeighbors =
        neighbors.where((n) => n.displayMode.value == DisplayMode.hidden);

    for (final hiddenNeighbor in hiddenNeighbors) {
      hiddenNeighbor.reveal();
    }
  }
}
