import 'package:scribedart/src/com.sinyuk.ohnohttp/httpclient/dart_http_client.dart';
import 'package:scribedart/src/com.sinyuk.ohnohttp/model/request.dart';
import 'package:test/test.dart';

void main() {
  DartHttpClient client;

  setUp(() {
    client = DartHttpClient();
  });

  tearDown(() {
    client.dispose();
  });

  group('DartHttpClient', () {
    test('GET', () async {
      final response = await client
          .send(Request.url('https://dog.ceo/api/breeds/image/random'));
      expect(response.code, equals(200));
    });
  });
}
