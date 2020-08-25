import 'package:scribedart/src/com.sinyuk.ohnohttp/model/headers.dart';
import 'package:scribedart/src/com.sinyuk.ohnohttp/model/http_url.dart';
import 'package:scribedart/src/com.sinyuk.ohnohttp/model/request.dart';
import 'package:scribedart/src/com.sinyuk.ohnohttp/model/request_body.dart';

import 'oauth_constant.dart';

class OAuthRequest extends Request {
  static final OAUTH_PREFIX = 'oauth_';
  static final HINT =
      'Valid key either be "${OAuthConstants.SCOPE}","${OAuthConstants.REALM}" or start with "${OAUTH_PREFIX}"';

  String realm;
  Map<String, String> oauthParameters;

  OAuthRequest(
      {HttpUrl url,
      Verb verb = Verb.GET,
      Headers headers,
      RequestBody body,
      Map<String, String> parameters,
      String realm})
      : super(url: url, verb: verb, headers: headers, body: body) {
    // ignore: todo
    // TODO: check realm
    this.realm = realm;

    if (parameters?.isNotEmpty == true) {
      parameters?.keys?.forEach((element) => _checkKey(element));
      this.oauthParameters = Map();
      this.oauthParameters.addAll(parameters);
    }
  }

  OAuthRequest.url(String url) : super.url(url);

  addOAuthParameter(String key, String value) {
    _checkKey(key);
    if (null == oauthParameters) oauthParameters = Map();
    if (oauthParameters.containsKey(key)) {
      oauthParameters[key] = value;
    } else {
      oauthParameters.putIfAbsent(key, () => value);
    }
  }

  _checkKey(String key) {
    if (key.startsWith(OAUTH_PREFIX) ||
        key == OAuthConstants.SCOPE ||
        key == OAuthConstants.REALM) {
      return key;
    }

    throw ArgumentError.value(key, null, HINT);
  }

  OAuthRequest copyWith(
      {HttpUrl url,
      Verb verb,
      Headers headers,
      RequestBody body,
      String realm,
      Map<String, String> oauthParameters}) {
    return OAuthRequest(
        url: url ?? this.url,
        verb: verb ?? this.verb,
        headers: headers ?? this.headers,
        body: body ?? this.body,
        realm: realm ?? this.realm,
        parameters: oauthParameters ?? this.oauthParameters);
  }
}
