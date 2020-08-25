import 'package:scribedart/src/com.sinyuk.scribedart/core/extractors/oauth10_headers.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/model/oauth_request.dart';
import 'package:test/test.dart';

import '../../mock/object_chef.dart';

void main() {
  OAuthRequest request;
  Oauth10HeaderBuilder builder;
  setUp(() {
    request = ObjectChef.SampleOAuth10Request;
    builder = Oauth10HeaderBuilder.instance;
  });
  group('Oauth10HeaderBuilder', () {
    test('build ...', () {
      final header = builder.build(request);
      print(header);

      final oauth = 'OAuth ';
      final callback = 'oauth_callback="http%3A%2F%2Fexample%2Fcallback"';
      final signature = 'oauth_signature="OAuth-Signature"';
      final key = 'oauth_consumer_key="AS%23%24%5E%2A%40%26"';
      final timestamp = 'oauth_timestamp="123456"';

      expect(header.startsWith(oauth), true);
      expect(header.contains(callback), true);
      expect(header.contains(signature), true);
      expect(header.contains(key), true);
      expect(header.contains(timestamp), true);

      // Assert that header only contains the checked elements above and nothing else
      final _expected = header
          .replaceFirst(oauth, '')
          .replaceFirst(callback, '')
          .replaceFirst(signature, '')
          .replaceFirst(key, '')
          .replaceFirst(timestamp, '');

      expect(', , , ', equals(_expected));
    });

    test('empty oauth parameters...', () {
      final emptyRequest = OAuthRequest.url('http://example.com');
      try {
        builder.build(emptyRequest);
        expect(true, false);
      } on ArgumentError catch (e) {
        expect(e.message, 'Could not find oauth parameters in request');
      }
    });
  });
}
