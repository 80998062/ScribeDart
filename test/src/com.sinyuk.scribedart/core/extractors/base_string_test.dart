import 'package:scribedart/src/com.sinyuk.ohnohttp/model/http_url.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/core/extractors/base_string.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/model/oauth_request.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/model/paramter.dart';
import 'package:test/test.dart';

import '../../mock/object_chef.dart';

const EXPECTED_BASE_STRING =
    'POST&http%3A%2F%2Fexample.com%2Frequest&a2%3Dr%2520b%26a3%3D2%2520q%26a3%3Da%26b5%3D%253D%25253D%26c%2540%3D%26c2%3D%26oauth_consumer_key%3D9djdj82h48djs9d2%26oauth_nonce%3D7d8f3e4a%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D137131201%26oauth_token%3Dkkk9d7dh3k39sjv7';

void main() {
  final request = ObjectChef.FullOAuth10Request;

  group('base string ...', () {
    test('get verb ...', () {
      BaseStringExtractor.instance.request = request;
      expect(BaseStringExtractor.instance.verb, equals('POST'));
    });

    test('get uri ...', () {
      // For example, the HTTP request:
      //     GET /r%20v/X?id=123 HTTP/1.1
      //     Host: EXAMPLE.COM:80
      BaseStringExtractor.instance.request =
          OAuthRequest(url: HttpUrl.parse('http://example.com:80/r v/X'));
      final result1 = BaseStringExtractor.instance.uri;

      // is represented by the base string URI:
      expect(result1, equals('http://example.com/r v/X'));

      // In another example, the HTTPS request:
      //    GET /?q=1 HTTP/1.1
      //    Host: www.example.net:8080
      BaseStringExtractor.instance.request =
          OAuthRequest(url: HttpUrl.parse('https://www.example.net:8080'));
      final result2 = BaseStringExtractor.instance.uri;

      // is represented by the base string URI:
      expect(result2, equals('https://www.example.net:8080/'));
    });

    test('getBodyParameters ...', () async {
      BaseStringExtractor.instance.request = request;
      final bodyParameters = await BaseStringExtractor.instance.bodyParameters;
      final sorted = bodyParameters.sort();
      expect(sorted.params[0], equals(Parameter('a3', '2%20q')));
      expect(sorted.params[1], equals(Parameter('c2', '')));
    });

    test('getQueryParameters ...', () async {
      BaseStringExtractor.instance.request = request;
      final queryParameters =
          await BaseStringExtractor.instance.queryParameters;
      final sorted = queryParameters.sort();
      expect(sorted.params.length, equals(4));
      expect(sorted.params.first, equals(Parameter('a2', 'r%20b')));
      expect(sorted.params.last, equals(Parameter('c%40', '')));
    });

    test('concatenated ...', () async {
      BaseStringExtractor.instance.request = request;
      final concatenated_string =
          await BaseStringExtractor.instance.concatenated();
      expect(concatenated_string, equals(EXPECTED_BASE_STRING));
    });
  });
}
