import 'package:flutter_test/flutter_test.dart';
import 'package:mines_sweeper/game/cell.dart';
import 'package:mines_sweeper/game/mine.dart';
import 'package:mines_sweeper/game/safe.dart';

void main() {
  test('default display mode is hidden', () {
    final safe = Safe(neighbors: []);

    expect(safe.displayMode, DisplayMode.hidden);
  });

  test('revealing a safe cell changes its display mode to revealed', () {
    final safe = Safe(neighbors: []);

    safe.reveal();

    expect(safe.displayMode, DisplayMode.revealed);
  });

  test('revealing a safe cell with no mines around reveals its neighbors', () {
    final safe = Safe(
      neighbors: [
        Safe(neighbors: []),
        Safe(neighbors: []),
        Safe(neighbors: [])
      ],
    );

    safe.reveal();

    expect(
      safe.neighbors
          .every((element) => element.displayMode == DisplayMode.revealed),
      true,
    );
  });

  test('revealing a safe cell with mines around does not reveal its neighbors',
      () {
    final safe = Safe(neighbors: [Mine(neighbors: [])]);

    safe.reveal();

    expect(
      safe.neighbors
          .every((element) => element.displayMode == DisplayMode.hidden),
      true,
    );
  });
}
