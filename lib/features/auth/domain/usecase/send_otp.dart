import 'package:star_drive/features/auth/domain/enums/otp_purpose.dart';

import '../entities/otp_details.dart';
import '../repository/auth_repoitory.dart';

class SendOtp {
  final AuthRepository repository;

  const SendOtp(this.repository);

  Future<OtpDetails> call({
    required String contactNumber,
    String?  cnic,
    required OtpPurpose purpose,
  }) {
    return repository.sendOtp(
      contactNumber: contactNumber,
      cnic: cnic,
      purpose: purpose,
    );
  }
}