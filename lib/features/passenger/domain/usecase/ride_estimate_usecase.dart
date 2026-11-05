import 'package:dartz/dartz.dart';
import 'package:star_drive/core/error/failure.dart';

import '../entities/ride_estimate_request_entity.dart';
import '../entities/ride_estimate_response_entity.dart';
import '../repository/ride_estimate_repository.dart';

class GetRideEstimate {
  final RideEstimateRepository repository;

  const GetRideEstimate(this.repository);

  Future<Either<Failure, RideEstimateEntity>> call(
    RideEstimateRequestEntity request,
  ) {
    return repository.getRideEstimate(request);
  }
}