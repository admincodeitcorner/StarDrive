import 'package:star_drive/features/auth/data/model/reset_password_model.dart';
import 'package:star_drive/features/auth/data/model/reset_response_model.dart';
import 'package:star_drive/features/auth/domain/repository/auth_repoitory.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<ResetPasswordResponseModel> call(ResetPasswordRequestModel request) {
    return repository.resetPassword(request);
  }
}
