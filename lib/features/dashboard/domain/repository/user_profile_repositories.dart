
import 'package:star_drive/features/dashboard/data/model/number_update_model.dart';
import 'package:star_drive/features/dashboard/domain/entities/user_profile.dart';


abstract class UserProfileRepository {
  Future<UserProfile> getUserProfile();

  Future<void> updatePhoneNumber(
    UpdatePhoneNumberModel model,
  );
}
