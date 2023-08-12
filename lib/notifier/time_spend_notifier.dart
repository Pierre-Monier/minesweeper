import 'dart:async';

import 'package:flutter/foundation.dart';

class TimeSpendNotifier extends ValueNotifier<Duration> {
  TimeSpendNotifier() : super(Duration.zero);

  Timer? _timer;

  void start() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      value = Duration(seconds: timer.tick);
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  bool get isRunning => _timer != null;
}
