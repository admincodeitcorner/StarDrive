import '../../domain/entities/auth_user.dart';

class AuthResponseModel extends AuthUser {
  const AuthResponseModel({
    required super.id,
    required super.name,
    required super.contactNumber,
    required super.role,
    required super.isActive,
    required super.isApproved,
    required super.passengerRating,
    required super.isDriver,
    required super.totalEarning,
    required super.fcmToken,
    required super.androidId,
    required super.token,
    super.fatherName,
    super.cnic,
    super.address,
    super.dob,
    super.driverStatus,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      contactNumber: json['contactNumber'] as String,
      role: json['role'] as String,
      isActive: json['isActive'] as bool,
      isApproved: json['isApproved'] as bool,
      passengerRating: (json['passengerRating'] as num).toDouble(),
      isDriver: json['isDriver'] as bool,
      totalEarning: (json['totalEarning'] as num).toDouble(),
      fcmToken: json['fcmToken'] as String,
      androidId: json['androidId'] as String,
      token: json['token'] as String,
      fatherName: json['fatherName'] as String?,
      cnic: json['cnic'] as String?,
      address: json['address'] as String?,
      dob: json['dob'] as String?,
      driverStatus: json['driverStatus'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'contactNumber': contactNumber,
      'role': role,
      'isActive': isActive,
      'isApproved': isApproved,
      'passengerRating': passengerRating,
      'isDriver': isDriver,
      'totalEarning': totalEarning,
      'fcmToken': fcmToken,
      'androidId': androidId,
      'token': token,
      'fatherName': fatherName,
      'cnic': cnic,
      'address': address,
      'dob': dob,
      'driverStatus': driverStatus,
    };
  }

factory AuthResponseModel.fromEntity(AuthUser u) {
    return AuthResponseModel(
      id: u.id,
      name: u.name,
      contactNumber: u.contactNumber,
      role: u.role,
      isActive: u.isActive,
      isApproved: u.isApproved,
      passengerRating: u.passengerRating,
      isDriver: u.isDriver,
      totalEarning: u.totalEarning,
      fcmToken: u.fcmToken,
      androidId: u.androidId,
      token: u.token,
      fatherName: u.fatherName,
      cnic: u.cnic,
      address: u.address,
      dob: u.dob,
      driverStatus: u.driverStatus,
    );
  }

}
