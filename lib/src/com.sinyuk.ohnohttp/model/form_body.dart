import 'dart:async';
import 'dart:convert';

import 'media_type.dart';
import 'request_body.dart';

class FormBody extends RequestBody {
  FormBody._(
    Encoding encoding,
    List<String> namesAndValues,
  )   : _encoding = encoding,
        _contentType =
            MediaType('application', 'x-www-form-urlencoded', encoding.name),
        _namesAndValues = namesAndValues,
        _bytes = encoding.encode(_pairsToQuery(namesAndValues));

  // ignore: unused_field
  final Encoding _encoding;
  final MediaType _contentType;
  // ignore: unused_field
  final List<String> _namesAndValues;
  final List<int> _bytes;

  @override
  MediaType contentType() {
    return _contentType;
  }

  @override
  int contentLength() {
    return _bytes.length;
  }

  @override
  Stream<List<int>> source() {
    return Stream<List<int>>.fromIterable(<List<int>>[_bytes]);
  }

  static String _pairsToQuery(List<String> namesAndValues) {
    return List<String>.generate(namesAndValues.length ~/ 2, (int index) {
      return '${namesAndValues[index * 2]}=${namesAndValues[index * 2 + 1]}';
    }).join('&');
  }
}

class FormBodyBuilder {
  FormBodyBuilder([
    Encoding encoding = utf8,
  ])  : assert(encoding != null),
        _encoding = encoding;

  final Encoding _encoding;
  final List<String> _namesAndValues = <String>[];

  FormBodyBuilder add(String name, String value) {
    assert(name != null && name.isNotEmpty);
    assert(value != null);
    _namesAndValues.add(Uri.encodeQueryComponent(name, encoding: _encoding));
    _namesAndValues.add(Uri.encodeQueryComponent(value, encoding: _encoding));
    return this;
  }

  FormBody build() {
    return FormBody._(_encoding, List<String>.unmodifiable(_namesAndValues));
  }
}
