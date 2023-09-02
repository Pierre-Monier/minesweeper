import 'package:flutter/material.dart';
import 'package:mines_sweeper/game/game.dart';
import 'package:mines_sweeper/notifier/first_revealed_mine.dart';
import 'package:mines_sweeper/notifier/game_notifier.dart';
import 'package:mines_sweeper/ui/cell_tile.dart';
import 'package:mines_sweeper/ui/theme/size.dart';

class GameBody extends StatelessWidget {
  const GameBody({super.key});

  @override
  Widget build(BuildContext context) {
    final gameNotifier = GameNotifierProvider.of(context);

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
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: GameSizes.cell * game.config.columns,
                maxHeight: GameSizes.cell * game.config.rows,
              ),
              child: _GameCellsGrid(game: game),
            ),
          );
        },
      ),
    );
  }
}

class _GameCellsGrid extends StatelessWidget {
  const _GameCellsGrid({required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: game.gameStatus,
      builder: (context, gameStatus, child) => Column(
        children: game.cells
            .map(
              (e) => Row(
                children: e.map((e) {
                  final isGameOnGoing = gameStatus == GameStatus.onGoing;

                  return CellTile(
                    cell: e,
                    onFlagCellTap: () => isGameOnGoing
                        ? game.tapCell(e, gameMove: GameMove.flag)
                        : null,
                    onCellTap: isGameOnGoing ? () => game.tapCell(e) : null,
                  );
                }).toList(),
              ),
            )
            .toList(),
      ),
    );
  }
}
