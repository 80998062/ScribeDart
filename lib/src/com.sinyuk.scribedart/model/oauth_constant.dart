/**
 * This class contains OAuth constants, used project-wide
 */
abstract class OAuthConstants {
  static final TIMESTAMP = 'oauth_timestamp';
  static final SIGN_METHOD = 'oauth_signature_method';
  static final SIGNATURE = 'oauth_signature';
  static final CONSUMER_SECRET = 'oauth_consumer_secret';
  static final CONSUMER_KEY = 'oauth_consumer_key';
  static final CALLBACK = 'oauth_callback';
  static final VERSION = 'oauth_version';
  static final NONCE = 'oauth_nonce';
  static final REALM = 'realm';
  static final PARAM_PREFIX = 'oauth_';
  static final TOKEN = 'oauth_token';
  static final TOKEN_SECRET = 'oauth_token_secret';
  static final VERIFIER = 'oauth_verifier';
  static final HEADER = 'Authorization';
  static final SCOPE = 'scope';
  static final BASIC = 'Basic';

  // OAuth 1.0
  /**
     * to indicate an out-of-band configuration
     * @see <a href='https://tools.ietf.org/html/rfc5849#section-2.1'>The OAuth 1.0 Protocol</a>
     */
  static final OOB = 'oob';

  // OAuth 2.0
  static final ACCESS_TOKEN = 'access_token';
  static final CLIENT_ID = 'client_id';
  static final CLIENT_SECRET = 'client_secret';
  static final REDIRECT_URI = 'redirect_uri';
  static final CODE = 'code';
  static final REFRESH_TOKEN = 'refresh_token';
  static final GRANT_TYPE = 'grant_type';
  static final AUTHORIZATION_CODE = 'authorization_code';
  static final CLIENT_CREDENTIALS = 'client_credentials';
  static final STATE = 'state';
  static final USERNAME = 'username';
  static final PASSWORD = 'password';
  static final RESPONSE_TYPE = 'response_type';
  static final RESPONSE_TYPE_CODE = 'code';

  //not OAuth specific
  static final USER_AGENT_HEADER_NAME = 'User-Agent';
}
