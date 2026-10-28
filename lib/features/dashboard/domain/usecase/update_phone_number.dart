import 'package:star_drive/features/dashboard/data/model/number_update_model.dart';

import 'package:star_drive/features/dashboard/domain/repository/user_profile_repositories.dart';

class UpdatePhoneNumber {
  final UserProfileRepository repository;

  UpdatePhoneNumber({required this.repository});

  Future<void> call(UpdatePhoneNumberModel model) async {
    await repository.updatePhoneNumber(model);
  }
}
