import 'package:flutter_test/flutter_test.dart';
import 'package:mines_sweeper/game/cell.dart';
import 'package:mines_sweeper/game/mine.dart';
import 'package:mines_sweeper/game/safe.dart';

void main() {
  test('default display mode is hidden', () {
    final safe = Safe();

    expect(safe.displayMode.value, DisplayMode.hidden);
  });

  test('revealing a safe cell changes its display mode to revealed', () {
    final safe = Safe();

    safe.reveal();

    expect(safe.displayMode.value, DisplayMode.revealed);
  });

  test('revealing a safe cell with no mines around reveals its neighbors', () {
    final safe = Safe();
    safe.neighbors.addAll(
      [Safe(), Safe(), Safe()],
    );
    safe.reveal();

    expect(
      safe.neighbors.every(
        (element) => element.displayMode.value == DisplayMode.revealed,
      ),
      true,
    );
  });

  test('revealing a safe cell with mines around does not reveal its neighbors',
      () {
    final safe = Safe();
    safe.neighbors.addAll([Mine()]);

    safe.reveal();

    expect(
      safe.neighbors
          .every((element) => element.displayMode.value == DisplayMode.hidden),
      true,
    );
  });

  test('can be set in flag display mode', () {
    final safe = Safe();

    safe.toggleFlag();

    expect(safe.displayMode.value, DisplayMode.flagged);

    safe.toggleFlag();

    expect(safe.displayMode.value, DisplayMode.hidden);
  });
}
