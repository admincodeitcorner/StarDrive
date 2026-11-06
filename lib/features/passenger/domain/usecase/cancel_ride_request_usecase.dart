import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../repository/ride_request_repository.dart';

class CancelRideRequestUseCase {
  final RideRequestRepository repository;

  CancelRideRequestUseCase({
    required this.repository,
  });

  // Executes the cancellation of an active passenger ride request.
  Future<Either<Failure, bool>> call({
    required String requestId,
  }) {
    return repository.cancelRideRequest(
      requestId: requestId,
    );
  }
}