import 'package:flutter/material.dart';

class IsPlayerTappingNotifier extends ValueNotifier<bool> {
  IsPlayerTappingNotifier() : super(false);

  void startTapping() {
    value = true;
  }

  void stopTapping() {
    value = false;
  }
}

class IsPlayerTappingNotifierProvider extends InheritedWidget {
  IsPlayerTappingNotifierProvider({
    super.key,
    required super.child,
  });

  final isPlayerTappingNotifier = IsPlayerTappingNotifier();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static IsPlayerTappingNotifier of(BuildContext context) {
    final IsPlayerTappingNotifierProvider? result = context
        .dependOnInheritedWidgetOfExactType<IsPlayerTappingNotifierProvider>();
    assert(
      result != null,
      'No IsPlayerTappingNotifierProvider found in context',
    );

    return result!.isPlayerTappingNotifier;
  }
}
