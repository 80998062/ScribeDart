import '../model/http_url.dart';

import 'headers.dart';
import 'request_body.dart';

enum Verb { GET, POST, PUT, DELETE }

extension VerbMixin on Verb {
  static Verb from(String value) {
    switch (value) {
      case 'GET':
        return Verb.GET;
      case 'POST':
        return Verb.POST;
      case 'PUT':
        return Verb.PUT;
      case 'DELETE':
        return Verb.DELETE;
      default:
        throw Exception('$value is not a valid Verb!');
    }
  }

  static String value(Verb verb) {
    switch (verb) {
      case Verb.GET:
        return 'GET';
      case Verb.POST:
        return 'POST';
      case Verb.PUT:
        return 'PUT';
      case Verb.DELETE:
        return 'DELETE';
    }
    throw ArgumentError('Unsupported verb: ${verb}');
  }
}

class Request {
  final HttpUrl url;
  final Verb verb;
  final Headers headers;
  final RequestBody body;
  final Map<String, dynamic> extras;

  Request({this.url, this.verb, this.headers, this.body, this.extras});

  Request.url(String url, [Verb verb = Verb.GET])
      : this(url: HttpUrl.parse(url), verb: verb);
}

extension getters on Request {
  String contentType() {
    return headers?.value('Content-Type');
  }
}
