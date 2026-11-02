import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/driver_availability_entity.dart';
import '../entities/driver_offline_entity.dart';

abstract interface class DriverAvailabilityRepository {
  Future<Either<Failure, DriverAvailabilityEntity>> setOnline({
    required double lat,
    required double lon,
  });
    Future<Either<Failure, DriverOfflineEntity>> setOffline({
    required double lat,
    required double lon,
  });
}