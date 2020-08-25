import 'package:scribedart/src/com.sinyuk.ohnohttp/model/headers.dart';
import 'package:scribedart/src/com.sinyuk.ohnohttp/model/http_url.dart';
import 'package:scribedart/src/com.sinyuk.ohnohttp/model/media_type.dart';
import 'package:scribedart/src/com.sinyuk.ohnohttp/model/request.dart';
import 'package:scribedart/src/com.sinyuk.ohnohttp/model/request_body.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/model/oauth_constant.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/model/oauth_request.dart';

const oauth_params = {
  'oauth_consumer_key': '9djdj82h48djs9d2',
  'oauth_token': 'kkk9d7dh3k39sjv7',
  'oauth_signature_method': 'HMAC-SHA1',
  'oauth_nonce': '7d8f3e4a',
  'realm': 'Example',
  'oauth_signature': 'djosJKDKJSD8743243%2Fjdk33klY%3D',
  'oauth_timestamp': '137131201'
};

const form_data = {'c2': '', 'a3': '2 q'};

class ObjectChef {
  static OAuthRequest get FullOAuth10Request {
    final builder = HttpUrlBuilder()
        .scheme('http')
        .host('example.com')
        .addPathSegment('request');
    final queries = {'b5': '%3D%253D', 'a3': 'a', 'c%40': '', 'a2': 'r%20b'};
    queries.forEach((key, value) {
      builder.addQueryParameter(key, value);
    });
    final body = RequestBody.textBody(
        MediaType.parse('application/x-www-form-urlencoded'), 'c2&a3=2+q');
    final headers = HeadersBuilder()
        .add('Authorization',
            'OAuth realm="Example",oauth_consumer_key="9djdj82h48djs9d2",oauth_token="kkk9d7dh3k39sjv7",oauth_signature_method="HMAC-SHA1",oauth_timestamp="137131201",oauth_nonce="7d8f3e4a",oauth_signature="djosJKDKJSD8743243%2Fjdk33klY%3D"')
        .add('Content-Type', 'application/x-www-form-urlencoded')
        .add('HOST', 'example.com')
        .build();
    final r = OAuthRequest(
        url: builder.build(), verb: Verb.POST, headers: headers, body: body);
    oauth_params.forEach((key, value) {
      r.addOAuthParameter(key, value);
    });
    return r;
  }

  static OAuthRequest get SampleOAuth10Request {
    final request = OAuthRequest.url('http://example.com');
    request.addOAuthParameter(OAuthConstants.TIMESTAMP, '123456');
    request.addOAuthParameter(OAuthConstants.CONSUMER_KEY, r'AS#$^*@&');
    request.addOAuthParameter(
        OAuthConstants.CALLBACK, 'http://example/callback');
    request.addOAuthParameter(OAuthConstants.SIGNATURE, 'OAuth-Signature');
    return request;
  }
}

main(List<String> args) {
  print(Uri.decodeComponent('r+b'));
  print(Uri.decodeQueryComponent('2+q'));
  // final url = Mockutils.oauth10aRequest.url;
  // print(url);

  // print(Uri.encodeFull(url.toString()));

  // url.queryParametersAll().forEach((key, value) {
  //   print('$key : $value');
  // });

  // print('c%'.compareTo('c2'));
}
