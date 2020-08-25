import 'dart:math';

/**
 * Unix epoch timestamp generator.
 *
 * This class is useful for stubbing in tests.
 */
abstract class TimestampService {
  static final TimestampService _instance = TimestampServiceImpl._();

  static TimestampService get instance => _instance;

  /// Returns the unix epoch timestamp in seconds
  String get timestampInSeconds;

  /// Returns a nonce (unique value for each request)
  String get nonce;
}

/**
 * Implementation of [TimestampService] using plain dart classes.
 */
class TimestampServiceImpl extends TimestampService {
  /**
   * Default constructor.
  */
  TimestampServiceImpl._() {
    this._clock = _Clock();
  }

  _Clock _clock;

  set clock(_Clock newClock) {
    this._clock = newClock;
  }

  int get ts => _clock.mills;

  @override
  String get nonce => (ts + _clock.randomInteger).toString();

  @override
  String get timestampInSeconds => ts.toString();
}

/**
 * Inner class that uses {@link System} for generating the timestamps.
*/
class _Clock {
  final Random _random = Random();
  int get mills => DateTime.now().millisecondsSinceEpoch ~/ 1000;
  int get randomInteger => _random.nextInt(1 << 32 - 1);
}
