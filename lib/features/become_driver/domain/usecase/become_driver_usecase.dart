import 'package:dartz/dartz.dart';
import 'package:star_drive/core/error/failure.dart';
import 'package:star_drive/features/become_driver/data/models/become_driver_request_model.dart';
import 'package:star_drive/features/become_driver/domain/entity/become_driver_request_entity.dart';
import 'package:star_drive/features/become_driver/domain/entity/become_driver_response_entity.dart';
import 'package:star_drive/features/become_driver/domain/repositories/become_driver_repository.dart';

class BecomeDriverUseCase {
  final BecomeDriverRepository repository;

  BecomeDriverUseCase(this.repository);

  Future<Either<Failure, BecomeDriverResponseEntity>> call(
    BecomeDriverRequestEntity request,
  ) {
    return repository.becomeDriver(request);
  }
}