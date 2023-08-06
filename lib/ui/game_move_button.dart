import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mines_sweeper/game/game.dart';

class GameMoveButton extends StatelessWidget {
  const GameMoveButton({
    required this.gameMove,
    required this.activeGameMove,
    required this.onPressed,
    required this.icon,
    super.key,
  });

  final ValueListenable<GameMove> gameMove;
  final GameMove activeGameMove;
  final VoidCallback onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: gameMove,
      builder: (context, gameMove, _) => IconButton(
        color: gameMove == activeGameMove ? Colors.yellow : null,
        onPressed: onPressed,
        icon: icon,
      ),
    );
  }
}
