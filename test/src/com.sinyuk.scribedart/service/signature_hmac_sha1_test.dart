import 'package:scribedart/src/com.sinyuk.scribedart/service/signature_hmac_sha1.dart';
import 'package:test/test.dart';

void main() {
  group('signature hmac-sha1', () {
    test('get signatureMethod ...', () {
      expect(HMACSha1SignatureService.instance.signatureMethod,
          equals('HMAC-SHA1'));
    });

    test('get signature ...', () async {
      final signature = HMACSha1SignatureService.instance
          .signature('base string', 'api secret', 'token secret');
      expect(signature, equals('uGymw2KHOTWI699YEaoi5xyLT50='));
    });
  });
}
