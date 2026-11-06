import 'package:dartz/dartz.dart';

import '../../domain/entities/accept_offer_entity.dart';
import '../../domain/repository/driver_offer_response_repository.dart';
import '../datasource/driver_offer_response_datasource.dart';

class DriverOfferResponseRepositoryImpl
    implements DriverOfferResponseRepository {
  const DriverOfferResponseRepositoryImpl({
    required this._remoteDataSource,
  });

  final DriverOfferResponseRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Exception, AcceptOfferResponseEntity>> acceptOffer({
    required String requestId,
    required int driverProfileId,
  }) async {
    final result = await _remoteDataSource.acceptOffer(
      requestId: requestId,
      driverProfileId: driverProfileId,
    );

    return result.fold(
      (exception) => Left<Exception, AcceptOfferResponseEntity>(
        exception,
      ),
      (model) => Right<Exception, AcceptOfferResponseEntity>(
        model,
      ),
    );
  }

  @override
  Future<Either<Exception, void>> declineOffer({
    required String requestId,
    required int driverProfileId,
  }) async {
    return _remoteDataSource.declineOffer(
      requestId: requestId,
      driverProfileId: driverProfileId,
    );
  }
}