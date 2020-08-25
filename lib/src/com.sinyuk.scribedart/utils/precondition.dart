/// Throws an [ArgumentError] if the given [expression] is `false`.
void checkArgument(bool expression, {message}) {
  if (!expression) {
    throw ArgumentError(_resolveMessage(message, null));
  }
}

/// Throws a [RangeError] if the given [index] is not a valid index for a list
/// with [size] elements. Otherwise, returns the [index] parameter.
int checkListIndex(int index, int size, {message}) {
  if (index < 0 || index >= size) {
    throw RangeError(_resolveMessage(
        message, 'index $index not valid for list of size $size'));
  }
  return index;
}

/// Throws an [ArgumentError] if the given [reference] is `null`. Otherwise,
/// returns the [reference] parameter.
T checkNotNull<T>(T reference, {message}) {
  if (reference == null) {
    throw ArgumentError(_resolveMessage(message, 'null pointer'));
  }
  return reference;
}

/// Throws an [ArgumentError] if the given [reference] is `null`. Otherwise,
/// returns the [reference] parameter.
String checkNotEmpty(String string, {message}) {
  if (string == null || string.length == 0) {
    throw ArgumentError(_resolveMessage(message, 'null or empty string'));
  }
  return string;
}

/// Throws a [StateError] if the given [expression] is `false`.
void checkState(bool expression, {message}) {
  if (!expression) {
    throw StateError(_resolveMessage(message, 'failed precondition'));
  }
}

String _resolveMessage(message, String defaultMessage) {
  if (message is Function) message = message();
  if (message == null) return defaultMessage;
  return message.toString();
}
