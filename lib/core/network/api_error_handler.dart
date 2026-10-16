import 'package:dio/dio.dart';
import 'package:star_drive/core/error/exception.dart';



import 'package:dio/dio.dart';

class ApiErrorHandler {
  ApiErrorHandler._();

  static Exception handle(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();

      case DioExceptionType.connectionError:
        return const NetworkException();

      case DioExceptionType.badResponse:
        final body = error.response?.data;
        final message = body is Map
            ? body['message']?.toString()
            : null;

        return ServerException(
          message: message?.isNotEmpty == true
              ? message!
              : 'Server error occurred',
          statusCode: error.response?.statusCode,
        );

      default:
        return const NetworkException(
          message: 'An unexpected network error occurred.',
        );
    }
  }

  static String _messageForStatus(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Invalid request data';
      case 401:
        return 'Authentication failed';
      case 403:
        return 'Permission denied';
      case 404:
        return 'Resource not found';
      case 409:
        return 'Account or information already exists';
      case 422:
        return 'Validation failed';
      case 429:
        return 'Too many requests';
      case 500:
      case 502:
      case 503:
      case 504:
        return 'Server error. Please try again later';
      default:
        return 'Request failed. Please try again';
    }
  }
}