import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/ride_request_response_entity.dart';

abstract interface class RideRequestRepository {
  Future<Either<Failure, RideRequestResponseEntity>> rideRequest({
    required String estimateId,
    required int offerFare,
  });
   
}