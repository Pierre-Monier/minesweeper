import 'package:flutter/material.dart';
import 'package:mines_sweeper/game/game.dart';
import 'package:mines_sweeper/game/mine.dart';
import 'package:mines_sweeper/notifier/game.notifier.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _gameNotifier.resetGame,
        tooltip: 'Reset game',
        child: const Icon(Icons.restore),
      ),
      body: ValueListenableBuilder(
        valueListenable: _gameNotifier,
        builder: (context, value, child) => GridView.count(
          crossAxisCount: value.rows,
          children: value.cells
              .map(
                (e) => ColoredBox(
                  color: e is Mine ? Colors.red : Colors.transparent,
                  child: Text(
                    e.runtimeType.toString(),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
