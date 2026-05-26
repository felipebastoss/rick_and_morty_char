class HttpRequestException implements Exception {
  HttpRequestException({required this.uri, required this.message, this.statusCode, this.responseBody});

  final Uri uri;
  final String message;
  final int? statusCode;
  final String? responseBody;

  @override
  String toString() {
    final code = statusCode == null ? '' : ' (status $statusCode)';
    return 'HttpRequestException: $message$code for $uri';
  }
}

class HttpTooManyRequestsException extends HttpRequestException {
  HttpTooManyRequestsException({
    required super.uri,
    required super.message,
    super.statusCode,
    super.responseBody,
    required this.retryCount,
    this.retryAfter,
  });

  final int retryCount;
  final Duration? retryAfter;
}
