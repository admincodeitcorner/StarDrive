import 'package:dartz/dartz.dart';
import 'package:star_drive/core/error/failure.dart';

import 'package:star_drive/features/auth/domain/enums/otp_purpose.dart';
import '../entities/otp_details.dart';

import '../repository/auth_repoitory.dart';

class SendOtpUsecase {
  final AuthRepository repository;

  const SendOtpUsecase(this.repository);

  Future<Either<Failure, OtpDetails>> call({
    required String contactNumber,
    String? cnic,
    required OtpPurpose purpose,
  }) {
    return repository.sendOtp(
      contactNumber: contactNumber,
      cnic: cnic,
      purpose: purpose,
    );
  }
}
