class TimeTest {
  static int test(Function func) {
    Stopwatch stopwatch = Stopwatch();
    stopwatch.start();
    func();
    stopwatch.stop();
    return stopwatch.elapsedMilliseconds;
  }
}