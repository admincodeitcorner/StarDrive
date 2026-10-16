import 'package:star_drive/features/auth/data/dataresource/auth_remote_datasource.dart';
import 'package:star_drive/features/auth/data/model/login_request_model.dart';
import 'package:star_drive/features/auth/data/model/otp_request_model.dart';
import 'package:star_drive/features/auth/data/model/reset_password_model.dart';
import 'package:star_drive/features/auth/data/model/reset_response_model.dart';
import 'package:star_drive/features/auth/data/model/verify_request_model.dart';
import 'package:star_drive/features/auth/domain/entities/otp_details.dart';
import 'package:star_drive/features/auth/domain/enums/otp_purpose.dart';
import 'package:star_drive/features/auth/domain/repository/auth_repoitory.dart';

import '../../domain/entities/auth_user.dart';
import '../model/register_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);
@override
Future<OtpDetails> sendOtp({
  required String contactNumber,
   String? cnic,
  required OtpPurpose purpose
}) async {
  final result = await remoteDataSource.sendOtp(
    SendOtpRequestModel(
      contactNumber: contactNumber,
      cnic: cnic,
      purpose: purpose
    
    ),
  );
 final otpDetails = result.data;

if (otpDetails == null) {
  throw Exception('OTP response data is missing.');
}
  return otpDetails;
}

@override
Future<void> verifyOtp({
  required String contactNumber,
  
  required String code,
}) async {
  final request = VerifyRequestModel(
    contactNumber: contactNumber,
    otpCode: code,

  );

  await remoteDataSource.verifyOtp(request);
}
  @override
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
  }) async {
    final request = RegisterRequestModel(
      name: name,
      fatherName: fatherName,
      cnic: cnic,
      contactNumber: contactNumber,
      address: address,
      role: role,
      dob: dob,
      password: password,
      fcmToken: fcmToken,
      androidId: androidId, 
      otpCode: otpCode
    );

    return remoteDataSource.register(request);
  }
  @override
Future<AuthUser> loginWithCredentials({
  required String contactNumber,
  required String password,
  required String fcmToken,
  required String androidId,
}) async {
  final request = LoginRequestModel(
    contactNumber: contactNumber,
    password: password,
    fcmToken: fcmToken,
    androidId: androidId,
  );

  return await remoteDataSource.login(request);
}
 @override
  Future<ResetPasswordResponseModel> resetPassword(
    ResetPasswordRequestModel request,
  ) {
    return remoteDataSource.resetPassword(request);
  }
}