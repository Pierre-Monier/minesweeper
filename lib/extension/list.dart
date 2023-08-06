extension SafeElementAtOrNull<T> on List<T> {
  T? safeElementAtOrNull(int index) {
    try {
      return elementAtOrNull(index);
      // ignore: avoid_catching_errors
    } on RangeError {
      return null;
    }
  }
}

extension ContainsAll<T> on List<T> {
  bool containsAll(Iterable<T> elements) {
    return elements.every((element) => contains(element));
  }
}
