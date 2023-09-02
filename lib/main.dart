import 'package:flutter/material.dart';
import 'package:mines_sweeper/notifier/game_notifier.dart';
import 'package:mines_sweeper/notifier/is_player_tapping_notifier.dart';
import 'package:mines_sweeper/ui/game_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GameNotifierProvider(
      child: IsPlayerTappingNotifierProvider(
        child: MaterialApp(
          theme: ThemeData(
            fontFamily: 'MineSweeper',
          ),
          home: const GamePage(),
        ),
      ),
    );
  }
}
