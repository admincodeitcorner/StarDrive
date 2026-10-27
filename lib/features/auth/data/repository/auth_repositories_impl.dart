import 'package:dartz/dartz.dart';
import 'package:star_drive/core/error/failure.dart';
import 'package:star_drive/core/network/api_error_handler.dart';
import 'package:star_drive/core/network/error_mapper.dart';
import 'package:star_drive/core/storage/token_storage.dart';
import 'package:star_drive/features/auth/data/dataresource/remote/auth_remote_datasource.dart';
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
final TokenStorage tokenStorage;

AuthRepositoryImpl(
  this.remoteDataSource,
  this.tokenStorage,
);

  @override
  Future<Either<Failure, OtpDetails>> sendOtp({
    required String contactNumber,
    String? cnic,
    required OtpPurpose purpose,
  }) async {
    final result = await remoteDataSource.sendOtp(
      SendOtpRequestModel(
        contactNumber: contactNumber,
        cnic: cnic,
        purpose: purpose,
      ),
    );
    return result.fold((exception) => Left(ErrorMapper.map(exception)), (
      apiResponse,
    ) {
      final otpModel = apiResponse.data;

      if (otpModel == null) {
        return Left(UnexpectedFailure('OTP response data is missing.'));
      }

      return Right(otpModel);
    });
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
  Future<Either<Failure, AuthUser>> registerWithDetails({
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
      otpCode: otpCode,
    );

    final result = await remoteDataSource.register(request);
    return result.fold(
      (exception) => Left(ErrorMapper.map(exception)),
      (apiResponse) {
        final authModel = apiResponse.data;

        if (authModel == null) {
          return Left(UnexpectedFailure('Registration response data is missing.'));
        }

        return Right(authModel);
      },
    );
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


@override
Future<Either<Failure, Unit>> logout() async {
  try {
    await remoteDataSource.logout();

    await tokenStorage.clearToken();

    return Right(unit);
  } on Exception catch (exception) {
    return Left(ErrorMapper.map(exception));
  }
}
}
