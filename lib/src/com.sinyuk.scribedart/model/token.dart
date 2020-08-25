

/**
 * Represents an abstract OAuth (1 and 2) token (either request or access token)
 */
abstract class Token {
  final String rawReponse;

  Token(
    this.rawReponse,
  );

  String get rawResponse {
    if (null == rawReponse || rawReponse.length == 0) {
      throw StateError(
          'This token object was not constructed by ScribeDart and does not have a rawResponse');
    }
    return this.rawReponse;
  }

  String getParameter(String parameter) {
    String value = null;
    for (String str in rawReponse.split('&')) {
      if (str.startsWith(parameter + '=')) {
        final part = str.split("=");
        if (part.length > 1) {
          value = part[1].trim();
        }
        break;
      }
    }
    return value;
  }

  @override
  String toString() => 'Token(rawReponse: $rawReponse)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Token && o.rawReponse == rawReponse;
  }

  @override
  int get hashCode => rawReponse.hashCode;
}
