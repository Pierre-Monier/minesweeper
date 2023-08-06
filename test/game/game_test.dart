import 'package:flutter_test/flutter_test.dart';
import 'package:mines_sweeper/extension/list.dart';
import 'package:mines_sweeper/game/game.dart';
import 'package:mines_sweeper/game/mine.dart';

void main() {
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
  });
}
