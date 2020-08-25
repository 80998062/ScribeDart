import 'package:scribedart/src/com.sinyuk.scribedart/model/oauth_constant.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/model/oauth_request.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/utils/precondition.dart';

/**
 * Simple command object that generates an OAuth Authorization header to include in the request.
 */
abstract class Oauth10HeaderBuilder {
  static final Oauth10HeaderBuilder _instance = _Oauth10HeaderBuilderImpl._();

  static Oauth10HeaderBuilder get instance => _instance;

  /**
  * Generates an OAuth 'Authorization' Http header to include in requests as the signature.
  */
  String build(OAuthRequest request);
}

/**
 * Default implementation of [HeaderExtractor]. Conforms to OAuth 1.0a
 */
class _Oauth10HeaderBuilderImpl extends Oauth10HeaderBuilder {
  _Oauth10HeaderBuilderImpl._();

  static final String PARAM_SEPARATOR = ', ';
  static final String PREAMBLE = 'OAuth ';
  @override
  String build(OAuthRequest request) {
    checkNotNull(request,
        message: 'Cannot extract a header from a null object');
    checkArgument(request.oauthParameters.isNotEmpty,
        message: 'Could not find oauth parameters in request');
    var header = PREAMBLE;
    request.oauthParameters.forEach((key, value) {
      if (header.length > PREAMBLE.length) header += PARAM_SEPARATOR;
      // The reason for using [encodeQueryComponent] is that [encodeComponent] does not encode `*`;
      // TODO: add more detailed reason
      header += '${key}="${Uri.encodeQueryComponent(value)}"';
    });
    if (null != request.realm && request.realm.length > 0) {
      header += PARAM_SEPARATOR;
      header += '${OAuthConstants.REALM}="${request.realm}"';
    }

    return header;
  }
}

main(List<String> args) {
  print(Uri.encodeQueryComponent(r'AS#$^*@&'));
}
