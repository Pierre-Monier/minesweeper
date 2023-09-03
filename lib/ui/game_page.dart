import 'package:flutter/material.dart';
import 'package:mines_sweeper/ui/game_scene.dart';
import 'package:mines_sweeper/ui/game_selector.dart';
import 'package:mines_sweeper/ui/theme/color.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GameColor.background,
      body: _BothDirectionScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.sizeOf(context).width,
            ),
            child: const IntrinsicHeight(
              child: Column(
                children: [
                  Flexible(child: GameSelector()),
                  SizedBox(
                    height: 16,
                  ),
                  GameScene(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BothDirectionScrollView extends StatelessWidget {
  const _BothDirectionScrollView({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: child,
      ),
    );
  }
}
