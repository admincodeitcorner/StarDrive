import 'package:star_drive/core/error/exception.dart';
import 'package:star_drive/core/error/failure.dart';

class ErrorMapper {
  ErrorMapper._();

  static Failure map(Exception exception) {
    if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    }

    if (exception is TimeoutException) {
      return TimeoutFailure(exception.message);
    }

    if (exception is ServerException) {
      // Status code ke mutabiq failure
      if (exception.statusCode == 400 || exception.statusCode == 422) {
        return ValidationFailure(exception.message);
      }

      return ServerFailure(exception.message);
    }

    if (exception is ParsingException) {
      return UnexpectedFailure(exception.message);
    }

    return UnexpectedFailure(exception.toString());
  }
}
