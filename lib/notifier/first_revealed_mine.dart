import 'package:flutter/widgets.dart';
import 'package:mines_sweeper/game/cell.dart';

class FirstRevealedMine extends InheritedWidget {
  const FirstRevealedMine({
    required this.mine,
    required super.child,
  });

  final Cell? mine;

  @override
  bool updateShouldNotify(covariant FirstRevealedMine oldWidget) {
    return oldWidget.mine != mine;
  }

  static FirstRevealedMine of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FirstRevealedMine>()!;
  }
}
