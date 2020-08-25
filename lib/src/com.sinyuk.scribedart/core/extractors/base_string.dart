import 'dart:convert';

import 'package:scribedart/src/com.sinyuk.ohnohttp/model/request.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/model/oauth_constant.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/model/paramter.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/utils/precondition.dart';

import '../../model/oauth_request.dart';

/**
 * Default implementation of [BaseStringExtractor]. Conforms to **OAuth 1.0a**
 * 
 * See [refers to](https://tools.ietf.org/html/rfc5849#section-3.4.1.1) for more details
 * 
 */

class BaseStringExtractor {
  BaseStringExtractor._privateConstructor();
  static final BaseStringExtractor _instance =
      BaseStringExtractor._privateConstructor();

  static BaseStringExtractor get instance => _instance;

  OAuthRequest _request;
  set request(OAuthRequest request) {
    this._request = request;
  }

  static final _NULL_EXCEPTION =
      'Cannot extract base string from a null object';

  /// The signature base string is constructed by concatenating together,
  /// in order, the following HTTP request elements:
  String get verb {
    checkNotNull(_request, message: _NULL_EXCEPTION);
    return VerbMixin.value(_request.verb).toUpperCase();
  }

  /// The base string URI from (Section 3.4.1.2)[https://tools.ietf.org/html/rfc5849#section-3.4.1.2],
  /// after being encoded (Section 3.6)[https://tools.ietf.org/html/rfc5849#section-3.6]
  String get uri {
    checkNotNull(_request, message: _NULL_EXCEPTION);
    var _uri = '';
    final _schema = _request.url.scheme().toLowerCase();
    final _port = _request.url.port();
    // The scheme and host MUST be in lowercase
    _uri += _schema;
    // ignore: todo
    // TODO: The host and port values MUST match the content of the HTTP request "Host" header field.

    _uri += '://${_request.url.host()}';
    // The port MUST be included if it is not the default port
    if ((_schema == 'http' && _port != 80) ||
        (_schema == 'https' && _port != 443)) {
      _uri += ':$_port';
    }

    if (!_uri.endsWith('/')) _uri += '/';
    if (_request.url.pathSegments().isEmpty) return _uri;

    _uri += _request.url.pathSegments().join('/');

    return _uri;
  }

  /// The HTTP request entity-body
  Future<ParameterList> get bodyParameters async {
    checkNotNull(_request, message: _NULL_EXCEPTION);
    final body = _request.body;
    final length = body?.contentLength() ?? 0;
    final list = ParameterList();
    if (null == body || null == body.contentType() || 0 == length) return list;
    // The entity-body follows the encoding requirements of the
    // "application/x-www-form-urlencoded" content-type
    final bodyContentType = body.contentType();
    if (bodyContentType.type() != 'application' ||
        bodyContentType.subtype() != 'x-www-form-urlencoded') {
      throw ArgumentError.value(bodyContentType.toString(),
          'body\'s ContentType', 'Must be "application/x-www-form-urlencoded"');
    }

    // The HTTP request entity-header includes the "Content-Type"
    // header field set to "application/x-www-form-urlencoded"
    final headerContentType = _request.headers.value('Content-Type');
    if (headerContentType != 'application/x-www-form-urlencoded')
      throw ArgumentError.value(headerContentType, '"Content-Type" in headers',
          'Must be "application/x-www-form-urlencoded"');

    var formData = '';
    // convert string to map
    await body.source().forEach((element) {
      formData += utf8.decode(element);
    });

    // Since spaces are replaced by "+" in the form data, and then "+" will be decoded into "%2B",
    // we first need to decode the parameter back
    // so for example: a3=2+q => a3=2 q => a3=2%20q
    for (String keyValue in formData.split(RegExp(' *& *'))) {
      final pairs = keyValue.split(RegExp(' *= *'));
      String optionalValue = pairs.length == 2 ? pairs[1] : '';
      optionalValue =
          Uri.encodeComponent(Uri.decodeQueryComponent(optionalValue));
      list.add(pairs[0], optionalValue);
    }
    return list;
  }

  /// The query component of the HTTP request URI as defined by
  /// [[RFC3986], Section 3.4](https://tools.ietf.org/html/rfc3986#section-3.4)
  ParameterList get queryParameters {
    checkNotNull(_request, message: _NULL_EXCEPTION);
    final list = ParameterList();
    // decoding them as defined by [W3C.REC-html40-19980424], Section 17.13.4.
    _request.url.queryParametersAll().forEach((key, value) {
      list.add(key, value.join(';'));
    });
    return list;
  }

  /// The parameters from the following sources are collected into a single
  /// list of name/value pairs:
  Map<String, String> get oauthParameters {
    checkNotNull(_request, message: _NULL_EXCEPTION);
    if (_request.oauthParameters?.isNotEmpty != true)
      return Map<String, String>();

    final _oauthParameters = _request.oauthParameters;
    // excluding the "realm" parameter if present
    _oauthParameters.remove(OAuthConstants.REALM);
    // The "oauth_signature" parameter MUST be excluded
    _oauthParameters.remove(OAuthConstants.SIGNATURE);
    return _oauthParameters;
  }

  /**
   * Extracts an url-encoded base string from the [OAuthRequest].
   * 
   * See [the oauth spec](http://oauth.net/core/1.0/#anchor14) for more info on this.
   *
   */
  Future<String> concatenated() async {
    checkNotNull(_request, message: _NULL_EXCEPTION);
    final list = ParameterList();
    list.addAll(queryParameters.params);
    final _bodyParams = (await bodyParameters).params;
    list.addAll(_bodyParams);
    oauthParameters.forEach((key, value) => list.add(key, value));

    String concatenatedParams = '';
    // Note: We need to encode the parameters first and then sort them by name.
    final _encoded = ParameterList.fromList(
        list.params.map((e) => e.encoded()).toList(growable: false));

    // '%26' represents '&' and '%3D' represents '='
    _encoded.sort().params.forEach((e) {
      concatenatedParams += '%26${e.key}%3D${e.value}';
    });
    concatenatedParams = concatenatedParams.replaceFirst('%26', '');
    return '${verb}&${Uri.encodeComponent(uri)}&$concatenatedParams';
  }
}

main(List<String> args) {
  print(Uri.encodeFull('http://gitlab.alibaba-inc.com/'));
  print(Uri.encodeComponent('http://gitlab.alibaba-inc.com/'));
  print(Uri.encodeQueryComponent('http://gitlab.alibaba-inc.com/'));
}
