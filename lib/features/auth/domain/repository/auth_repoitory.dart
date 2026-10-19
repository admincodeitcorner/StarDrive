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
  required String contactNumber,
  required String role,
  required String password,
  required String otpCode,
  required String fcmToken,
  required String androidId,
  String? fatherName,
  String? cnic,
  String? address,
  String? dob,
});

  Future<AuthUser> loginWithCredentials({
    required String contactNumber,
    required String password,
    required String fcmToken,
    required String androidId,
  });
 Future<void> verifyOtp({
  required String contactNumber,
  required String code,
});

Future<ResetPasswordResponseModel> resetPassword(
    ResetPasswordRequestModel request,
  );
}
