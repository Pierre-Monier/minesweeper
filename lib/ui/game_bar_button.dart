import 'package:flutter/material.dart';
import 'package:mines_sweeper/ui/old_school_border.dart';

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
      child: GestureDetector(
        onTap: onPressed,
        child: SizedBox(
          width: 40,
          height: 40,
          child: icon,
        ),
      ),
    );
  }
}
