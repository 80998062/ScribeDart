import 'package:scribedart/src/com.sinyuk.scribedart/service/signature_service.dart';

/**
 * A signature service that uses the RSA-SHA1 algorithm.
 */
class RSASha1SignatureService extends SignatureService {
  RSASha1SignatureService._();
  static final RSASha1SignatureService _instance = RSASha1SignatureService._();

  static RSASha1SignatureService get instance => _instance;

  @override
  String get signatureMethod => 'RSA-SHA1';

  @override
  Future<String> signature(
      String baseString, String apiSecret, String tokenSecret) {
    // TODO: implement signature
    throw UnimplementedError();
  }
}
