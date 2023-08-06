import 'package:flutter/material.dart';
import 'package:mines_sweeper/notifier/game.notifier.dart';

class GameBar extends StatelessWidget {
  const GameBar({required this.gameNotifier, super.key});

  final GameNotifier gameNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: gameNotifier,
      builder: (context, value, child) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value.rows.toString()),
          IconButton(
            onPressed: gameNotifier.resetGame,
            icon: const Icon(Icons.restore),
          ),
          ListenableBuilder(
            listenable: value.timeSpend,
            builder: (context, child) => Text(
              value.timeSpend.value.inSeconds.toString(),
            ),
          )
        ],
      ),
    );
  }
}
