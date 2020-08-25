import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:logging/logging.dart';
import 'package:scribedart/src/com.sinyuk.ohnohttp/core/http_client.dart';
import 'package:scribedart/src/com.sinyuk.ohnohttp/log/log.dart';
import 'package:scribedart/src/com.sinyuk.ohnohttp/model/headers.dart';
import 'package:scribedart/src/com.sinyuk.ohnohttp/model/http_url.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/core/builder/api/api_10a.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/model/oath10a_token.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/model/oauth_constant.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/model/oauth_request.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/oauth/service.dart';

/**
 * Implementation of [OAuthService]
 */
class OAuth10aService extends OAuthService {
  static Future<OAuthService> fromFile(DefaultApi10a api, String filename,
      {OhNoHttpClient client}) async {
    final result = <int>[];
    final relativePath =
        path.join('lib/src/com.sinyuk.scribedart.apis/sensitive', filename);
    final stream = File(path.absolute(relativePath)).openRead();
    await for (var data in stream) {
      for (int i = 0; i < data.length; i++) result.add(data[i]);
    }

    Map<String, dynamic> config = jsonDecode(utf8.decode(result));

    final key = config[OAuthConstants.CONSUMER_KEY];
    final secret = config[OAuthConstants.CONSUMER_SECRET];
    final scope = config[OAuthConstants.SCOPE];

    return OAuth10aService(key, secret, api, scope: scope, client: client);
  }

  final DefaultApi10a api;
  final String scope;
  Logger _logger;
  OAuth10aService(String apiKey, String apiSecret, this.api,
      {this.scope, OhNoHttpClient client})
      : super(apiKey, apiSecret, client) {
    Logger.root.level = Level.ALL;
    _logger = Logger('scribedart.OAuth10aService');
    final appender = PrintAppender(BasicLogFormatter());
    appender.attachLogger(_logger);
  }

  Future<OAuth1RequestToken> requestToken() async {
    _logger.fine('requestToken()');
    final request = await _prepareRequestTokenRequest();
    final response = await send(request);
    if (!response.successful)
      throw StateError('${response.code}; ${response.message}');

    return api.requestTokenExtractor.extract(response);
  }

  /**
   * Start the request to retrieve the access token. The optionally provided callback will be called with the Token
   * when it is available.
   */
  Future<OAuth1AccessToken> accessToken(OAuth1RequestToken requestToken,
      {String oauthVerifier}) async {
    _logger.fine('accessToken()');
    final request =
        await _prepareAccessTokenRequest(requestToken, oauthVerifier);
    final response = await send(request);
    if (!response.successful)
      throw StateError('${response.code}; ${response.message}');

    return api.accessTokenExtractor.extract(response);
  }

  Future<OAuthRequest> _prepareAccessTokenRequest(
      OAuth1RequestToken token, String oauthVerifier) async {
    final _url = HttpUrl.parse(api.accessTokenEndpoint);
    final _request = OAuthRequest(url: _url, verb: api.accessTokenVerb);
    _request.addOAuthParameter(OAuthConstants.TOKEN, token.token);
    _request.addOAuthParameter(OAuthConstants.CALLBACK, api.callback);
    if (oauthVerifier?.isNotEmpty == true)
      _request.addOAuthParameter(OAuthConstants.VERIFIER, oauthVerifier);
    await addOAuthParams(_request, tokenSecret: token.tokenSecret);
    return adppendSignature(_request);
  }

  Future<OAuthRequest> _prepareRequestTokenRequest() async {
    final _url = HttpUrl.parse(api.requestTokenEndpoint);
    final _request = OAuthRequest(url: _url, verb: api.requestTokenVerb);
    await addOAuthParams(_request);
    return adppendSignature(_request);
  }

  addOAuthParams(OAuthRequest request, {String tokenSecret}) async {
    request.addOAuthParameter(
        OAuthConstants.TIMESTAMP, api.timestampService.timestampInSeconds);
    request.addOAuthParameter(OAuthConstants.NONCE, api.timestampService.nonce);
    request.addOAuthParameter(OAuthConstants.CONSUMER_KEY, apiKey);
    request.addOAuthParameter(
        OAuthConstants.SIGN_METHOD, api.signatureService.signatureMethod);
    if (api.version?.isNotEmpty == true)
      request.addOAuthParameter(OAuthConstants.VERSION, api.version);
    if (scope?.isNotEmpty == true)
      request.addOAuthParameter(OAuthConstants.SCOPE, scope);

    api.baseStringExtractor.request = request;
    final baseString = await api.baseStringExtractor.concatenated();
    _logger.finest('BaseString: $baseString');
    final _signature = await api.signatureService
        .signature(baseString, apiSecret, tokenSecret);
    _logger.finest('Signature: $_signature');
    request.addOAuthParameter(OAuthConstants.SIGNATURE, _signature);
  }

  OAuthRequest adppendSignature(OAuthRequest request) {
    switch (api.signatureType) {
      case OAuth1SignatureType.HEADER:
        final oauthHeader = api.headerBuilder.build(request);
        final builder = request.headers == null
            ? HeadersBuilder()
            : request.headers.newBuilder();
        builder.add(OAuthConstants.HEADER, oauthHeader);
        return request.copyWith(headers: builder.build());
      case OAuth1SignatureType.QUERY_STRING:
        final newBuilder = request.url.newBuilder();
        request.oauthParameters.forEach((key, value) {
          newBuilder.addQueryParameter(key, value);
        });
        return request.copyWith(url: newBuilder.build());
    }

    throw ArgumentError.value(api.signatureType, 'OAuth1SignatureType');
  }

  @override
  Future<OAuthRequest> signRequest(
      OAuth1AccessToken token, OAuthRequest request) async {
    if (token.token?.isNotEmpty == true ||
        api.isEmptyOAuthTokenParamIsRequired) {
      request.addOAuthParameter(OAuthConstants.TOKEN, token.token);
    }
    await addOAuthParams(request, tokenSecret: token.tokenSecret);
    return adppendSignature(request);
  }
}
