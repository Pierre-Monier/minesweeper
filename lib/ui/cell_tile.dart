import 'package:flutter/material.dart';
import 'package:mines_sweeper/game/cell.dart';
import 'package:mines_sweeper/game/game.dart';
import 'package:mines_sweeper/game/mine.dart';
import 'package:mines_sweeper/notifier/first_revealed_mine.dart';
import 'package:mines_sweeper/notifier/game.notifier.dart';

class CellTile extends StatelessWidget {
  const CellTile({
    required this.cell,
    required this.onCellTap,
    super.key,
  });

  final VoidCallback onCellTap;
  final Cell cell;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: cell.displayMode,
      builder: (context, value, child) {
        switch (value) {
          case DisplayMode.hidden:
            return _HiddenCellTile(
              onCellTap: onCellTap,
            );
          case DisplayMode.revealed:
            return _RevealCellTile(cell: cell);
          case DisplayMode.flagged:
            return _FlagCellTile(
              cell: cell,
            );
          case DisplayMode.questioned:
            return _QuestionCellTile(cell: cell);
        }
      },
    );
  }
}

class _HiddenCellTile extends StatelessWidget {
  const _HiddenCellTile({required this.onCellTap});

  final VoidCallback onCellTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCellTap,
      child: const SizedBox.shrink(),
    );
  }
}

class _RevealCellTile extends StatelessWidget {
  const _RevealCellTile({required this.cell});

  final Cell cell;

  @override
  Widget build(BuildContext context) {
    final firstRevealedMine = FirstRevealedMine.of(context).mine;

    return ColoredBox(
      color: cell == firstRevealedMine ? Colors.red : Colors.transparent,
      child: Text(
        cell is Mine ? 'X' : cell.minesAround.toString(),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _FlagCellTile extends StatelessWidget {
  const _FlagCellTile({required this.cell});

  final Cell cell;

  @override
  Widget build(BuildContext context) {
    return _ToggleCellTile(
      cell: cell,
      icon: const Icon(Icons.flag),
      onPressed: (game, gameMove) =>
          gameMove == GameMove.flag ? () => game.tapCell(cell) : null,
    );
  }
}

class _QuestionCellTile extends StatelessWidget {
  const _QuestionCellTile({required this.cell});

  final Cell cell;

  @override
  Widget build(BuildContext context) {
    return _ToggleCellTile(
      cell: cell,
      icon: const Icon(Icons.question_mark),
      onPressed: (game, gameMove) =>
          gameMove == GameMove.question ? () => game.tapCell(cell) : null,
    );
  }
}

class _ToggleCellTile extends StatelessWidget {
  const _ToggleCellTile({
    required this.cell,
    required this.icon,
    required this.onPressed,
  });

  final Cell cell;

  final Widget icon;

  final VoidCallback? Function(Game game, GameMove gameMove) onPressed;

  @override
  Widget build(BuildContext context) {
    final game = GameNotifierProvider.of(context).gameNotifier.value;

    return ValueListenableBuilder(
      valueListenable: game.gameMove,
      builder: (context, gameMove, child) => IconButton(
        onPressed: onPressed(game, gameMove),
        icon: icon,
      ),
    );
  }
}
