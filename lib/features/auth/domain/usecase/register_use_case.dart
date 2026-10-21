import 'package:dartz/dartz.dart';
import 'package:star_drive/core/error/failure.dart';

import '../entities/auth_user.dart';
import '../repository/auth_repoitory.dart';

class RegisterUser {
  final AuthRepository repository;

  const RegisterUser(this.repository);

  Future<Either<Failure, AuthUser>> call({
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
  }) {
    return repository.registerWithDetails(
      name: name,
      contactNumber: contactNumber,
      role: role,
      password: password,
      otpCode: otpCode,
      fcmToken: fcmToken,
      androidId: androidId,
      fatherName: fatherName,
      cnic: cnic,
      address: address,
      dob: dob,
    );
  }
}
