import 'package:dio/dio.dart';
import 'package:star_drive/core/error/exception.dart';
import 'package:star_drive/core/error/failure.dart';

class ErrorMapper {
  ErrorMapper._();

static Failure map(Object error) {
  // Dio Exception
  if (error is DioException) {
    final responseData = error.response?.data;

    final message = responseData is Map
        ? responseData['message']?.toString()
        : null;

    return ServerFailure(
      message ?? error.message ?? 'Something went wrong',
    );
  }

  if (error is NetworkException) {
    return NetworkFailure(error.message);
  }

  if (error is TimeoutException) {
    return TimeoutFailure(error.message);
  }

  if (error is ServerException) {
    if (error.statusCode == 400 || error.statusCode == 422) {
      return ValidationFailure(error.message);
    }

    return ServerFailure(error.message);
  }

  if (error is ParsingException) {
    return UnexpectedFailure(error.message);
  }

  return UnexpectedFailure(error.toString());
}}
