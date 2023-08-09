import 'package:flutter/material.dart';
import 'package:mines_sweeper/game/game.dart';
import 'package:mines_sweeper/notifier/game.notifier.dart';
import 'package:mines_sweeper/ui/game_move_button.dart';

class GameBar extends StatelessWidget {
  const GameBar({super.key});

  @override
  Widget build(BuildContext context) {
    final gameNotifier = GameNotifierProvider.of(context).gameNotifier;

    return ValueListenableBuilder(
      valueListenable: gameNotifier,
      builder: (context, game, child) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(game.numberOfMines.toString()),
          IconButton(
            onPressed: gameNotifier.resetGame,
            icon: const Icon(Icons.restore),
          ),
          GameMoveButton(
            gameMove: game.gameMove,
            activeGameMove: GameMove.flag,
            onPressed: game.toggleFlag,
            icon: const Icon(Icons.flag),
          ),
          GameMoveButton(
            gameMove: game.gameMove,
            activeGameMove: GameMove.question,
            onPressed: game.toggleQuestion,
            icon: const Icon(Icons.question_mark),
          ),
          ListenableBuilder(
            listenable: game.timeSpend,
            builder: (context, child) => Text(
              game.timeSpend.value.inSeconds.toString(),
            ),
          )
        ],
      ),
    );
  }
}
