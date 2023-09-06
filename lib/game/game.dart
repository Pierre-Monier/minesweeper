import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:mines_sweeper/extension/list.dart';
import 'package:mines_sweeper/game/cell.dart';
import 'package:mines_sweeper/game/config.dart';
import 'package:mines_sweeper/game/mine.dart';
import 'package:mines_sweeper/game/safe.dart';
import 'package:mines_sweeper/notifier/time_spend_notifier.dart';

// TODO(Pierre): handle mobile devices
// Add a pixelated effect on draw
class Game {
  Game({
    GameConfig? config,
  }) : config = config ?? BeginnerConfig() {
    final cellsData = _generateCellsData(this.config);
    cells = _generateCellsWithNeighbors(cellsData);
  }

  final GameConfig config;

  late final List<List<Cell>> cells;

  @visibleForTesting
  List<Cell> get everyCells =>
      cells.reduce((value, element) => [...value, ...element]);

  /// Start when first cell is tap
  final TimeSpendNotifier timeSpend = TimeSpendNotifier();

  /// Is not null when the game is lost
  final ValueNotifier<GameStatus> gameStatus =
      ValueNotifier(GameStatus.onGoing);

  /// Used to know on which mine we should put a red background
  final ValueNotifier<Cell?> firstRevealedMine = ValueNotifier(null);

  late final ValueNotifier<int> remainingMines = ValueNotifier(
    _remainingMines,
  );

  int get _remainingMines =>
      config.numberOfMines -
      everyCells
          .where((cell) => cell.displayMode.value == DisplayMode.flagged)
          .length;

  static List<List<Cell>> _generateCellsWithNeighbors(
    List<List<Cell>> cellsData,
  ) {
    for (var y = 0; y < cellsData.length; y += 1) {
      for (var x = 0; x < cellsData[y].length; x += 1) {
        final cell = cellsData[y][x];
        cell.neighbors.addAll(
          _getCellNeighbors(position: (x: x, y: y), cellsData: cellsData),
        );
      }
    }

    return cellsData;
  }

  static List<Cell> _getCellNeighbors({
    required ({int x, int y}) position,
    required List<List<Cell>> cellsData,
  }) {
    final possibleNeighbors = [
      cellsData
          .safeElementAtOrNull(position.y - 1)
          ?.safeElementAtOrNull(position.x - 1),
      cellsData
          .safeElementAtOrNull(position.y)
          ?.safeElementAtOrNull(position.x - 1),
      cellsData
          .safeElementAtOrNull(position.y + 1)
          ?.safeElementAtOrNull(position.x - 1),
      cellsData
          .safeElementAtOrNull(position.y - 1)
          ?.safeElementAtOrNull(position.x),
      cellsData
          .safeElementAtOrNull(position.y + 1)
          ?.safeElementAtOrNull(position.x),
      cellsData
          .safeElementAtOrNull(position.y - 1)
          ?.safeElementAtOrNull(position.x + 1),
      cellsData
          .safeElementAtOrNull(position.y)
          ?.safeElementAtOrNull(position.x + 1),
      cellsData
          .safeElementAtOrNull(position.y + 1)
          ?.safeElementAtOrNull(position.x + 1),
    ];

    return possibleNeighbors.whereNotNull().toList();
  }

  static List<List<Cell>> _generateCellsData(GameConfig config) {
    final cellsConfiguration = List.generate(
      config.rows * config.columns,
      (index) => index < config.numberOfMines ? Mine() : Safe(),
    );
    cellsConfiguration.shuffle();

    final cellsData = <List<Cell>>[];
    for (var i = 0; i < config.rows; i += 1) {
      final startIndex = i * config.columns;
      final endIndex = (i + 1) * config.columns;

      cellsData.add(cellsConfiguration.sublist(startIndex, endIndex));
    }

    return cellsData;
  }

  void tapCell(Cell cell, {GameMove gameMove = GameMove.reveal}) {
    if (cell.displayMode.value == DisplayMode.revealed ||
        gameStatus.value != GameStatus.onGoing) {
      return;
    }

    _handleStartGame();

    _actOnCell(cell, gameMove: gameMove);

    _handleEndGame();
  }

  void _actOnCell(Cell cell, {required GameMove gameMove}) {
    switch (gameMove) {
      case GameMove.reveal:
        cell.reveal();
      case GameMove.flag:
        cell.toggleFlag();
        remainingMines.value = _remainingMines;
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
    final revealedSafeCell = everyCells
        .where((e) => e is Safe && e.displayMode.value == DisplayMode.revealed);

    final hasWin =
        revealedSafeCell.length == everyCells.length - config.numberOfMines;

    if (hasWin) {
      _endGame(GameStatus.win);
    }
  }

  void _handleGameFailure() {
    final revealedMine = everyCells.firstWhereOrNull(
      (e) => e is Mine && e.displayMode.value == DisplayMode.revealed,
    );

    if (revealedMine == null) return;

    _endGame(GameStatus.loose);
    firstRevealedMine.value = revealedMine;

    final everyNonRevealedMine =
        everyCells.where((e) => e is Mine && e != firstRevealedMine.value);

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

  bool get _isGameEnd => gameStatus.value != GameStatus.onGoing;
}

enum GameStatus { onGoing, loose, win }

enum GameMove { reveal, flag }
