import 'package:dartz/dartz.dart';

import '../entities/accept_offer_entity.dart';


abstract class DriverOfferResponseRepository {
  /// Accepts an incoming ride offer and returns the accepted ride details.
  Future<Either<Exception, AcceptOfferResponseEntity>> acceptOffer({
    required String requestId,
    required int driverProfileId,
  });

  /// Declines an incoming ride offer.
  Future<Either<Exception, void>> declineOffer({
    required String requestId,
    required int driverProfileId,
  });
}