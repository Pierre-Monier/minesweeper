// App only run on web
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' hide VoidCallback;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mines_sweeper/game/cell.dart';
import 'package:mines_sweeper/game/game.dart';
import 'package:mines_sweeper/game/mine.dart';
import 'package:mines_sweeper/game/safe.dart';
import 'package:mines_sweeper/notifier/first_revealed_mine.dart';
import 'package:mines_sweeper/notifier/game_notifier.dart';
import 'package:mines_sweeper/ui/draw/flag_draw.dart';
import 'package:mines_sweeper/ui/draw/mine_draw.dart';
import 'package:mines_sweeper/ui/old_school_border.dart';
import 'package:mines_sweeper/ui/theme/color.dart';
import 'package:mines_sweeper/ui/theme/size.dart';
import 'package:mines_sweeper/ui/theme/typographie.dart';

class CellTile extends StatelessWidget {
  const CellTile({
    required this.cell,
    required this.onCellTap,
    required this.onFlagCellTap,
    super.key,
  });

  final VoidCallback? onCellTap;
  final VoidCallback? onFlagCellTap;
  final Cell cell;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: GameSizes.cell,
      height: GameSizes.cell,
      decoration: BoxDecoration(
        border: Border.all(color: GameColor.cellBorder, width: 0.5),
      ),
      child: ValueListenableBuilder(
        valueListenable: cell.displayMode,
        builder: (context, displayMode, child) {
          if (displayMode != DisplayMode.revealed) {
            return _HiddenCellTile(
              cell: cell,
              onFlagCellTap: onFlagCellTap,
              onCellTap: onCellTap,
            );
          }
          return _RevealCellTile(cell: cell);
        },
      ),
    );
  }
}

class _HiddenCellTile extends StatelessWidget {
  const _HiddenCellTile({
    required this.onCellTap,
    required this.onFlagCellTap,
    required this.cell,
  });

  final Cell cell;
  final VoidCallback? onCellTap;
  final VoidCallback? onFlagCellTap;

  Color _getBackgroundColor(GameStatus gameStatus) {
    if (gameStatus != GameStatus.loose) return Colors.transparent;

    final isWrongFlag =
        cell is Safe && cell.displayMode.value == DisplayMode.flagged;

    return isWrongFlag ? GameColor.wrongFlag : Colors.transparent;
  }

  bool get isFlagged => cell.displayMode.value == DisplayMode.flagged;

  @override
  Widget build(BuildContext context) {
    final game = GameNotifierProvider.of(context).gameNotifier.value;

    return OldSchoolBorder(
      isTapEnabled: onCellTap != null && !isFlagged,
      child: ValueListenableBuilder(
        valueListenable: game.gameStatus,
        builder: (context, gameStatus, child) => ColoredBox(
          color: _getBackgroundColor(gameStatus),
          child: _FlagTap(
            onFlagCell: onFlagCellTap,
            child: InkWell(
              onTap: isFlagged ? null : onCellTap,
              child: isFlagged ? const FlagDraw() : const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}

class _FlagTap extends StatefulWidget {
  const _FlagTap({required this.child, required this.onFlagCell});

  final Widget child;
  final VoidCallback? onFlagCell;

  @override
  State<_FlagTap> createState() => _FlagTapState();
}

class _FlagTapState extends State<_FlagTap> {
  @override
  void initState() {
    document.onContextMenu.listen((event) => event.preventDefault());
    super.initState();
  }

  bool isOnMobileDevice() {
    final userAgent = window.navigator.userAgent.toLowerCase();

    return userAgent.contains("iphone") ||
        userAgent.contains("android") ||
        userAgent.contains("ipad");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown:
          isOnMobileDevice() ? null : (_) => widget.onFlagCell?.call(),
      onLongPressDown:
          isOnMobileDevice() ? (_) => widget.onFlagCell?.call() : null,
      child: widget.child,
    );
  }
}

class _RevealCellTile extends StatelessWidget {
  const _RevealCellTile({required this.cell});

  final Cell cell;

  String get _minesAroundText =>
      cell.minesAround > 0 ? cell.minesAround.toString() : '';

  Color? get _minesAroundTextColor =>
      cell.minesAround > 0 ? GameColor.minesAround[cell.minesAround - 1] : null;

  @override
  Widget build(BuildContext context) {
    final firstRevealedMine = FirstRevealedMine.of(context).mine;

    final content = cell is Mine
        ? const SizedBox(
            width: GameSizes.cell,
            height: GameSizes.cell,
            child: MineDraw(),
          )
        : AutoSizeText(
            _minesAroundText,
            textAlign: TextAlign.center,
            style: GameTypographie.cellTextStyle.copyWith(
              color: _minesAroundTextColor,
            ),
          );

    return ColoredBox(
      color: cell == firstRevealedMine ? Colors.red : Colors.transparent,
      child: Align(
        child: content,
      ),
    );
  }
}
