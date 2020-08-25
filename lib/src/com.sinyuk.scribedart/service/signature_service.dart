import 'package:scribedart/src/com.sinyuk.scribedart/service/signature_hmac_sha1.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/service/signature_plain_txt.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/service/signature_rsasha1.dart';

/**
 * Signs a base string, returning the OAuth [Signature](https://tools.ietf.org/html/rfc5849#section-3.4)
 * 
 * OAuth provides three methods for the client to prove its rightful
 * ownership of the credentials: "HMAC-SHA1", "RSA-SHA1", and
 * "PLAINTEXT". 
 */
abstract class SignatureService {
  static get RSASha1 => RSASha1SignatureService.instance;
  static get HMACSha1 => HMACSha1SignatureService.instance;
  static get PlainText => PlaintextSignatureService.instance;

  /**
   * - `baseString`   :url-encoded string to sign
   * - `apiSecret`    :api secret for your app
   * - `baseString`   :token secret, *empty string for the request token step*
   */
  Future<String> signature(
      String baseString, String apiSecret, String tokenSecret);

  String get signatureMethod => throw UnimplementedError();
}
