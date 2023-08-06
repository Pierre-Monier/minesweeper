import 'package:flutter/material.dart';
import 'package:mines_sweeper/game/cell.dart';
import 'package:mines_sweeper/game/game.dart';
import 'package:mines_sweeper/notifier/first_revealed_mine.dart';
import 'package:mines_sweeper/notifier/game.notifier.dart';
import 'package:mines_sweeper/ui/cell_tile.dart';
import 'package:mines_sweeper/ui/game_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Mine sweeper'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _gameNotifier.resetGame,
          tooltip: 'Reset game',
          child: const Icon(Icons.restore),
        ),
        body: Column(
          children: [
            GameBar(gameNotifier: _gameNotifier),
            const SizedBox(
              height: 16,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                // color: Colors.yellow,
                border: Border.all(color: Colors.yellow),
              ),
              child: ValueListenableBuilder(
                valueListenable: _gameNotifier,
                builder: (context, value, child) => GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: value.rows,
                  children: value.cells
                      .map(
                        (e) => CellTile(
                          cell: e,
                          onCellTap: () => value.tapCell(e),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
