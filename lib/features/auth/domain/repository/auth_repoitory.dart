import 'package:star_drive/features/auth/data/model/reset_password_model.dart';
import 'package:star_drive/features/auth/data/model/reset_response_model.dart';
import 'package:star_drive/features/auth/domain/entities/otp_details.dart';
import 'package:star_drive/features/auth/domain/enums/otp_purpose.dart';

import '../entities/auth_user.dart';

abstract interface class AuthRepository {
  Future<OtpDetails> sendOtp({
    required String contactNumber,
    String? cnic,
    required OtpPurpose purpose,
  });
  Future<AuthUser> registerWithDetails({
    required String name,
    required String fatherName,
    required String cnic,
    required String contactNumber,
    required String address,
    required String role,
    required String dob,
    required String password,
    required String otpCode,
    required String fcmToken,
    required String androidId,
  });

  Future<AuthUser> loginWithCredentials({
    required String contactNumber,
    required String password,
    required String fcmToken,
    required String androidId,
  });
 Future<void> verifyOtp({
  required String contactNumber,
  required OtpPurpose purpose,
  required String code,
});

Future<ResetPasswordResponseModel> resetPassword(
    ResetPasswordRequestModel request,
  );
}
