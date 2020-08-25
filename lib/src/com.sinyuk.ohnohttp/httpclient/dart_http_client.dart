import 'package:logging/logging.dart';

import '../model/response.dart';
import '../model/request.dart';
import '../core/http_client.dart';
import 'extension.dart';
import 'dart:io';

class DartHttpClient extends OhNoHttpClient {
  final httpClient = new HttpClient();
  final _logger = Logger('ohnohttp.dart');

  DartHttpClient() {
    appender.attachLogger(_logger);
  }

  @override
  void dispose() {
    super.dispose();
    httpClient.close();
    _logger.clearListeners();
  }

  @override
  Future<Response> private_send(Request request) async {
    HttpClientRequest rawRequest = null;
    final completeUri = request.url.uri();
    final headers = request.headers;

    switch (request.verb) {
      case Verb.GET:
        rawRequest = await httpClient.getUrl(completeUri);
        break;
      case Verb.POST:
        rawRequest = await httpClient.postUrl(completeUri);
        break;
      case Verb.PUT:
        rawRequest = await httpClient.putUrl(completeUri);
        break;
      case Verb.DELETE:
        rawRequest = await httpClient.deleteUrl(completeUri);
        break;
    }

    if (null != headers && headers.size() > 0) {
      headers.names().forEach((key) {
        rawRequest.headers.add(key, headers.value(key));
      });
    }

    if (null != request.body) {
      rawRequest.contentLength = request.body.contentLength();
      rawRequest.write(request.body);
    }

    HttpClientResponse rawReponse = await rawRequest.close();
    return rawReponse.wrapped(request);
  }
}

main(List<String> args) {
  OhNoHttpClient client = DartHttpClient();
  final request =
      Request.url('https://zhuanlan.zhihu.com/api/columns/zhihuadmin');
  client
      .send(request)
      .then((response) async => () {})
      .catchError((e) => print('Opps! ' + e.toString()));
}
