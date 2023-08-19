import 'package:flutter/material.dart';
import 'package:mines_sweeper/ui/old_school_border.dart';
import 'package:mines_sweeper/ui/theme/size.dart';

class GameBarButton extends StatelessWidget {
  const GameBarButton({
    required this.onPressed,
    required this.icon,
    super.key,
  });

  final VoidCallback onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return OldSchoolBorder(
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: GameSizes.gameBarItem,
          height: GameSizes.gameBarItem,
          child: icon,
        ),
      ),
    );
  }
}
