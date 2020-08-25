import 'dart:convert';

import 'package:scribedart/src/com.sinyuk.ohnohttp/model/response.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/core/extractors/abstracts.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/model/oath10a_token.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/model/oauth_constant.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/utils/precondition.dart';

/**
 * Abstract base implementation of [TokenExtractor] for OAuth 1.0a
 *
 * The process for extracting access and request tokens is similar so this class can do both things.
 *
 * [T] concrete type of [OAuth1Token]. access or request
 */
abstract class AbstractOAuth1TokenExtractor<T extends OAuth1Token>
    implements TokenExtractor<T> {
  static final OAUTH_TOKEN_REGEXP = "oauth_token=([^&]+)";
  static final OAUTH_TOKEN_SECRET_REGEXP = "oauth_token_secret=([^&]*)";

  T createToken(String token, String secret, String response);

  @override
  Future<T> extract(Response response) async {
    final bodyString = await response.body.string();
    
    final body = checkNotEmpty(bodyString,
        message: 'Can\'t extract a token from an empty string');
    final token = checkNotEmpty(private_extract(body, OAUTH_TOKEN_REGEXP),
        message: 'token can\'t be null');
    final secret = checkNotEmpty(
        private_extract(body, OAUTH_TOKEN_SECRET_REGEXP),
        message: 'secret can\'t be null');

    return createToken(token, secret, body);
  }

  String private_extract(String input, String pattern) {
    final r = RegExp(pattern);
    if (r.hasMatch(input)) {
      return r.firstMatch(input).group(1);
    } else {
      throw ArgumentError(
          'Input is incorrect. Can\'t extract token and secret from: $input');
    }
  }
}

class _JSONToken {
  final String token;
  final String secret;

  _JSONToken(this.token, this.secret);

  _JSONToken.fromJson(Map<String, dynamic> json)
      : token = json[OAuthConstants.TOKEN],
        secret = json[OAuthConstants.TOKEN_SECRET];
  Map<String, dynamic> toJson() => {
        'token': token,
        'secret': secret,
      };
}

abstract class AbstractOAuth1JSONTokenExtractor<T extends OAuth1Token>
    implements TokenExtractor<T> {
  T createToken(String token, String secret, String response);

  @override
  Future<T> extract(Response response) async {
    final body = checkNotEmpty(await response.body.string(),
        message: 'Can\'t extract a token from an empty string');
    final tokenMap = jsonDecode(body);
    final jsonToken = _JSONToken.fromJson(tokenMap);
    final token =
        checkNotEmpty(jsonToken.token, message: 'token can\'t be null');
    final secret =
        checkNotEmpty(jsonToken.secret, message: 'secret can\'t be null');

    return createToken(token, secret, body);
  }
}
