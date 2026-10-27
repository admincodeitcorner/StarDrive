import 'package:dartz/dartz.dart';
import 'package:star_drive/core/error/failure.dart';
import 'package:star_drive/core/network/error_mapper.dart';
import 'package:star_drive/core/storage/token_storage.dart';

import 'package:star_drive/features/become_driver/data/models/become_driver_request_model.dart';
import 'package:star_drive/features/become_driver/domain/entity/become_driver_request_entity.dart';
import 'package:star_drive/features/become_driver/domain/entity/become_driver_response_entity.dart';

import 'package:star_drive/features/become_driver/domain/repositories/become_driver_repository.dart';

import '../data_source/become_driver_remote_dataSource.dart';

class BecomeDriverRepositoryImpl implements BecomeDriverRepository {
  final BecomeDriverRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage;

  BecomeDriverRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenStorage,
  });

  @override
  Future<Either<Failure, BecomeDriverResponseEntity>> becomeDriver(
    BecomeDriverRequestEntity request,
  ) async {
  final requestModel = BecomeDriverRequestModel.fromEntity(request);

  final result = await remoteDataSource.becomeDriver(requestModel);
    return result.fold(
      (exception) => Left(ErrorMapper.map(exception)),
      (response) async {
        if (response.code != '0000') {
          return Left(
            ServerFailure(response.message),
          );
        }

        final data = response.data;

        if (data == null) {
          return Left(
            UnexpectedFailure('Driver profile response data is empty.'),
          );
        }

        try {

          if (data.token.isEmpty) {
            return Left(
              UnexpectedFailure('Authentication token is missing.'),
            );
          }

          await tokenStorage.saveToken(data.token);

          return Right(data);
        } catch (e) {
          return Left(
            UnexpectedFailure('Unable to save driver session: $e'),
          );
        }
      },
    );
  }
}