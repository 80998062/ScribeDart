import 'package:scribedart/src/com.sinyuk.ohnohttp/model/response.dart';
import 'package:scribedart/src/com.sinyuk.scribedart/model/token.dart';

/**
 * Simple command object that extracts a concrete [Token] from a String
 * [T] concrete type of [Token]
 */
abstract class TokenExtractor<T extends Token> {
  /**
   * Extracts the concrete type of token from the contents of an Http Response
   */
  Future<T> extract(Response response);
}
