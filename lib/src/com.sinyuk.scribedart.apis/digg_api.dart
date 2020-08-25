import 'package:scribedart/src/com.sinyuk.scribedart/core/builder/api/api_10a.dart';

class DiggApi extends DefaultApi10a {
  DiggApi._();
  static final DiggApi _instance = DiggApi._();

  static DiggApi get instance => _instance;

  static final String AUTHORIZATION_URL = 'http://digg.com/oauth/authorize';
  static final String BASE_URL = 'http://services.digg.com/oauth/';

  @override
  String get accessTokenEndpoint => '${BASE_URL}request_token';

  @override
  String get authorizationBaseUrl => AUTHORIZATION_URL;

  @override
  String get requestTokenEndpoint => '${BASE_URL}access_token';
}
