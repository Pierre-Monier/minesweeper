import 'package:flutter/material.dart';
import 'package:mines_sweeper/notifier/game.notifier.dart';
import 'package:mines_sweeper/ui/game_bar.dart';
import 'package:mines_sweeper/ui/game_body.dart';
import 'package:mines_sweeper/ui/game_selector.dart';
import 'package:mines_sweeper/ui/theme/color.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GameNotifierProvider(
      child: Scaffold(
        backgroundColor: GameColor.backgroundColor,
        body: InteractiveViewer(
          minScale: 1.0,
          child: const Column(
            children: [
              Flexible(child: GameSelector()),
              SizedBox(
                height: 16,
              ),
              GameBar(),
              SizedBox(
                height: 16,
              ),
              GameBody()
            ],
          ),
        ),
      ),
    );
  }
}
