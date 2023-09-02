import 'package:flutter/widgets.dart';
import 'package:mines_sweeper/game/config.dart';
import 'package:mines_sweeper/game/game.dart';

class GameNotifier extends ValueNotifier<Game> {
  GameNotifier() : super(Game(config: _defaultConfig));

  GameConfig config = _defaultConfig;

  static final _defaultConfig = BeginnerConfig();

  void resetGame() {
    value = Game(config: config);
  }

  void updateConfig(GameConfig newConfig) {
    config = newConfig;
    value = Game(config: config);
  }
}

class GameNotifierProvider extends InheritedWidget {
  GameNotifierProvider({required super.child});

  final gameNotifier = GameNotifier();

  @override
  bool updateShouldNotify(covariant GameNotifierProvider oldWidget) {
    return false;
  }

  static GameNotifier of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GameNotifierProvider>()!
        .gameNotifier;
  }
}
