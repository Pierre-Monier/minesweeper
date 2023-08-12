import 'package:flutter_test/flutter_test.dart';
import 'package:mines_sweeper/extension/list.dart';
import 'package:mines_sweeper/game/cell.dart';
import 'package:mines_sweeper/game/config.dart';
import 'package:mines_sweeper/game/game.dart';
import 'package:mines_sweeper/game/mine.dart';
import 'package:mines_sweeper/game/safe.dart';

void main() {
  void revealFirstCell<T extends Cell>(Game game) {
    game.tapCell(
      game.everyCells.firstWhere(
        (e) => e is T && e.displayMode.value != DisplayMode.revealed,
      ),
    );
  }

  void revealEveryCell<T extends Cell>(Game game) {
    for (final cell in game.everyCells
        .where((e) => e is T && e.displayMode.value != DisplayMode.revealed)) {
      game.tapCell(cell);
    }
  }

  test('game should generate everyCells', () {
    const rows = 2;
    final game = Game(
      config: CustomConfig(rows: 2, columns: 2, numberOfMines: 2),
    );

    expect(game.everyCells.length, rows * rows);
    expect(game.everyCells.whereType<Mine>().length, rows);
    expect(
      game.everyCells.every(
        (e) => e.neighbors
            .containsAll(game.everyCells.where((element) => element != e)),
      ),
      isTrue,
    );
    expect(game.timeSpend.isRunning, isFalse);
    expect(game.gameStatus.value, GameStatus.onGoing);
  });

  test('game should start on first cell tap', () {
    final game = Game();

    revealFirstCell<Safe>(game);

    expect(game.timeSpend.isRunning, isTrue);

    game.timeSpend.stop();
  });

  test('game should end if a mine is tapped', () async {
    final game = Game();

    revealFirstCell<Safe>(game);

    revealFirstCell<Mine>(game);

    expect(game.timeSpend.isRunning, isFalse);

    // TODO(Pierre): use fakeAsync to test this code
    // expect(game.timeSpend.value.inMicroseconds > 0, isTrue);
    expect(game.gameStatus.value, GameStatus.loose);
    expect(game.firstRevealedMine.value, isNotNull);
    expect(
      game.everyCells.where(
        (e) => e is Mine && e.displayMode.value != DisplayMode.revealed,
      ),
      isEmpty,
    );
  });

  test('game should end if every safe cell are revealed', () {
    final game = Game();

    revealEveryCell<Safe>(game);

    expect(game.timeSpend.isRunning, isFalse);
    // TODO(Pierre): use fakeAsync to test this code
    // expect(game.timeSpend.value.inMicroseconds > 0, isTrue);
    expect(game.gameStatus.value, GameStatus.win);
  });

  test('game can be in flag game move', () {
    final game = Game();

    game.toggleFlag();

    expect(game.gameMove.value, GameMove.flag);

    game.toggleFlag();

    expect(game.gameMove.value, GameMove.reveal);
  });
}
