import 'package:scribedart/src/com.sinyuk.ohnohttp/model/http_url.dart';
import 'package:test/test.dart';

void main() {
  group('HttpUrlBuilder', () {
    test('setPath ...', () {
      final builder = HttpUrlBuilder(Uri.parse('https://dog.ceo'));
      final url = builder.setPath('api/breeds/image/random').build();
      final excepted = HttpUrl.parse('https://dog.ceo/api/breeds/image/random');
      expect(url.toString(), equals(excepted.toString()));
    });

    test('addPathSegment ...', () {
      final builder = HttpUrlBuilder(Uri.parse('https://dog.ceo'));
      final url = builder
          .addPathSegment('api')
          .addPathSegment('breeds')
          .addPathSegment('image')
          .addPathSegment('random')
          .build();
      final excepted = HttpUrl.parse('https://dog.ceo/api/breeds/image/random');
      expect(url.toString(), equals(excepted.toString()));
    });
  });
}
