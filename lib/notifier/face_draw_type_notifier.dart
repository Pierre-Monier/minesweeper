import 'package:flutter/material.dart';
import 'package:mines_sweeper/game/game.dart';
import 'package:mines_sweeper/notifier/is_player_tapping_notifier.dart';

enum FaceDrawType {
  happy,
  dead,
  cool,
  surprised,
}

class FaceDrawTypeNotifier extends ValueNotifier<FaceDrawType> {
  FaceDrawTypeNotifier({
    required this.gameStatus,
    required this.isPlayerTappingNotifier,
  }) : super(FaceDrawType.happy) {
    gameStatus.addListener(_updateFaceDrawType);
    isPlayerTappingNotifier.addListener(_updateBasedOnPlayerTapping);
  }

  final ValueNotifier<GameStatus> gameStatus;
  final IsPlayerTappingNotifier isPlayerTappingNotifier;

  void _updateFaceDrawType() {
    switch (gameStatus.value) {
      case GameStatus.onGoing:
        value = FaceDrawType.happy;
      case GameStatus.win:
        value = FaceDrawType.cool;
      case GameStatus.loose:
        value = FaceDrawType.dead;
    }
  }

  void _updateBasedOnPlayerTapping() {
    if (isPlayerTappingNotifier.value) {
      value = FaceDrawType.surprised;
    } else {
      _updateFaceDrawType();
    }
  }

  @override
  void dispose() {
    gameStatus.removeListener(_updateFaceDrawType);
    isPlayerTappingNotifier.removeListener(_updateBasedOnPlayerTapping);
    super.dispose();
  }
}
