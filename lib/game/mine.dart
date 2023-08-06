import 'package:mines_sweeper/game/cell.dart';

class Mine extends Cell {
  Mine({required super.neighbors});

  @override
  void reveal() {
    displayMode = DisplayMode.revealed;
  }
}
