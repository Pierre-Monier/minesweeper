import 'package:flutter/material.dart';
import 'package:mines_sweeper/notifier/first_revealed_mine.dart';
import 'package:mines_sweeper/notifier/game.notifier.dart';
import 'package:mines_sweeper/ui/cell_tile.dart';

class GameBody extends StatelessWidget {
  const GameBody({super.key});

  @override
  Widget build(BuildContext context) {
    final gameNotifier = GameNotifierProvider.of(context).gameNotifier;

    return ValueListenableBuilder(
      valueListenable: gameNotifier,
      builder: (context, game, _) => ValueListenableBuilder(
        valueListenable: game.firstRevealedMine,
        builder: (
          context,
          firstRevealedMine,
          _,
        ) {
          return FirstRevealedMine(
            mine: firstRevealedMine,
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: game.rows,
              children: game.cells
                  .map(
                    (e) => CellTile(
                      cell: e,
                      onCellTap: () => game.tapCell(e),
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}
