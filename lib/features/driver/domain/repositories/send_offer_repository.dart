import 'package:dartz/dartz.dart';

abstract class SendOfferRepository {
  Future<Either<Exception, Object?>> sendOffer({
    required String rideId,
    required int offeredFare,
  });
}