import 'package:dartz/dartz.dart';

import '../../domain/repositories/send_offer_repository.dart';
import '../datasource/signalr/send_offer_remote.dart';


class SendOfferRepositoryImpl implements SendOfferRepository {
  SendOfferRepositoryImpl({
    required this.remoteDataSource,
  });

  final SendOfferSignalRDataSource remoteDataSource;

  @override
  Future<Either<Exception, Object?>> sendOffer({
    required String rideId,
    required int offeredFare,
  }) async {
    try {
      final response = await remoteDataSource.sendOffer(
        rideId: rideId,
        offeredFare: offeredFare,
      );

      return Right(response);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}