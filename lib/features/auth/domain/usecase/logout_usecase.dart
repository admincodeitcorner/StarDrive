import 'package:dartz/dartz.dart';
import 'package:star_drive/core/error/failure.dart';
import 'package:star_drive/features/auth/domain/repository/auth_repoitory.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, Unit>> call() {
    return repository.logout();
  }
}