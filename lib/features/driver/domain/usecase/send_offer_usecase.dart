import 'package:dartz/dartz.dart';

import '../repositories/send_offer_repository.dart';

class SendOfferUseCase {
  SendOfferUseCase({
    required this.repository,
  });

  final SendOfferRepository repository;

  Future<Either<Exception, Object?>> call({
    required String rideId,
    required int offeredFare,
  }) async {
    return await repository.sendOffer(
      rideId: rideId,
      offeredFare: offeredFare,
    );
  }
}