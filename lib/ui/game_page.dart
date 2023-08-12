import 'package:flutter/material.dart';
import 'package:mines_sweeper/notifier/game.notifier.dart';
import 'package:mines_sweeper/ui/game_scene.dart';
import 'package:mines_sweeper/ui/game_selector.dart';
import 'package:mines_sweeper/ui/theme/color.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GameNotifierProvider(
      child: Scaffold(
        backgroundColor: GameColor.background,
        body: InteractiveViewer(
          minScale: 1.0,
          child: const Center(
            child: Column(
              children: [
                Flexible(child: GameSelector()),
                SizedBox(
                  height: 16,
                ),
                GameScene()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
