import 'package:flutter/material.dart';
import 'package:mines_sweeper/notifier/game.notifier.dart';
import 'package:mines_sweeper/ui/cell_tile.dart';

class GameBody extends StatelessWidget {
  const GameBody({required this.gameNotifier, super.key});

  final GameNotifier gameNotifier;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        // color: Colors.yellow,
        border: Border.all(color: Colors.yellow),
      ),
      child: ValueListenableBuilder(
        valueListenable: gameNotifier,
        builder: (context, value, child) => GridView.count(
          shrinkWrap: true,
          crossAxisCount: value.rows,
          children: value.cells
              .map(
                (e) => CellTile(
                  cell: e,
                  onCellTap: () => value.tapCell(e),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
