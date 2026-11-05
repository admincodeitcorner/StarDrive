import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/ride_request_response_entity.dart';
import '../repository/ride_request_repository.dart';

class RideRequestUseCase {
  final RideRequestRepository repository;

  RideRequestUseCase({required this.repository});

  Future<Either<Failure, RideRequestResponseEntity>> rideOffer({
    required String estimateId,
    required int offerFare,
  }) async {
    return await repository.rideRequest(estimateId: estimateId, offerFare: offerFare);
  }
}