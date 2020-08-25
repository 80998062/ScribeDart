import 'dart:io';

import '../model/media_type.dart';
import '../model/response_body.dart';
import '../model/response.dart';
import '../model/request.dart';

extension ResponseWrapper on HttpClientResponse {
  ResponseBody wrappedBody() {
    final type = headers.value(HttpHeaders.contentTypeHeader);
    return ResponseBody.streamBody(MediaType.parse(type), contentLength, this);
  }

  Response wrapped(Request request) {
    return Response(
        request: request,
        code: statusCode,
        message: reasonPhrase,
        headers: headers.wrapped(),
        body: wrappedBody());
  }
}

extension HeadersWrapper on HttpHeaders {
  Map<String, String> wrapped() {
    final result = Map<String, String>();
    forEach((name, values) {
      result.putIfAbsent(name, () => values.join(','));
    });
    return result;
  }
}
