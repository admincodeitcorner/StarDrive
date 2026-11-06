import 'package:dartz/dartz.dart';


import '../repository/driver_offer_response_repository.dart';

class DeclineOfferUseCase {
  const DeclineOfferUseCase({
    required this.repository,
  });

  final DriverOfferResponseRepository repository;

  Future<Either<Exception, void>> call({
    required String requestId,
    required int driverProfileId,
  }) {
    return repository.declineOffer(
      requestId: requestId,
      driverProfileId: driverProfileId,
    );
  }
}