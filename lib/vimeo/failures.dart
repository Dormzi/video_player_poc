abstract class Failure {
  final String message;
  final StackTrace stackTrace;
  final Object? exception;
  Failure({required this.message, StackTrace? stackTrace, this.exception})
      : stackTrace = stackTrace ?? StackTrace.current;
}

class InvalidUrlFormatFailure extends Failure {
  final String url;
  InvalidUrlFormatFailure(this.url) : super(message: 'Invalid url format: $url');
}
