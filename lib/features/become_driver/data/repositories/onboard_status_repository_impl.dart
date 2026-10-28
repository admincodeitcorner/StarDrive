import 'package:dartz/dartz.dart';
import 'package:star_drive/core/error/failure.dart';

import '../../domain/entity/onboard_status.dart';
import '../../domain/repositories/onboard_status_repository.dart';
import '../data_source/on_board_status_remote_datasource.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingRemoteDataSource remoteDataSource;

  OnboardingRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, OnboardingStatus>>
      getOnboardingStatus() async {
    try {
      final result = await remoteDataSource.getOnboardingStatus();
      return Right(result);
    } catch (e) {
      
      return Left(
        ServerFailure(e.toString()),
      );
    }
  }
}