import 'package:dartz/dartz.dart';
import 'package:star_drive/core/error/failure.dart';

import '../entity/onboard_status.dart';
import '../repositories/onboard_status_repository.dart';


class OnboardingStatusUseCase {
  final OnboardingRepository repository;

  OnboardingStatusUseCase(this.repository);

  Future<Either<Failure, OnboardingStatus>> call() {
    return repository.getOnboardingStatus();
  }
}