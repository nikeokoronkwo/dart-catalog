extension Toggle on bool {
  bool toggle() {
    return !this;
  }

  int toInt() {
    return this ? 1 : 0;
  }
}
