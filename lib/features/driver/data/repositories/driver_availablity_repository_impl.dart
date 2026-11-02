import 'package:dartz/dartz.dart';
import 'package:star_drive/core/network/error_mapper.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/driver_availability_entity.dart';
import '../../domain/entities/driver_offline_entity.dart';
import '../../domain/repositories/driver_availablity_repository.dart';
import '../datasource/driver_availablity_datasource.dart';

class DriverAvailabilityRepositoryImpl
    implements DriverAvailabilityRepository {
  final DriverAvailabilityRemoteDataSource remoteDataSource;

  DriverAvailabilityRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, DriverAvailabilityEntity>> setOnline({
    required double lat,
    required double lon,
  }) async {
    try {
      final result = await remoteDataSource.setOnline(
        lat: lat,
        lon: lon,
      );

      return Right(result);
    } catch (error) {
      return Left(ErrorMapper.map(Exception(error.toString())));
    }
  }

  @override
  Future<Either<Failure, DriverOfflineEntity>> setOffline({
    required double lat,
    required double lon,
  }) async {
    try {
      final result = await remoteDataSource.setOffline(
        lat: lat,
        lon: lon,
      );

      return Right(result);
    } catch (error) {
      return Left(ErrorMapper.map(Exception(error.toString())));
    }
  }
}