import 'package:scribedart/src/com.sinyuk.scribedart/model/oath10a_token.dart';
import 'oauth10_abstracts.dart';

class OAuth1AccessTokenExtractor
    extends AbstractOAuth1TokenExtractor<OAuth1AccessToken> {
  OAuth1AccessTokenExtractor._();
  static final OAuth1AccessTokenExtractor _instance =
      OAuth1AccessTokenExtractor._();

  static OAuth1AccessTokenExtractor get instance => _instance;

  @override
  OAuth1AccessToken createToken(String token, String secret, String response) {
    return OAuth1AccessToken(token, secret, response);
  }
}

class OAuth1AccessTokenJSONExtractor
    extends AbstractOAuth1JSONTokenExtractor<OAuth1AccessToken> {
  OAuth1AccessTokenJSONExtractor._();
  static final OAuth1AccessTokenJSONExtractor _instance =
      OAuth1AccessTokenJSONExtractor._();

  static OAuth1AccessTokenJSONExtractor get instance => _instance;

  @override
  OAuth1AccessToken createToken(String token, String secret, String response) {
    return OAuth1AccessToken(token, secret, response);
  }
}

class OAuth1RequestTokenExtractor
    extends AbstractOAuth1TokenExtractor<OAuth1RequestToken> {
  OAuth1RequestTokenExtractor._();
  static final OAuth1RequestTokenExtractor _instance =
      OAuth1RequestTokenExtractor._();

  static OAuth1RequestTokenExtractor get instance => _instance;
  @override
  OAuth1RequestToken createToken(String token, String secret, String response) {
    return OAuth1RequestToken(token, secret, true, response);
  }
}

class OAuth1RequestTokenJSONExtractor
    extends AbstractOAuth1JSONTokenExtractor<OAuth1RequestToken> {
  OAuth1RequestTokenJSONExtractor._();
  static final OAuth1RequestTokenJSONExtractor _instance =
      OAuth1RequestTokenJSONExtractor._();

  static OAuth1RequestTokenJSONExtractor get instance => _instance;
  @override
  OAuth1RequestToken createToken(String token, String secret, String response) {
    return OAuth1RequestToken(token, secret, true, response);
  }
}
