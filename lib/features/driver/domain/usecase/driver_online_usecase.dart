import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

import '../entities/driver_availability_entity.dart';
import '../repositories/driver_availablity_repository.dart';

class DriverOnlineUseCase {
  final DriverAvailabilityRepository repository;

  DriverOnlineUseCase(this.repository);

  Future<Either<Failure, DriverAvailabilityEntity>> call({
    required double lat,
    required double lon,
  }) {
    return repository.setOnline(lat: lat, lon: lon);
  }
}