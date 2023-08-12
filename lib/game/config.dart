sealed class GameConfig {
  const GameConfig({
    required this.rows,
    required this.columns,
    required this.numberOfMines,
  });

  final int rows;
  final int columns;
  final int numberOfMines;
}

class BeginnerConfig extends GameConfig {
  BeginnerConfig({super.rows = 9, super.columns = 9, super.numberOfMines = 10});
}

class IntermediateConfig extends GameConfig {
  IntermediateConfig({
    super.rows = 16,
    super.columns = 16,
    super.numberOfMines = 40,
  });
}

class ExpertConfig extends GameConfig {
  ExpertConfig({
    super.rows = 16,
    super.columns = 30,
    super.numberOfMines = 99,
  });
}

class CustomConfig extends GameConfig {
  CustomConfig({
    required super.rows,
    required super.columns,
    required super.numberOfMines,
  });
}
