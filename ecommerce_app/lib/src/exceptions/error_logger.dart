import 'package:ecommerce_app/src/exceptions/app_exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorLogger {
  void logError(Object error, StackTrace? stack) {
    // * This can be replaced with a call to a crash reporting tool of choice
    debugPrint('$error, $stack');
  }

  void logAppException(AppException exception) {
    // * This can be replaced with a call to a crash reporting tool of choice
    debugPrint('$exception');
  }
}

final errorLoggerProvider = Provider<ErrorLogger>((ref) {
  return ErrorLogger();
});
