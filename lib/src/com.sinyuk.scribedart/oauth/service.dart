import 'package:scribedart/src/com.sinyuk.ohnohttp/core/http_client.dart';
import 'package:scribedart/src/com.sinyuk.ohnohttp/httpclient/dart_http_client.dart';
import 'package:scribedart/src/com.sinyuk.ohnohttp/io/resource.dart';
import 'package:scribedart/src/com.sinyuk.ohnohttp/model/response.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/model/oath10a_token.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/model/oauth_request.dart';

abstract class OAuthService implements Resource {
  final String apiKey;
  final String apiSecret;
  OhNoHttpClient client;

  OAuthService(this.apiKey, this.apiSecret, [OhNoHttpClient client]) {
    if (null == client) {
      this.client = DartHttpClient();
    } else {
      this.client = client;
    }
  }

  @override
  void dispose() {
    this.client.dispose();
  }

  Future<OAuthRequest> signRequest(
      OAuth1AccessToken token, OAuthRequest request);

  Future<Response> send(OAuthRequest request) {
    return client.send(request);
  }
}
