import 'package:flutter/material.dart';
import 'package:mines_sweeper/game/config.dart';
import 'package:mines_sweeper/notifier/game.notifier.dart';
import 'package:mines_sweeper/ui/theme/typographie.dart';

class GameSelector extends StatelessWidget {
  const GameSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final gameNotifier = GameNotifierProvider.of(context).gameNotifier;

    return ValueListenableBuilder(
      valueListenable: gameNotifier,
      builder: (context, game, child) => Wrap(
        children: [
          SizedBox(
            child: TextButton(
              onPressed: () {
                gameNotifier.updateConfig(BeginnerConfig());
              },
              child: Text(
                'Beginner',
                style: GameTypographie.gameSelectorStyle.copyWith(
                  decorationThickness: 4.0,
                  decoration: game.config is BeginnerConfig
                      ? TextDecoration.underline
                      : null,
                ),
              ),
            ),
          ),
          SizedBox(
            child: TextButton(
              onPressed: () {
                gameNotifier.updateConfig(IntermediateConfig());
              },
              child: Text(
                'Intermediate',
                style: GameTypographie.gameSelectorStyle.copyWith(
                  decorationThickness: 4.0,
                  decoration: game.config is IntermediateConfig
                      ? TextDecoration.underline
                      : null,
                ),
              ),
            ),
          ),
          SizedBox(
            child: TextButton(
              onPressed: () {
                gameNotifier.updateConfig(ExpertConfig());
              },
              child: Text(
                'Expert',
                style: GameTypographie.gameSelectorStyle.copyWith(
                  decorationThickness: 4.0,
                  decoration: game.config is ExpertConfig
                      ? TextDecoration.underline
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
