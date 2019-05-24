import 'package:flutter/foundation.dart';

CausedException getCausedExceptionWithErrorCode({String code}) {
  Map<String, Exception> _exceptionMap = {
    "Error 17007": new CausedException(cause: 'Firebase Auth', code: code, message: "email in use", userMessage: "Looks like someone's already using that email address."),
  };

  return _exceptionMap[code];
}
class CausedException implements Exception {
  CausedException({
    @required this.code,
    @required this.message,
    @required this.userMessage,
    @required this.cause,
  });

  /// An error code.
  final String code;

  /// A human-readable error message for debug logging.
  final String message;

  /// An error message to display to the user.
  final String userMessage;

  // The underlying framework, library, or API that caused the exception to be thrown.
  final String cause;

  @override
  String toString() => 'CausedException($cause, $code, $message)';

  void debugPrint() => print(this.toString());
}