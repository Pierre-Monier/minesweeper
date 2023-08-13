import 'package:flutter/material.dart';
import 'package:mines_sweeper/notifier/game_notifier.dart';
import 'package:mines_sweeper/ui/draw/face_draw.dart';
import 'package:mines_sweeper/ui/game_bar_button.dart';
import 'package:mines_sweeper/ui/lcd_counter.dart';

class GameBar extends StatelessWidget {
  const GameBar({super.key});

  @override
  Widget build(BuildContext context) {
    final gameNotifier = GameNotifierProvider.of(context).gameNotifier;

    return Padding(
      padding: const EdgeInsets.all(4),
      child: ValueListenableBuilder(
        valueListenable: gameNotifier,
        builder: (context, game, child) => Row(
          children: [
            ValueListenableBuilder(
              valueListenable: game.remainingMines,
              builder: (context, remainingMines, child) =>
                  LCDCounter(number: remainingMines),
            ),
            const Spacer(),
            GameBarButton(
              onPressed: gameNotifier.resetGame,
              icon: const FaceDraw(),
            ),
            const Spacer(),
            ListenableBuilder(
              listenable: game.timeSpend,
              builder: (context, child) => LCDCounter(
                number: game.timeSpend.value.inSeconds,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
