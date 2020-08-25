import 'package:scribedart/src/com.sinyuk.ohnohttp/model/http_url.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/model/oauth_request.dart';
import 'package:test/test.dart';

void main() {
  group('OauthRequest', () {
    test('addOAuthParameter ...', () async {
      final request = OAuthRequest.url('https://example.com');
      try {
        request.addOAuthParameter('wtf', 'idontcare');
      } on ArgumentError catch (e) {
        expect(e.message, equals(OAuthRequest.HINT));
      }
    });

    test('addOAuthParameter ...', () async {
      final request = OAuthRequest.url('https://example.com');
      request.addOAuthParameter('oauth_version', '1.0.0');
      request.addOAuthParameter('scope', 'guest');
      request.addOAuthParameter('realm', 'wtf');
      expect(request.oauthParameters.length, 3);
    });

    test('copyWith ...', () async {
      final _parameters = {
        'oauth_a': '1',
        'oauth_b': '2',
        'oauth_c': '3',
      };
      final request = OAuthRequest.url('https://example.com');
      request.realm = '1597998825';
      request.oauthParameters = _parameters;
      final newUrl = HttpUrl.parse('https://f4.net');
      final newRequest = request.copyWith(url: newUrl);
      expect(newRequest.url.toString(), 'https://f4.net');
      expect(newRequest.realm, '1597998825');
      expect(newRequest.oauthParameters.length, 3);
    });
  });
}
