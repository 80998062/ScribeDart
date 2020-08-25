import 'dart:convert';

import '../utils/precondition.dart';
import 'token.dart';

/**
 * Represents an abstract OAuth 1 Token (either request or access token)
 */
abstract class OAuth1Token extends Token {
  final String token;
  final String tokenSecret;

  OAuth1Token(this.token, this.tokenSecret, [String rawReponse])
      : super(rawReponse) {
    checkNotNull(token, message: 'oauth_token can\'t be null');
    checkNotNull(tokenSecret, message: 'oauth_token_secret can\'t be null');
  }

  bool get isEmpty =>
      token.trim().length == 0 || tokenSecret.trim().length == 0;

  bool get isNotEmpty => !isEmpty;

  @override
  String toString() => 'OAuth1Token(token: $token, tokenSecret: $tokenSecret)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is OAuth1Token && o.token == token && o.tokenSecret == tokenSecret;
  }

  @override
  int get hashCode => token.hashCode ^ tokenSecret.hashCode;
}

/**
 * Represents an OAuth 1 Request Token http://tools.ietf.org/html/rfc5849#section-2.1
 */
class OAuth1RequestToken extends OAuth1Token {
  /// oauth_callback_confirmed: MUST be present and set to "true".
  /// The parameter is used to differentiate from previous versions of the protocol.
  final bool oauthCallbackConfirmed;

  OAuth1RequestToken(String token, String tokenSecret,
      [this.oauthCallbackConfirmed = true, String rawReponse])
      : super(token, tokenSecret, rawReponse);

  OAuth1RequestToken copyWith(
      {String token, String tokenSecret, bool oauthCallbackConfirmed}) {
    return OAuth1RequestToken(
        token ?? this.token,
        tokenSecret ?? this.tokenSecret,
        oauthCallbackConfirmed ?? this.oauthCallbackConfirmed);
  }

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'tokenSecret': tokenSecret,
      'oauthCallbackConfirmed': oauthCallbackConfirmed,
    };
  }

  factory OAuth1RequestToken.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OAuth1RequestToken(
        map['token'], map['tokenSecret'], map['oauthCallbackConfirmed']);
  }

  String toJson() => json.encode(toMap());

  factory OAuth1RequestToken.fromJson(String source) =>
      OAuth1RequestToken.fromMap(json.decode(source));

  @override
  String toString() =>
      'OAuth1RequestToken(token: $token; tokenSecret: $tokenSecret; oauthCallbackConfirmed: $oauthCallbackConfirmed)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is OAuth1RequestToken &&
        o.token == token &&
        o.tokenSecret == tokenSecret &&
        o.oauthCallbackConfirmed == oauthCallbackConfirmed;
  }

  @override
  int get hashCode => _hashCode();
  _hashCode() {
    int hash = 7;
    hash = 83 * hash + token.hashCode;
    hash = 83 * hash + tokenSecret.hashCode;
    hash = 83 * hash + (oauthCallbackConfirmed ? 1 : 0);
    return hash;
  }
}

/**
 * Represents an OAuth 1 Access Token http://tools.ietf.org/html/rfc5849#section-2.3
 */
class OAuth1AccessToken extends OAuth1Token {
  OAuth1AccessToken(String token, String tokenSecret, [String rawResponse])
      : super(token, tokenSecret, rawResponse);

  OAuth1AccessToken copyWith({String token, String tokenSecret}) {
    return OAuth1AccessToken(
        token ?? this.token, tokenSecret ?? this.tokenSecret);
  }

  Map<String, dynamic> toMap() {
    return {'token': token, 'tokenSecret': tokenSecret};
  }

  factory OAuth1AccessToken.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return OAuth1AccessToken(map['token'], map['tokenSecret']);
  }

  String toJson() => json.encode(toMap());

  factory OAuth1AccessToken.fromJson(String source) =>
      OAuth1AccessToken.fromMap(json.decode(source));

  @override
  String toString() =>
      'OAuth1AccessToken(token: $token; tokenSecret: $tokenSecret;)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is OAuth1AccessToken &&
        o.token == token &&
        o.tokenSecret == tokenSecret;
  }

  @override
  int get hashCode => _hashCode();
  _hashCode() {
    int hash = 3;
    hash = 73 * hash + token.hashCode;
    hash = 73 * hash + tokenSecret.hashCode;
    return hash;
  }
}

main(List<String> args) {}
