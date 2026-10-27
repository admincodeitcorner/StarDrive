import 'package:dartz/dartz.dart';
import 'package:star_drive/core/error/failure.dart';
import 'package:star_drive/features/become_driver/data/models/become_driver_request_model.dart';
import 'package:star_drive/features/become_driver/domain/entity/become_driver_request_entity.dart';

import 'package:star_drive/features/become_driver/domain/entity/become_driver_response_entity.dart';

abstract interface class BecomeDriverRepository {
  Future<Either<Failure, BecomeDriverResponseEntity>> becomeDriver(
    BecomeDriverRequestEntity request,
  );
}