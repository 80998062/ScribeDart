import 'package:scribedart/src/com.sinyuk.ohnohttp/log/log.dart';

import '../io/resource.dart';
import '../model/request.dart';
import '../model/response.dart';
import 'package:logging/logging.dart';

abstract class OhNoHttpClient implements Resource {
  Logger _logger;
  final PADDING = '  ';
  final appender = PrintAppender(BasicLogFormatter());
  OhNoHttpClient() {
    Logger.root.level = Level.ALL;
    _logger = Logger('ohnohttp.core');
    hierarchicalLoggingEnabled = true;
    appender.attachLogger(_logger);
  }

  Future<Response> send(Request request) => execute<Response>(request, null);

  Future<T> execute<T>(Request request, ResponseConverter<T> converter) async {
    _logger.finest('> General');
    _logger.finest('${PADDING}Request URL: ${request.url.toString()}');
    final verb = VerbMixin.value(request.verb);
    _logger.finest('${PADDING}Request Method: ${verb}');
    final now = DateTime.now().millisecondsSinceEpoch;
    final response = await private_send(request);
    final symbol = (response.code >= 200 && response.code <= 299) ? '🌝' : '🌚';
    _logger.finest('${PADDING}Status Code: ${symbol} ${response.code}');
    final then = DateTime.now().millisecondsSinceEpoch;
    _logger.finest('${PADDING}Elapsed Time: ${then - now} ms');
    _logger.finest('> Request Headers');
    request?.headers?.toMultimap()?.forEach((key, value) {
      if (value?.isNotEmpty == true) {
        final joined = value.join(', ');
        _logger.finest('${PADDING}${key}: ${joined}');
      }
    });
    _logger.finest('> Request Payload');

    if (null == converter) {
      return Future.value(response as T);
    } else {
      return converter.convert(response);
    }
  }

  Future<Response> private_send(Request request);

  @override
  void dispose() {
    appender.stop();
    _logger.clearListeners();
  }
}
