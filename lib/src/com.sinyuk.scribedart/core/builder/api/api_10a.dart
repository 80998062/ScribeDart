import 'package:scribedart/src/com.sinyuk.ohnohttp/model/request.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/core/extractors/oauth10_headers.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/core/extractors/abstracts.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/core/extractors/base_string.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/core/extractors/oauth10_instances.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/model/oath10a_token.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/model/oauth_constant.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/model/paramter.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/service/signature_service.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/service/timestamp_service.dart';

/**
 * Default implementation of the OAuth protocol, version 1.0a
 *
 * This class is meant to be extended by concrete implementations of the API, providing the endpoints and
 * endpoint-http-verbs.
 *
 * If your Api adheres to the 1.0a protocol correctly, you just need to extend this class and define the getters for
 * your endpoints.
 *
 * If your Api does something a bit different, you can override the different extractors or services, in order to
 * fine-tune the process. Please read the javadocs of the interfaces to get an idea of what to do.
 *
 */
abstract class DefaultApi10a {
  String get version => '1.0';

  String get callback => OAuthConstants.OOB;

  /// Returns the verb for the request token endpoint (defaults to POST)
  Verb get requestTokenVerb => Verb.POST;

  /**
   * Returns the URL that receives the request token requests.
   */
  String get requestTokenEndpoint;

  /// Returns the verb for the access token endpoint (defaults to POST)
  Verb get accessTokenVerb => Verb.POST;

  /// Returns the URL that receives the access token requests.
  String get accessTokenEndpoint;

  /// Returns the base URL for authorization.
  String get authorizationBaseUrl;

  /**
   * Returns the URL where you should **redirect** your users to authenticate your application.
   */
  String getRedirectdUrl(OAuth1RequestToken requestToken) {
    final ParameterList parameters = new ParameterList();
    parameters.add(OAuthConstants.TOKEN, requestToken.token);
    return parameters.appendTo(authorizationBaseUrl);
  }

  /**
   * Constructing a `base string` by authorized request.
   */
  BaseStringExtractor get baseStringExtractor => BaseStringExtractor.instance;

  /**
   * Constructing a request header named `OAuth` via oauth parameters.
   */
  Oauth10HeaderBuilder get headerBuilder => Oauth10HeaderBuilder.instance;

  /**
   * Extract the RequestToken from the response to an authorization request.
   */
  TokenExtractor<OAuth1RequestToken> get requestTokenExtractor =>
      OAuth1RequestTokenExtractor.instance;

  /**
   * Extract the AccessToken from the response to an authorization request.
   */
  TokenExtractor<OAuth1AccessToken> get accessTokenExtractor =>
      OAuth1AccessTokenExtractor.instance;

  /// Returns the signature service.
  SignatureService get signatureService => SignatureService.HMACSha1;

  /// Return the signature type, choose between header, querystring
  OAuth1SignatureType get signatureType => OAuth1SignatureType.HEADER;

  /// Returns the timestamp service.
  TimestampService get timestampService => TimestampService.instance;

  /**
   * http://tools.ietf.org/html/rfc5849 says that "The client MAY omit the empty "oauth_token" protocol parameter from
   * the request", but not all oauth servers are good boys.
   *
   * `return` whether to inlcude empty oauth_token param to the request
  */
  bool get isEmptyOAuthTokenParamIsRequired => false;
}

enum OAuth1SignatureType { HEADER, QUERY_STRING }
