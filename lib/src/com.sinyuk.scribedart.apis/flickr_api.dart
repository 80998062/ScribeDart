import 'package:scribedart/src/com.sinyuk.scribedart/core/builder/api/api_10a.dart';

/**
 * OAuth API for [Flickr](http://www.flickr.com/services/api/).
 */
class FlickrApi extends DefaultApi10a {
  static final String AUTHORIZE_URL =
      "https://www.flickr.com/services/oauth/authorize";

  String permString;

  FlickrApi._();
  static final FlickrApi _instance = FlickrApi._();

  static FlickrApi get instance => _instance;

  FlickrApi([FlickrPerm perm]) {
    switch (perm) {
      case FlickrPerm.READ:
        this.permString = 'READ'.toLowerCase();
        break;
      case FlickrPerm.WRITE:
        this.permString = 'WRITE'.toLowerCase();
        break;
      case FlickrPerm.DELETE:
        this.permString = 'DELETE'.toLowerCase();
        break;
      default:
        break;
    }
  }

  @override
  String get accessTokenEndpoint =>
      'https://www.flickr.com/services/oauth/access_token';

  @override
  String get authorizationBaseUrl =>
      permString == null ? AUTHORIZE_URL : '${AUTHORIZE_URL}?perms=$permString';

  @override
  String get requestTokenEndpoint =>
      'https://www.flickr.com/services/oauth/request_token';
}

enum FlickrPerm { READ, WRITE, DELETE }
