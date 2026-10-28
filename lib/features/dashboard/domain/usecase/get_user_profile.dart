
import 'package:star_drive/features/dashboard/domain/entities/user_profile.dart';
import 'package:star_drive/features/dashboard/domain/repository/user_profile_repositories.dart';

class GetUserProfile {
  final UserProfileRepository repository;

  GetUserProfile({
    required this.repository,
  });

  Future<UserProfile> call() async {
    return await repository.getUserProfile();
  }
}