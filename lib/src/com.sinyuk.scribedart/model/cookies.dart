/**
 * An HTTP cookie is a small piece of data stored on the local storage by the applcation. 
 */
abstract class Cookie<T> {
  String name;
  String domain;
  DateTime createdAt;

  T value = null;
  String path = null;

  /// `expires` == 0: expired;`expires` < 0: never expires;
  int expires = -1;
  bool hasExpired = false;
  bool httponly = false;
  bool secure = false;
}
