
import 'package:hive_ce/hive.dart';

import 'package:star_drive/features/auth/domain/entities/auth_user.dart';

class UserLocalDataSource {
  final Box userBox;

  UserLocalDataSource(this.userBox);

  // Complete user data stored in hive 
  Future<void> saveAuthUser(AuthUser user) async {
    await userBox.put('authUser', {
      'id': user.id,
      'name': user.name,
      'contactNumber': user.contactNumber,
      'role': user.role,
      'isActive': user.isActive,
      'isApproved': user.isApproved,
      'passengerRating': user.passengerRating,
      'isDriver': user.isDriver,
      'totalEarning': user.totalEarning,
      'fcmToken': user.fcmToken,
      'androidId': user.androidId,
      'token': user.token,
      'fatherName': user.fatherName,
      'cnic': user.cnic,
      'address': user.address,
      'dob': user.dob,
      'driverStatus': user.driverStatus,
    });

    // Existing Drawer/Profile Setting code ke liye
    await userBox.put('userName', user.name);
  }

  // Complete user data Hive se read karna
  AuthUser? getAuthUser() {
    final savedData = userBox.get('authUser');

    if (savedData == null) {
      return null;
    }

    final data = Map<String, dynamic>.from(savedData);

    return AuthUser(
      id: (data['id'] as num).toInt(),
      name: data['name'] as String,
      contactNumber: data['contactNumber'] as String,
      role: data['role'] as String,
      isActive: data['isActive'] as bool,
      isApproved: data['isApproved'] as bool,
      passengerRating:
          (data['passengerRating'] as num).toDouble(),
      isDriver: data['isDriver'] as bool,
      totalEarning:
          (data['totalEarning'] as num).toDouble(),
      fcmToken: data['fcmToken'] as String,
      androidId: data['androidId'] as String,
      token: data['token'] as String,
      fatherName: data['fatherName'] as String?,
      cnic: data['cnic'] as String?,
      address: data['address'] as String?,
      dob: data['dob'] as String?,
      driverStatus: data['driverStatus'] as String?,
    );
  }
}
