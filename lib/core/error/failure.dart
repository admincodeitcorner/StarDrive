abstract interface class Failure {
  final String message;

  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'Server error occurred',
  ]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Please check your internet connection',
  ]);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([
    super.message = 'Request timed out',
  ]);
}

class ValidationFailure extends Failure {
  const ValidationFailure([
    super.message = 'Invalid input',
  ]);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([
    super.message = 'Something went wrong',
  ]);
}