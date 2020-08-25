import 'dart:convert';

import 'package:scribedart/src/com.sinyuk.scribedart/utils/precondition.dart';

class Parameter extends Comparable<Parameter> {
  final String _key;
  final String _value;

  String get key => _key;
  String get value => _value;

  Parameter(
    this._key,
    this._value,
  ) {
    if (null == _key || _key.isEmpty) {
      throw ArgumentError('key cannot be null or empty');
    }
  }

  String get asUrlEncodedPair =>
      '${Uri.encodeComponent(key)}=${Uri.encodeComponent(value)}';

  Parameter encoded() {
    return Parameter(Uri.encodeComponent(_key), Uri.encodeComponent(_value));
  }

  @override
  int compareTo(Parameter other) {
    final keyDiff = _key.compareTo(other._key);
    return keyDiff == 0 ? _value.compareTo(other._value) : keyDiff;
  }

  Parameter copyWith({
    String key,
    String value,
  }) {
    return Parameter(
      key ?? this._key,
      value ?? this._value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_key': _key,
      '_value': _value,
    };
  }

  factory Parameter.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Parameter(
      map['_key'],
      map['_value'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Parameter.fromJson(String source) =>
      Parameter.fromMap(json.decode(source));

  @override
  String toString() => 'Parameter(_key: $_key, _value: $_value)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Parameter && o._key == _key && o._value == _value;
  }

  @override
  int get hashCode => _key.hashCode ^ _value.hashCode;
}

class ParameterList {
  final _params = List<Parameter>();
  List<Parameter> get params => List.unmodifiable(_params);

  ParameterList();
  ParameterList.fromList(List<Parameter> source) {
    if (null != source) _params.addAll(source);
  }
  ParameterList.fromMap(Map<String, String> map) {
    if (map?.isNotEmpty != true) return;
    map.forEach((key, value) => add(key, value));
  }

  add(String key, String value) {
    if (key?.isNotEmpty != true) throw ArgumentError('key cannot be null');
    _params.add(Parameter(key, value));
  }

  addAll(Iterable<Parameter> iterable) {
    _params.addAll(iterable);
  }

  ParameterList sort() {
    final sorted = List<Parameter>();
    sorted.addAll(_params);
    sorted.sort();
    return ParameterList.fromList(sorted);
  }

  String appendTo(String url) {
    checkNotEmpty(url);
    String queryString = asFormUrlEncodedString;
    if (queryString.isEmpty) return url;
    url += url.indexOf('?') == -1 ? '?' : '&';
    url += queryString;
    return url;
  }

  String get asFormUrlEncodedString {
    if (params.isEmpty) return '';
    String builder = '';
    params.forEach((element) {
      builder += '&${element.asUrlEncodedPair}';
    });
    return builder.substring(1);
  }
}
