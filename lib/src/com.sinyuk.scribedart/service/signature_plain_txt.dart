import 'package:scribedart/src/com.sinyuk.scribedart/service/signature_service.dart';

/**
 * plaintext implementation of [SinatureService]
 */
class PlaintextSignatureService extends SignatureService {
  PlaintextSignatureService._();
  static final PlaintextSignatureService _instance =
      PlaintextSignatureService._();

  static PlaintextSignatureService get instance => _instance;

  @override
  String get signatureMethod => 'PLAINTEXT';

  @override
  Future<String> signature(
      String baseString, String apiSecret, String tokenSecret) {
    if (apiSecret?.isNotEmpty != true)
      return Future.error('Api secret cant be null or empty string');
    final _signature =
        '${Uri.decodeComponent(apiSecret)}&${Uri.decodeComponent(tokenSecret)}';
    return Future.value(_signature);
  }
}
