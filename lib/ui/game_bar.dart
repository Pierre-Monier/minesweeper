import 'package:flutter/material.dart';
import 'package:mines_sweeper/game/game.dart';
import 'package:mines_sweeper/notifier/game.notifier.dart';

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
          Text(game.rows.toString()),
          IconButton(
            onPressed: gameNotifier.resetGame,
            icon: const Icon(Icons.restore),
          ),
          ValueListenableBuilder(
            valueListenable: game.gameMove,
            builder: (context, gameMove, _) => IconButton(
              color: gameMove == GameMove.flag ? Colors.yellow : null,
              onPressed: () {
                game.toggleFlag();
              },
              icon: const Icon(Icons.flag),
            ),
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
