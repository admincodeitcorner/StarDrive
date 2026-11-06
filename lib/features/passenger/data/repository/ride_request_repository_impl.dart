import 'package:dartz/dartz.dart';

import 'package:star_drive/core/error/failure.dart';

import 'package:star_drive/features/passenger/domain/entities/ride_request_response_entity.dart';

import '../../../../core/network/error_mapper.dart';
import '../../domain/repository/ride_request_repository.dart';
import '../datasource/ride_request_data_source.dart';

class RideRequestRepositoryImpl implements RideRequestRepository {
  final RideRequestRemoteDataSource remoteDataSource;
  RideRequestRepositoryImpl({
    required this.remoteDataSource,
  });
    @override
  Future<Either<Failure, RideRequestResponseEntity>> rideRequest({
    required String estimateId,
    required int offerFare,
  }) async {
    try {
      final result = await remoteDataSource.requestRide(estimateId, offerFare);

      final response =
          result.fold<Either<Failure, RideRequestResponseEntity>>(
        (exception) => Left(ErrorMapper.map(exception)),
        (model) => Right(model),
      );

      return response;
    } catch (error) {
      return Left(ErrorMapper.map(error));
    }
  }

  @override
Future<Either<Failure, bool>> cancelRideRequest({
  required String requestId,
}) async {
  try {
    final result = await remoteDataSource.cancelRideRequest(
      requestId,
    );

    return result.fold(
      (exception) => Left(ErrorMapper.map(exception)),
      (isCancelled) => Right(isCancelled),
    );
  } catch (error) {
    return Left(ErrorMapper.map(error));
  }
}
}