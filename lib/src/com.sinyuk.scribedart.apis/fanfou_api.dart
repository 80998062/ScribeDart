import 'package:scribedart/src/com.sinyuk.ohnohttp/model/request.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/core/builder/api/api_10a.dart';

/**
 * OAuth API for [饭否](https://github.com/FanfouAPI/FanFouAPIDoc/wiki/).
 */
class FanfouApi extends DefaultApi10a {
  @override
  String get accessTokenEndpoint => 'http://fanfou.com/oauth/access_token';

  @override
  String get authorizationBaseUrl => 'http://fanfou.com/oauth/authorize';

  @override
  String get requestTokenEndpoint => 'http://fanfou.com/oauth/request_token';

  @override
  OAuth1SignatureType get signatureType => OAuth1SignatureType.QUERY_STRING;

  @override
  Verb get requestTokenVerb => Verb.GET;

  @override
  Verb get accessTokenVerb => Verb.GET;

  /// Version here can be '1.0' or empty
  @override
  String get version => null;
}
