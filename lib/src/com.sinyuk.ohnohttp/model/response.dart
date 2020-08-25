import 'dart:io';

import '../io/resource.dart';
import 'request.dart';
import 'response_body.dart';

class Response implements Resource {
  final Request request;
  final int code;
  final String message;
  final Map<String, String> headers;
  final ResponseBody body;
  final List<Resource> resources;
  bool disposed;

  bool get successful => code >= 200 && code <= 299;
  
  Response(
      {this.request,
      this.code,
      this.message,
      this.headers,
      this.body,
      this.resources});

  Response copyWith({
    Request request,
    int code,
    String message,
    Map<String, dynamic> headers,
    ResponseBody body,
  }) {
    return Response(
      request: request ?? this.request,
      code: code ?? this.code,
      message: message ?? this.message,
      headers: headers ?? this.headers,
      body: body ?? this.body,
    );
  }

  @override
  void dispose() {
    if (disposed) {
      return;
    }
    IOException error = null;
    if (resources?.isNotEmpty ?? false) {
      for (final item in resources) {
        if (null == item) continue;
        try {
          item.dispose();
        } on IOException catch (e) {
          error = e;
          break;
        }
      }
      if (null != error) {
        throw error;
      }
    }
    disposed = true;
  }
}

abstract class ResponseConverter<T> implements Resource {
  Future<T> convert(Response response);
}
