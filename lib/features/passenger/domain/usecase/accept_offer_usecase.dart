import 'package:dartz/dartz.dart';

import '../entities/accept_offer_entity.dart';
import '../repository/driver_offer_response_repository.dart';

class AcceptOfferUseCase {
  const AcceptOfferUseCase({
    required this.repository,
  });

  final DriverOfferResponseRepository repository;

  Future<Either<Exception, AcceptOfferResponseEntity>> call({
    required String requestId,
    required int driverProfileId,
  }) {
    return repository.acceptOffer(
      requestId: requestId,
      driverProfileId: driverProfileId,
    );
  }
}