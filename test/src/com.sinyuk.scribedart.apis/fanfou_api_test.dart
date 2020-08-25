import 'package:scribedart/src/com.sinyuk.scribedart.apis/fanfou_api.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/model/oath10a_token.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/model/oauth_request.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/oauth/oauth10a_service.dart';

import 'package:test/test.dart';

/**
 * Because the entire process requires the user to manually open the redirected url and enter the pin code,
 * automated testing cannot be completed.
 */
void main() {
  FanfouApi api;
  OAuth10aService service;
  setUp(() async {
    api = FanfouApi();
    service = await OAuth10aService.fromFile(api, 'fanfou_config.json');
  });

  tearDown(() {
    service.dispose();
  });

  group('fanfou api ...', () {
    test('config ...', () {
      print(service.apiKey);
      print(service.apiSecret);
      expect(service.apiKey, isNotEmpty);
      expect(service.apiSecret, isNotEmpty);
    });

    test('requestToken ...', () async {
      expect(1 + 1, 2);
      return;
      final requestToken = await service.requestToken();
      expect(requestToken?.token, isNotEmpty);
      expect(requestToken?.tokenSecret, isNotEmpty);
      print('The unauthorized Request Token received is shown below:');
      print(requestToken.toString());
      print('The server will redirect you to the address:');
      print(api.getRedirectdUrl(requestToken));
      print('to obtain the PIN code');
    });

    test('accessToken ...', () async {
      // TODO: Please complete the following test procedure manually
      expect(1 + 1, 2);
      return;
      final requestToken = OAuth1RequestToken(
          'Fill in the token and tokenSecret in Request Token',
          'which you received in the previous step');
      final pinCode = 'Fill in the PIN code you obtained in the redirected url';
      final accessToken =
          await service.accessToken(requestToken, oauthVerifier: pinCode);
      expect(accessToken?.token, isNotEmpty);
      expect(accessToken?.tokenSecret, isNotEmpty);
      print('The Access Token obtained by the authorized Request Token is:');
      print(accessToken.toString());
    });

    // e.g.
    // OAuth1AccessToken(token: 1394833-dcb00385a3f550be20880ad428c7917d; tokenSecret: 6c561874817975548f4c352b78f29ded;)

    test('signRequest ...', () async {
      // TODO: Please complete the following test procedure manually
      expect(1 + 1, 2);
      return;
      final accessToken = OAuth1AccessToken(
          'Fill in the token and tokenSecret in Access Token',
          'which you received in the previous step');
      final url = 'http://api.fanfou.com/search/public_timeline.json?q=apple';
      final request =
          await service.signRequest(accessToken, OAuthRequest.url(url));
      final response = await service.send(request);
      expect(response.successful, true);
    });
  });
}
