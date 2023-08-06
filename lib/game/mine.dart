import 'package:mines_sweeper/game/cell.dart';

class Mine extends Cell {
  Mine();

  @override
  void reveal() {
    displayMode.value = DisplayMode.revealed;
  }
}
