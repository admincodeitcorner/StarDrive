import '../entities/auth_user.dart';

abstract interface class AuthRepository {
  Future<AuthUser> registerWithDetails({
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
  });
  
  Future<AuthUser> loginWithCredentials({
    required String contactNumber,
    required String password,
    required String fcmToken,
    required String androidId,
  });
}
