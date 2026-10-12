import 'package:star_drive/features/auth/domain/repository/auth_repoitory.dart';

import '../entities/auth_user.dart';


class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<AuthUser> call({
    required String contactNumber,
    required String password,
    required String fcmToken,
    required String androidId,
  }) {
    return repository.loginWithCredentials(
      contactNumber: contactNumber,
      password: password,
      fcmToken: fcmToken,
      androidId: androidId,
    );
  }
}