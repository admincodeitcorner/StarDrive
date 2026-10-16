import 'package:star_drive/features/auth/domain/repository/auth_repoitory.dart';

import '../enums/otp_purpose.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<void> call({
    required String contactNumber,
    required OtpPurpose purpose,
    required String code,
  }) {
    return repository.verifyOtp(
      contactNumber: contactNumber,
      
      code: code,
    );
  }
}