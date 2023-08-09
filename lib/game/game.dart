import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:mines_sweeper/extension/list.dart';
import 'package:mines_sweeper/game/cell.dart';
import 'package:mines_sweeper/game/mine.dart';
import 'package:mines_sweeper/game/safe.dart';
import 'package:mines_sweeper/notifier/time_spend_notifier.dart';

// TODO(Pierre): Game should have type (beguiner, intermediate, expert and custom)
// TODO(Pierre): game can have columns different than rows
// TODO(Pierre): Number of mine should be different than number of rows
// TODO(Pierre): game should display number of mine - number of flagged cells
// TODO(Pierre): flag should happen on right click
// TODO(Pierre): flagged cell that are not mine should be displayed as wrong when game is lost
// TODO(pierre): OldSchoolBorder should act a bit differently when tapped
class Game {
  Game({
    this.rows = _defaultNumberOfRows,
  }) : numberOfMines = rows + 1 {
    final cellsData = _generateCellsData(rows, numberOfMines);
    cells = _generateCellsWithNeighbors(cellsData);
  }

  /// Number of rows in the game. Each row has the same number of cells.
  final int rows;

  /// Number of mines in the game.
  /// Default is the same as the number of rows.
  final int numberOfMines;

  late final List<Cell> cells;

  /// Start when first cell is tap
  final TimeSpendNotifier timeSpend = TimeSpendNotifier(Duration.zero);

  /// Is not null when the game is lost
  final ValueNotifier<GameStatus> gameStatus =
      ValueNotifier(GameStatus.onGoing);

  /// Used to know on which mine we should put a red background
  final ValueNotifier<Cell?> firstRevealedMine = ValueNotifier(null);

  final ValueNotifier<GameMove> gameMove = ValueNotifier(GameMove.reveal);

  static const _defaultNumberOfRows = 9;

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

  static List<List<Cell>> _generateCellsData(int rows, int numberOfMines) {
    final cellsConfiguration = List.generate(
      rows * rows,
      (index) => index < numberOfMines ? Mine() : Safe(),
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
        gameStatus.value != GameStatus.onGoing) {
      return;
    }

    _handleStartGame();

    _actOnCell(cell);

    _handleEndGame();
  }

  void _actOnCell(Cell cell) {
    switch (gameMove.value) {
      case GameMove.reveal:
        cell.reveal();
      case GameMove.flag:
        cell.toggleFlag();
      case GameMove.question:
        cell.toggleQuestion();
    }
  }

  void _handleStartGame() {
    if (!timeSpend.isRunning) {
      timeSpend.start();
    }
  }

  void _handleEndGame() {
    if (!_isGameEnd) {
      _handleGameWin();
    }

    if (!_isGameEnd) {
      _handleGameFailure();
    }
  }

  void _handleGameWin() {
    final revealedSafeCell = cells
        .where((e) => e is Safe && e.displayMode.value == DisplayMode.revealed);

    final hasWin = revealedSafeCell.length == cells.length - numberOfMines;

    if (hasWin) {
      _endGame(GameStatus.win);
    }
  }

  void _handleGameFailure() {
    final revealedMine = cells.firstWhereOrNull(
      (e) => e is Mine && e.displayMode.value == DisplayMode.revealed,
    );

    if (revealedMine == null) return;

    _endGame(GameStatus.loose);
    firstRevealedMine.value = revealedMine;

    final everyNonRevealedMine =
        cells.where((e) => e is Mine && e != firstRevealedMine.value);

    for (final mine in everyNonRevealedMine) {
      mine.reveal();
    }
  }

  void _endGame(GameStatus newStatus) {
    assert(
      newStatus != GameStatus.onGoing,
      "You should not end game with onGoing status",
    );

    timeSpend.stop();
    gameStatus.value = newStatus;
  }

  void toggleFlag() {
    gameMove.value =
        gameMove.value == GameMove.flag ? GameMove.reveal : GameMove.flag;
  }

  void toggleQuestion() {
    gameMove.value = gameMove.value == GameMove.question
        ? GameMove.reveal
        : GameMove.question;
  }

  bool get _isGameEnd => gameStatus.value != GameStatus.onGoing;
}

enum GameStatus { onGoing, loose, win }

enum GameMove { reveal, flag, question }
