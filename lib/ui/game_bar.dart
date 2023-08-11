import 'package:flutter/material.dart';
import 'package:mines_sweeper/game/game.dart';
import 'package:mines_sweeper/notifier/game.notifier.dart';
import 'package:mines_sweeper/ui/draw/face_draw.dart';
import 'package:mines_sweeper/ui/draw/flag_draw.dart';
import 'package:mines_sweeper/ui/game_bar_button.dart';
import 'package:mines_sweeper/ui/game_move_button.dart';

class GameBar extends StatelessWidget {
  const GameBar({super.key});

  @override
  Widget build(BuildContext context) {
    final gameNotifier = GameNotifierProvider.of(context).gameNotifier;

    return ValueListenableBuilder(
      valueListenable: gameNotifier,
      builder: (context, game, child) => Row(
        children: [
          const SizedBox(
            width: 16,
          ),
          ValueListenableBuilder(
            valueListenable: game.remainingMines,
            builder: (context, remainingMines, child) =>
                Text(remainingMines.toString()),
          ),
          const Spacer(),
          GameBarButton(
            // the button is never active
            active: false,
            onPressed: gameNotifier.resetGame,
            icon: const FaceDraw(),
          ),
          const SizedBox(
            width: 16,
          ),
          GameMoveButton(
            gameMove: game.gameMove,
            activeGameMove: GameMove.flag,
            onPressed: game.toggleFlag,
            icon: const FlagDraw(),
          ),
          const Spacer(),
          ListenableBuilder(
            listenable: game.timeSpend,
            builder: (context, child) => Text(
              game.timeSpend.value.inSeconds.toString(),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
    );
  }
}
