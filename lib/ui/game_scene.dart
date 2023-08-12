import 'package:flutter/widgets.dart';
import 'package:mines_sweeper/notifier/game.notifier.dart';
import 'package:mines_sweeper/ui/game_bar.dart';
import 'package:mines_sweeper/ui/game_body.dart';
import 'package:mines_sweeper/ui/old_school_border.dart';

class GameScene extends StatefulWidget {
  const GameScene({super.key});

  @override
  State<GameScene> createState() => _GameSceneState();
}

class _GameSceneState extends State<GameScene> {
  final _bodyKey = GlobalKey();
  double? _gameBarWidth;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getGameBarWidth();
    });
    super.initState();
  }

  void _getGameBarWidth() {
    final bodyRenderBox =
        _bodyKey.currentContext?.findRenderObject() as RenderBox?;

    if (bodyRenderBox == null || bodyRenderBox.hasSize == false) return;

    setState(() {
      _gameBarWidth = bodyRenderBox.size.width;
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameNotifier = GameNotifierProvider.of(context).gameNotifier;

    return ListenableBuilder(
      listenable: gameNotifier,
      builder: (context, child) {
        Future.microtask(
          () => _getGameBarWidth(),
        );

        return OldSchoolBorder(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                OldSchoolBorder(
                  isReversed: true,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: _gameBarWidth ?? double.infinity,
                    ),
                    child: const GameBar(),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                OldSchoolBorder(
                  isReversed: true,
                  child: GameBody(
                    key: _bodyKey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
