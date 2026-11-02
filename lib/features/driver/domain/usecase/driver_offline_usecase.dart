import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/driver_offline_entity.dart';
import '../repositories/driver_availablity_repository.dart';

class DriverOfflineUseCase {
  final DriverAvailabilityRepository repository;

  DriverOfflineUseCase(this.repository);

  Future<Either<Failure, DriverOfflineEntity>> call({
    required double lat,
    required double lon,
  }) {
    return repository.setOffline(
      lat: lat,
      lon: lon,
    );
  }
}