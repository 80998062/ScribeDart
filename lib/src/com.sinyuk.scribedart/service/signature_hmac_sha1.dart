import 'dart:async';
import 'dart:convert';

import 'package:scribedart/src/com.sinyuk.scribedart/service/signature_service.dart';
import 'package:crypto/crypto.dart';

/**
 * The "HMAC-SHA1" signature method uses the HMAC-SHA1 signature
 * algorithm as defined in [RFC2104](https://tools.ietf.org/html/rfc2104)
 */
class HMACSha1SignatureService extends SignatureService {
  HMACSha1SignatureService._();
  static final HMACSha1SignatureService _instance =
      HMACSha1SignatureService._();

  static HMACSha1SignatureService get instance => _instance;

  @override
  String get signatureMethod => 'HMAC-SHA1';

  @override
  Future<String> signature(
      String baseString, String apiSecret, String tokenSecret) {
    if (baseString?.isNotEmpty != true)
      return Future.error('Base string cannot be null or empty string');

    String concatenated = '';
    concatenated += apiSecret == null ? '' : Uri.encodeComponent(apiSecret);
    concatenated += '&';
    concatenated += tokenSecret == null ? '' : Uri.encodeComponent(tokenSecret);

    final key = utf8.encode(concatenated);
    final text = utf8.encode(baseString);

    final hmac = Hmac(sha1, key);
    final digest = hmac.convert(text);
    final _signature = base64.encode(digest.bytes);

    return Future.value(_signature);
  }
}
