import 'package:dartz/dartz.dart';
import 'package:star_drive/core/error/failure.dart';

import '../../data/models/ride_estimate_request_model.dart';
import '../entities/ride_estimate_request_entity.dart';
import '../entities/ride_estimate_response_entity.dart';


abstract interface class RideEstimateRepository {
  Future<Either<Failure, RideEstimateEntity>> getRideEstimate(
    RideEstimateRequestEntity  request,
  );
}