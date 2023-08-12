import 'package:flutter/material.dart';
import 'package:mines_sweeper/notifier/game.notifier.dart';
import 'package:mines_sweeper/ui/draw/face_draw.dart';
import 'package:mines_sweeper/ui/game_bar_button.dart';

class GameBar extends StatelessWidget {
  const GameBar({super.key});

  @override
  Widget build(BuildContext context) {
    final gameNotifier = GameNotifierProvider.of(context).gameNotifier;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: ValueListenableBuilder(
        valueListenable: gameNotifier,
        builder: (context, game, child) => Row(
          children: [
            ValueListenableBuilder(
              valueListenable: game.remainingMines,
              builder: (context, remainingMines, child) =>
                  Text(remainingMines.toString()),
            ),
            const Spacer(),
            GameBarButton(
              onPressed: gameNotifier.resetGame,
              icon: const FaceDraw(),
            ),
            const Spacer(),
            ListenableBuilder(
              listenable: game.timeSpend,
              builder: (context, child) => Text(
                game.timeSpend.value.inSeconds.toString(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
