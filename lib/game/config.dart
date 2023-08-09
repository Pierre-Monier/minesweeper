class GameConfig {
  const GameConfig({
    required this.rows,
    required this.columns,
    required this.numberOfMines,
  });

  factory GameConfig.beginner() => const GameConfig(
        rows: 9,
        columns: 9,
        numberOfMines: 10,
      );

  factory GameConfig.intermediate() => const GameConfig(
        rows: 16,
        columns: 16,
        numberOfMines: 40,
      );

  factory GameConfig.expert() => const GameConfig(
        rows: 16,
        columns: 30,
        numberOfMines: 99,
      );

  final int rows;
  final int columns;
  final int numberOfMines;
}
