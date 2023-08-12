import 'package:flutter/widgets.dart';
import 'package:mines_sweeper/game/config.dart';
import 'package:mines_sweeper/game/game.dart';

class GameNotifier extends ValueNotifier<Game> {
  GameNotifier(super.value);

  void resetGame() {
    value = Game();
  }

  void updateConfig(GameConfig newConfig) {
    value = Game(config: newConfig);
  }
}

class GameNotifierProvider extends InheritedWidget {
  GameNotifierProvider({required super.child});

  final gameNotifier = GameNotifier(Game());

  @override
  bool updateShouldNotify(covariant GameNotifierProvider oldWidget) {
    return false;
  }

  static GameNotifierProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GameNotifierProvider>()!;
  }
}
