import 'package:flutter/material.dart';
import 'package:mines_sweeper/game/cell.dart';
import 'package:mines_sweeper/game/game.dart';
import 'package:mines_sweeper/notifier/first_revealed_mine.dart';
import 'package:mines_sweeper/notifier/game.notifier.dart';
import 'package:mines_sweeper/ui/game_bar.dart';
import 'package:mines_sweeper/ui/game_body.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<GamePage> {
  final _gameNotifier = GameNotifier(Game());
  Cell? _firstRevealedMine;

  void _onFirstMineRevealedChange() {
    setState(() {
      _firstRevealedMine = _game.firstRevealedMine.value;
    });
  }

  void _onGameChange() {
    _game.firstRevealedMine.addListener(_onFirstMineRevealedChange);
    setState(() {
      _firstRevealedMine = null;
    });
  }

  @override
  void initState() {
    _game.firstRevealedMine.addListener(_onFirstMineRevealedChange);
    _gameNotifier.addListener(_onGameChange);
    super.initState();
  }

  @override
  void dispose() {
    _gameNotifier.value.gameStatus.removeListener(_onFirstMineRevealedChange);
    _gameNotifier.removeListener(_onGameChange);
    super.dispose();
  }

  Game get _game => _gameNotifier.value;

  @override
  Widget build(BuildContext context) {
    return FirstRevealedMine(
      mine: _firstRevealedMine,
      child: Scaffold(
        body: Column(
          children: [
            GameBar(gameNotifier: _gameNotifier),
            const SizedBox(
              height: 16,
            ),
            GameBody(gameNotifier: _gameNotifier)
          ],
        ),
      ),
    );
  }
}
