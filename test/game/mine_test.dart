import 'package:flutter_test/flutter_test.dart';
import 'package:mines_sweeper/game/cell.dart';
import 'package:mines_sweeper/game/mine.dart';

void main() {
  test('default display mode should be hidden', () {
    final mine = Mine();

    expect(mine.displayMode.value, DisplayMode.hidden);
  });

  test('revealing a mine cell changes its display mode to revealed', () {
    final mine = Mine();

    mine.reveal();

    expect(mine.displayMode.value, DisplayMode.revealed);
  });
}
