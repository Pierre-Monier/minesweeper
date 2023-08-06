import 'package:flutter/foundation.dart';
import 'package:mines_sweeper/game/game.dart';

class GameNotifier extends ValueNotifier<Game> {
  GameNotifier(super.value);

  void resetGame() {
    value = Game();
  }
}
