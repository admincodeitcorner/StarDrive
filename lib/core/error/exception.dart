class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({
    this.message = 'Server error occurred',
    this.statusCode,
  });
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({
    this.message = 'Please check your internet connection',
  });
}

class TimeoutException implements Exception {
  final String message;

  const TimeoutException({
    this.message = 'Request timed out',
  });
}

class ParsingException implements Exception {
  final String message;

  const ParsingException({
    this.message = 'Invalid server response',
  });
}