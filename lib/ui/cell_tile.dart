import 'package:flutter/material.dart';
import 'package:mines_sweeper/game/cell.dart';
import 'package:mines_sweeper/game/mine.dart';

class CellTile extends StatelessWidget {
  const CellTile({required this.cell, required this.onCellTap, super.key});

  final VoidCallback onCellTap;
  final Cell cell;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: cell.displayMode,
      builder: (context, value, child) => value == DisplayMode.hidden
          ? _HiddenCellTile(
              onCellTap: onCellTap,
            )
          : _RevealCellTile(cell: cell),
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
    return ColoredBox(
      color: cell is Mine ? Colors.red : Colors.transparent,
      child: Text(cell.minesAround.toString()),
    );
  }
}
