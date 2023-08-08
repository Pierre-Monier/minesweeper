import 'package:flutter/material.dart';
import 'package:mines_sweeper/notifier/game.notifier.dart';
import 'package:mines_sweeper/ui/game_bar.dart';
import 'package:mines_sweeper/ui/game_body.dart';
import 'package:mines_sweeper/ui/theme/color.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GameNotifierProvider(
      child: const Scaffold(
        backgroundColor: GameColor.backgroundColor,
        body: Column(
          children: [
            GameBar(),
            SizedBox(
              height: 16,
            ),
            GameBody()
          ],
        ),
      ),
    );
  }
}
