import 'package:flutter_test/flutter_test.dart';
import 'package:mines_sweeper/extension/list.dart';
import 'package:mines_sweeper/game/cell.dart';
import 'package:mines_sweeper/game/game.dart';
import 'package:mines_sweeper/game/mine.dart';
import 'package:mines_sweeper/game/safe.dart';

void main() {
  void revealFirstCell<T extends Cell>(Game game) {
    game.tapCell(
      game.cells.firstWhere(
        (e) => e is T && e.displayMode.value != DisplayMode.revealed,
      ),
    );
  }

  test('game should generate cells', () {
    const rows = 2;
    final game = Game(rows: rows);

    expect(game.cells.length, rows * rows);
    expect(game.cells.whereType<Mine>().length, rows);
    expect(
      game.cells.every(
        (e) => e.neighbors
            .containsAll(game.cells.where((element) => element != e)),
      ),
      isTrue,
    );
    expect(game.stopwatch.isRunning, isFalse);
    expect(game.firstRevealedMine.value, null);
  });

  test('game should start on first cell tap', () {
    final game = Game();

    revealFirstCell<Safe>(game);

    expect(game.stopwatch.isRunning, isTrue);

    game.stopwatch.stop();
  });

  test('game should end if a mine is tapped', () {
    final game = Game();

    revealFirstCell<Safe>(game);
    revealFirstCell<Mine>(game);

    expect(game.stopwatch.isRunning, isFalse);
    expect(game.stopwatch.elapsedMicroseconds > 0, isTrue);
  });
}
