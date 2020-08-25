import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:scribedart/src/com.sinyuk.ohnohttp/model/media_type.dart';
import 'package:scribedart/src/com.sinyuk.ohnohttp/model/response.dart';
import 'package:scribedart/src/com.sinyuk.ohnohttp/model/response_body.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/core/extractors/oauth10_abstracts.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/model/oath10a_token.dart';
import 'package:test/test.dart';

class FakeToken extends Fake implements OAuth1Token {
  final String token;
  final String tokenSecret;

  FakeToken(this.token, this.tokenSecret);
}

class StringReponse extends Response {
  static final _body =
      ResponseBody.bytesBody(MediaType.binary, utf8.encode(RESPONSE_BODY));

  StringReponse() : super(body: _body);
}

class ExtractorInherit extends AbstractOAuth1TokenExtractor<FakeToken> {
  @override
  FakeToken createToken(String token, String secret, String response) {
    return FakeToken(token, secret);
  }
}

final RESPONSE_BODY =
    'oauth_token=123456abcdefg&oauth_token_secret=0987654qwerty';
void main() {
  group('AbstractOAuth1TokenExtractor', () {
    test('_extract', () {
      final extractor = ExtractorInherit();

      final token = extractor.private_extract(
          RESPONSE_BODY, AbstractOAuth1TokenExtractor.OAUTH_TOKEN_REGEXP);
      final secret = extractor.private_extract(RESPONSE_BODY,
          AbstractOAuth1TokenExtractor.OAUTH_TOKEN_SECRET_REGEXP);

      expect(token, equals('123456abcdefg'));
      expect(secret, equals('0987654qwerty'));
    });

    test('extract', () async {
      final extractor = ExtractorInherit();
      final extracted = await extractor.extract(StringReponse());

      expect(extracted.token, equals('123456abcdefg'));
      expect(extracted.tokenSecret, equals('0987654qwerty'));
    });
  });
}
