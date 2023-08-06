import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:mines_sweeper/extension/list.dart';
import 'package:mines_sweeper/game/cell.dart';
import 'package:mines_sweeper/game/mine.dart';
import 'package:mines_sweeper/game/safe.dart';

class Game {
  Game({
    this.rows = _defaultNumberOfRows,
  }) : numberOfMines = rows {
    final cellsData = _generateCellsData(rows);
    cells = _generateCellsWithNeighbors(cellsData);
  }

  /// Number of rows in the game. Each row has the same number of cells.
  final int rows;

  /// Number of mines in the game.
  /// Default is the same as the number of rows.
  final int numberOfMines;

  late final List<Cell> cells;

  /// Start when first cell is tap
  final Stopwatch stopwatch = Stopwatch();

  /// Is not null when the game is lost
  ValueNotifier<Cell?> firstRevealedMine = ValueNotifier(null);

  static const _defaultNumberOfRows = 10;

  static List<Cell> _generateCellsWithNeighbors(List<List<Cell>> cellsData) {
    for (var y = 0; y < cellsData.length; y += 1) {
      for (var x = 0; x < cellsData[y].length; x += 1) {
        final cell = cellsData[x][y];
        cell.neighbors.addAll(
          _getCellNeighbors(position: (x: x, y: y), cellsData: cellsData),
        );
      }
    }

    return cellsData.reduce((value, element) => [...value, ...element]);
  }

  static List<Cell> _getCellNeighbors({
    required ({int x, int y}) position,
    required List<List<Cell>> cellsData,
  }) {
    final possibleNeighbors = [
      cellsData
          .safeElementAtOrNull(position.x - 1)
          ?.safeElementAtOrNull(position.y - 1),
      cellsData
          .safeElementAtOrNull(position.x)
          ?.safeElementAtOrNull(position.y - 1),
      cellsData
          .safeElementAtOrNull(position.x + 1)
          ?.safeElementAtOrNull(position.y - 1),
      cellsData
          .safeElementAtOrNull(position.x - 1)
          ?.safeElementAtOrNull(position.y),
      cellsData
          .safeElementAtOrNull(position.x + 1)
          ?.safeElementAtOrNull(position.y),
      cellsData
          .safeElementAtOrNull(position.x - 1)
          ?.safeElementAtOrNull(position.y + 1),
      cellsData
          .safeElementAtOrNull(position.x)
          ?.safeElementAtOrNull(position.y + 1),
      cellsData
          .safeElementAtOrNull(position.x + 1)
          ?.safeElementAtOrNull(position.y + 1),
    ];

    return possibleNeighbors.whereNotNull().toList();
  }

  static List<List<Cell>> _generateCellsData(int rows) {
    final cellsConfiguration = List.generate(
      rows * rows,
      (index) => index < rows ? Mine() : Safe(),
    );
    cellsConfiguration.shuffle();

    final cellsData = <List<Cell>>[];
    for (var i = 0; i < rows; i += 1) {
      final startIndex = i * rows;
      final endIndex = (i + 1) * rows;

      cellsData.add(cellsConfiguration.sublist(startIndex, endIndex));
    }

    return cellsData;
  }

  void tapCell(Cell cell) {
    if (cell.displayMode.value == DisplayMode.revealed ||
        firstRevealedMine.value != null) {
      return;
    }

    _handleStartGame();

    cell.reveal();

    _handleEndGame();
  }

  void _handleStartGame() {
    if (!stopwatch.isRunning) {
      stopwatch.start();
    }
  }

  void _handleEndGame() {
    firstRevealedMine.value = cells.firstWhereOrNull(
      (e) => e is Mine && e.displayMode.value == DisplayMode.revealed,
    );

    if (firstRevealedMine.value != null) {
      stopwatch.stop();
    }
  }
}
