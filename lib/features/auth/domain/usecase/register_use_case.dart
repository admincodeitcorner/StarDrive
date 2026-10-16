import 'package:star_drive/features/auth/domain/repository/auth_repoitory.dart';

import '../entities/auth_user.dart';

class RegisterUser {
  final AuthRepository repository;

  const RegisterUser(this.repository);

  Future<AuthUser> call({
    required String name,
    required String fatherName,
    required String cnic,
    required String contactNumber,
    required String address,
    required String role,
    required String dob,
    required String password,
    required String fcmToken,
    required String androidId,
    required String otpCode,
  }) {
    return repository.registerWithDetails(
      name: name,
      fatherName: fatherName,
      cnic: cnic,
      contactNumber: contactNumber,
      address: address,
      role: role,
      dob: dob,
      password: password,
      otpCode: otpCode,
      fcmToken: fcmToken,
      androidId: androidId,
    );
  }
}
