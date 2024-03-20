extension <T> on Iterable<T> {
  Iterable<T> applyWhere(bool Function(T element) test, T Function(T element) apply) {
    return this.map((e) {
      if (test(e)) return apply(e);
      else return e;
    });
  }

  int countIf(bool Function(T element) test) => this.where(test).length;

  int count(T item) => this.where((element) => element == item).length;
}

extension NullCheck<T> on Iterable<T?> {
  int countNull() => this.where((element) => element == null).length;
}

extension on Iterable<String> {
  Iterable<String> splitMapJoin(Pattern separator, {int? start, int? end}) {
    return this.toList()
    .getRange(start ?? 0, end ?? this.length)
    .map((e) => e.split(separator))
    .fold([], (previousValue, element) => previousValue.followedBy(element));
  }

  Iterable<String> splitMapJoinWhere(Pattern separator, bool Function(String element) test, {int? start, int? end}) {
    return this;
  }
}