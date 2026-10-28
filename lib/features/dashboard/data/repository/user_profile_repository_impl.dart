import 'package:star_drive/features/dashboard/data/model/number_update_model.dart';
import 'package:star_drive/features/dashboard/data/datasource/user_profile_remote_datasource.dart';

import 'package:star_drive/features/dashboard/domain/entities/user_profile.dart';
import 'package:star_drive/features/dashboard/domain/repository/user_profile_repositories.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileRemoteDataSource remoteDataSource;

  UserProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserProfile> getUserProfile() {
    return remoteDataSource.getUserProfile();
  }

  @override
  Future<void> updatePhoneNumber(UpdatePhoneNumberModel model) {
    return remoteDataSource.updatePhoneNumber(model);
  }
}
