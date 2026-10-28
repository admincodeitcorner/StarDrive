import 'package:dartz/dartz.dart';
import 'package:star_drive/core/error/failure.dart';

import '../entity/onboard_status.dart';

abstract interface class OnboardingRepository {
  Future<Either<Failure, OnboardingStatus>>
      getOnboardingStatus();
}