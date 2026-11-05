import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

import '../../../../core/network/error_mapper.dart';

import '../../domain/entities/ride_estimate_request_entity.dart';
import '../../domain/entities/ride_estimate_response_entity.dart';
import '../../domain/repository/ride_estimate_repository.dart';
import '../datasource/ride_estimate_datasource.dart';
import '../models/ride_estimate_request_model.dart';

class RideEstimateRepositoryImpl implements RideEstimateRepository {
  final RideEstimateRemoteDataSource remoteDataSource;
  

  RideEstimateRepositoryImpl({
    required this.remoteDataSource,

  });

  @override
Future<Either<Failure, RideEstimateEntity>> getRideEstimate(
  RideEstimateRequestEntity request,
) async {
  try {
    final requestModel = RideEstimateRequestModel.fromEntity(request);

    final response = await remoteDataSource.getRideEstimate(
      requestModel,
    );

    return Right(response);
  } catch (error) {
  return Left(ErrorMapper.map(error));
}
}
}